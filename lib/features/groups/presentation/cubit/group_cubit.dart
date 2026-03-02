import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_group.dart';
import '../../domain/usecases/create_invite.dart';
import '../../domain/usecases/get_group_members.dart';
import '../../domain/usecases/get_user_groups.dart';
import '../../domain/usecases/join_group.dart';
import '../../domain/repositories/group_repository.dart';
import 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit({
    required CreateGroup createGroup,
    required GetUserGroups getUserGroups,
    required CreateInvite createInvite,
    required JoinGroup joinGroup,
    required GetGroupMembers getGroupMembers,
    required GroupRepository groupRepository,
  })  : _createGroup = createGroup,
        _getUserGroups = getUserGroups,
        _createInvite = createInvite,
        _joinGroup = joinGroup,
        _getGroupMembers = getGroupMembers,
        _groupRepository = groupRepository,
        super(const GroupInitial());

  final CreateGroup _createGroup;
  final GetUserGroups _getUserGroups;
  final CreateInvite _createInvite;
  // ignore: unused_field - kept for direct join flows / tests
  final JoinGroup _joinGroup;
  final GetGroupMembers _getGroupMembers;
  final GroupRepository _groupRepository;

  Future<void> loadUserGroups(String userId) async {
    emit(const GroupLoading());
    try {
      final groups = await _getUserGroups(userId);
      emit(GroupsLoaded(groups));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> createNewGroup({
    required String name,
    required String ownerId,
    String? photoUrl,
    String? description,
  }) async {
    try {
      await _createGroup(
        name: name,
        ownerId: ownerId,
        photoUrl: photoUrl,
        description: description,
      );
      emit(const GroupSuccess('Group created successfully'));
      await loadUserGroups(ownerId);
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<String?> generateInviteCode(String groupId, String userId) async {
    try {
      final invite = await _createInvite(
        groupId: groupId,
        createdBy: userId,
        expiresAt: DateTime.now().add(const Duration(days: 7)),
      );
      return invite.code;
    } catch (e) {
      emit(GroupError(e.toString()));
      return null;
    }
  }

  Future<void> joinGroupWithCode({
    required String code,
    required String userId,
    required String displayName,
    String? photoUrl,
  }) async {
    try {
      // Use Cloud Function so invite lookup is not blocked by client Firestore rules
      final newlyJoined = await _groupRepository.joinGroupByCodeCallable(
        code: code,
        userId: userId,
        displayName: displayName,
        photoUrl: photoUrl,
      );

      emit(newlyJoined
          ? const GroupSuccess('Joined group successfully')
          : const GroupSuccess('You are already a member of this group'));
      await loadUserGroups(userId);
    } on FirebaseFunctionsException catch (e, stack) {
      debugPrint(
        'Join group callable error: ${e.code} - ${e.message}\n$stack',
      );
      switch (e.code) {
        case 'not-found':
          emit(GroupError(
            e.message?.isNotEmpty == true
                ? e.message!
                : 'Invalid invite code',
          ));
          break;
        case 'failed-precondition':
          emit(GroupError(
            e.message?.isNotEmpty == true
                ? e.message!
                : 'Invite expired or usage limit reached',
          ));
          break;
        case 'invalid-argument':
          emit(const GroupError('Invalid invite code'));
          break;
        case 'unauthenticated':
          emit(const GroupError('Please sign in to join a group'));
          break;
        case 'permission-denied':
          emit(const GroupError('You do not have permission to join this group'));
          break;
        default:
          emit(GroupError(
            e.message?.isNotEmpty == true
                ? e.message!
                : 'Failed to join group. Please try again.',
          ));
      }
    } on FirebaseException catch (e, stack) {
      debugPrint('Firebase join group error: ${e.code} - ${e.message}\n$stack');
      if (e.code == 'permission-denied') {
        emit(const GroupError('You do not have permission to join this group'));
      } else {
        emit(GroupError('Failed to join group. ${e.message ?? e.code}'));
      }
    } catch (e, stack) {
      debugPrint('Unknown join group error: $e\n$stack');
      emit(const GroupError('Failed to join group. Please try again.'));
    }
  }

  Future<void> loadGroupDetails(String groupId) async {
    emit(const GroupLoading());
    try {
      final group = await _groupRepository.getGroup(groupId);
      if (group == null) {
        emit(const GroupError('Group not found'));
        return;
      }

      final members = await _getGroupMembers(groupId);
      emit(GroupDetailsLoaded(group, members));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }
}
