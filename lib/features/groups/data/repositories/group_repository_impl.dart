import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/group_entity.dart';
import '../../domain/entities/group_member_entity.dart';
import '../../domain/entities/invite_entity.dart';
import '../../domain/repositories/group_repository.dart';
import '../models/group_member_model.dart';
import '../models/group_model.dart';
import '../models/invite_model.dart';

class GroupRepositoryImpl implements GroupRepository {
  GroupRepositoryImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  String _generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
      6,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ));
  }

  @override
  Future<GroupEntity> createGroup({
    required String name,
    required String ownerId,
    String? photoUrl,
    String? description,
    String privacy = 'private',
  }) async {
    final groupDoc = _firestore.collection('groups').doc();
    final group = GroupModel(
      id: groupDoc.id,
      name: name,
      ownerId: ownerId,
      photoUrl: photoUrl,
      description: description,
      privacy: privacy,
      createdAt: DateTime.now(),
    );

    await groupDoc.set(group.toFirestore());

    final memberDoc = groupDoc.collection('members').doc(ownerId);
    final member = GroupMemberModel(
      uid: ownerId,
      displayName: '',
      role: 'owner',
      joinedAt: DateTime.now(),
    );
    await memberDoc.set(member.toFirestore());

    return group;
  }

  @override
  Future<void> updateGroup(GroupEntity group) async {
    final groupModel = GroupModel(
      id: group.id,
      name: group.name,
      ownerId: group.ownerId,
      photoUrl: group.photoUrl,
      description: group.description,
      privacy: group.privacy,
      createdAt: group.createdAt,
    );
    await _firestore.collection('groups').doc(group.id).update(groupModel.toFirestore());
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    final groupDoc = _firestore.collection('groups').doc(groupId);
    final membersSnapshot = await groupDoc.collection('members').get();
    for (final doc in membersSnapshot.docs) {
      await doc.reference.delete();
    }
    await groupDoc.delete();
  }

  @override
  Future<GroupEntity?> getGroup(String groupId) async {
    final doc = await _firestore.collection('groups').doc(groupId).get();
    if (doc.exists) {
      return GroupModel.fromFirestore(doc);
    }
    return null;
  }

  @override
  Future<List<GroupEntity>> getUserGroups(String userId) async {
    final groupsQuery = await _firestore
        .collection('groups')
        .where('ownerId', isEqualTo: userId)
        .get();

    final groups = groupsQuery.docs.map((doc) => GroupModel.fromFirestore(doc)).toList();

    final memberQuery = await _firestore
        .collectionGroup('members')
        .where(FieldPath.documentId, isEqualTo: userId)
        .get();

    for (final memberDoc in memberQuery.docs) {
      final groupId = memberDoc.reference.parent.parent?.id;
      if (groupId != null) {
        final groupDoc = await _firestore.collection('groups').doc(groupId).get();
        if (groupDoc.exists) {
          final group = GroupModel.fromFirestore(groupDoc);
          if (!groups.any((g) => g.id == group.id)) {
            groups.add(group);
          }
        }
      }
    }

    return groups;
  }

  @override
  Stream<List<GroupEntity>> watchUserGroups(String userId) {
    return _firestore
        .collection('groups')
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => GroupModel.fromFirestore(doc)).toList());
  }

  @override
  Future<InviteEntity> createInvite({
    required String groupId,
    required String createdBy,
    DateTime? expiresAt,
    int maxUses = 20,
  }) async {
    final code = _generateInviteCode();
    final inviteDoc = _firestore.collection('groups').doc(groupId).collection('invites').doc(code);
    
    final invite = InviteModel(
      code: code,
      groupId: groupId,
      createdBy: createdBy,
      expiresAt: expiresAt,
      maxUses: maxUses,
      uses: 0,
    );

    await inviteDoc.set(invite.toFirestore());
    return invite;
  }

  @override
  Future<InviteEntity?> getInviteByCode(String code) async {
    final invitesSnapshot = await _firestore.collectionGroup('invites')
        .where(FieldPath.documentId, isEqualTo: code)
        .limit(1)
        .get();

    if (invitesSnapshot.docs.isNotEmpty) {
      return InviteModel.fromFirestore(invitesSnapshot.docs.first);
    }
    return null;
  }

  @override
  Future<void> useInvite(String code) async {
    final invitesSnapshot = await _firestore.collectionGroup('invites')
        .where(FieldPath.documentId, isEqualTo: code)
        .limit(1)
        .get();

    if (invitesSnapshot.docs.isNotEmpty) {
      final inviteDoc = invitesSnapshot.docs.first;
      await inviteDoc.reference.update({'uses': FieldValue.increment(1)});
    }
  }

  @override
  Future<void> joinGroup(String groupId, String userId, String displayName, String? photoUrl) async {
    final memberDoc = _firestore.collection('groups').doc(groupId).collection('members').doc(userId);
    final member = GroupMemberModel(
      uid: userId,
      displayName: displayName,
      role: 'member',
      photoUrl: photoUrl,
      joinedAt: DateTime.now(),
    );
    await memberDoc.set(member.toFirestore());
  }

  @override
  Future<void> leaveGroup(String groupId, String userId) async {
    await _firestore.collection('groups').doc(groupId).collection('members').doc(userId).delete();
  }

  @override
  Future<List<GroupMemberEntity>> getGroupMembers(String groupId) async {
    final snapshot = await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('members')
        .get();

    return snapshot.docs.map((doc) => GroupMemberModel.fromFirestore(doc)).toList();
  }

  @override
  Stream<List<GroupMemberEntity>> watchGroupMembers(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .collection('members')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => GroupMemberModel.fromFirestore(doc)).toList());
  }

  @override
  Future<void> updateMemberRole(String groupId, String userId, String role) async {
    await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('members')
        .doc(userId)
        .update({'role': role});
  }
}
