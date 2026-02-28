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
      final invite = await _groupRepository.getInviteByCode(code);
      if (invite == null) {
        emit(const GroupError('Invalid invite code'));
        return;
      }

      if (!invite.isValid) {
        emit(const GroupError('Invite code expired or maxed out'));
        return;
      }

      await _joinGroup(
        groupId: invite.groupId,
        userId: userId,
        displayName: displayName,
        photoUrl: photoUrl,
      );

      await _groupRepository.useInvite(code);
      emit(const GroupSuccess('Joined group successfully'));
      await loadUserGroups(userId);
    } catch (e) {
      emit(GroupError(e.toString()));
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
