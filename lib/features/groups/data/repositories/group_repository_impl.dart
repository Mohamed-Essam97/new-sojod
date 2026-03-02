import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../domain/entities/group_entity.dart';
import '../../domain/entities/group_member_entity.dart';
import '../../domain/entities/invite_entity.dart';
import '../../domain/repositories/group_repository.dart';
import '../models/group_member_model.dart';
import '../models/group_model.dart';
import '../models/invite_model.dart';

class GroupRepositoryImpl implements GroupRepository {
  GroupRepositoryImpl({
    required FirebaseFirestore firestore,
    FirebaseFunctions? functions,
  })  : _firestore = firestore,
        _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

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

    await _firestore
        .collection('users')
        .doc(ownerId)
        .collection('memberships')
        .doc(groupDoc.id)
        .set({'groupId': groupDoc.id, 'joinedAt': FieldValue.serverTimestamp()});

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
    final batch = _firestore.batch();
    for (final doc in membersSnapshot.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(groupDoc);
    await batch.commit();
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

    final groups =
        groupsQuery.docs.map((doc) => GroupModel.fromFirestore(doc)).toList();
    final seenIds = groups.map((g) => g.id).toSet();

    final membershipsSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('memberships')
        .get();

    for (final doc in membershipsSnapshot.docs) {
      final groupId = doc.id;
      if (seenIds.contains(groupId)) continue;
      seenIds.add(groupId);
      final groupDoc =
          await _firestore.collection('groups').doc(groupId).get();
      if (groupDoc.exists) {
        groups.add(GroupModel.fromFirestore(groupDoc));
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
        .where('code', isEqualTo: code)
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
        .where('code', isEqualTo: code)
        .limit(1)
        .get();

    if (invitesSnapshot.docs.isNotEmpty) {
      final inviteDoc = invitesSnapshot.docs.first;
      await inviteDoc.reference.update({'uses': FieldValue.increment(1)});
    }
  }

  @override
  Future<bool> joinGroupByCodeCallable({
    required String code,
    required String userId,
    required String displayName,
    String? photoUrl,
  }) async {
    final callable = _functions.httpsCallable('joinGroupWithCode');
    final result = await callable.call<Map<dynamic, dynamic>>({
      'code': code,
      'displayName': displayName,
      'photoUrl': photoUrl,
    });
    final data = result.data as Map<dynamic, dynamic>? ?? {};
    final alreadyMember = data['alreadyMember'] as bool? ?? false;
    return !alreadyMember;
  }

  @override
  Future<void> joinGroup(
    String groupId,
    String userId,
    String displayName,
    String? photoUrl, {
    String? inviteCode,
  }) async {
    // Fallback for legacy/direct joins without an invite code
    if (inviteCode == null) {
      final memberDoc = _firestore.collection('groups').doc(groupId).collection('members').doc(userId);
      final member = GroupMemberModel(
        uid: userId,
        displayName: displayName,
        role: 'member',
        photoUrl: photoUrl,
        joinedAt: DateTime.now(),
      );
      await memberDoc.set(member.toFirestore());
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('memberships')
          .doc(groupId)
          .set({'groupId': groupId, 'joinedAt': FieldValue.serverTimestamp()});
      return;
    }

    var alreadyMember = false;

    await _firestore.runTransaction((transaction) async {
      final groupRef = _firestore.collection('groups').doc(groupId);
      final groupSnap = await transaction.get(groupRef);

      if (!groupSnap.exists) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'group-not-found',
          message: 'Group not found for invite.',
        );
      }

      final memberRef = groupRef.collection('members').doc(userId);
      final membershipRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('memberships')
          .doc(groupId);

      final memberSnap = await transaction.get(memberRef);

      final inviteRef = groupRef.collection('invites').doc(inviteCode);
      final inviteSnap = await transaction.get(inviteRef);

      if (!inviteSnap.exists) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'invalid-invite',
          message: 'Invite not found.',
        );
      }

      final data = inviteSnap.data() ?? <String, dynamic>{};
      final int maxUses = (data['maxUses'] ?? 20) as int;
      final int uses = (data['uses'] ?? 0) as int;
      final Timestamp? expiresTs = data['expiresAt'] as Timestamp?;
      final DateTime? expiresAt = expiresTs?.toDate();
      final now = DateTime.now();

      if (expiresAt != null && now.isAfter(expiresAt)) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'invite-expired',
          message: 'Invite has expired.',
        );
      }

      if (uses >= maxUses) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'invite-maxed',
          message: 'Invite has reached its maximum number of uses.',
        );
      }

      if (memberSnap.exists) {
        // User is already a member – keep this idempotent and ensure membership exists
        alreadyMember = true;
        transaction.set(
          membershipRef,
          {
            'groupId': groupId,
            'joinedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
        return;
      }

      final member = GroupMemberModel(
        uid: userId,
        displayName: displayName,
        role: 'member',
        photoUrl: photoUrl,
        joinedAt: DateTime.now(),
      );

      transaction.set(memberRef, member.toFirestore());
      transaction.set(membershipRef, {
        'groupId': groupId,
        'joinedAt': FieldValue.serverTimestamp(),
      });
      transaction.update(inviteRef, {'uses': FieldValue.increment(1)});
    });

    if (alreadyMember) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'already-member',
        message: 'User is already a member of this group.',
      );
    }
  }

  @override
  Future<void> leaveGroup(String groupId, String userId) async {
    final batch = _firestore.batch();
    batch.delete(
        _firestore.collection('groups').doc(groupId).collection('members').doc(userId));
    batch.delete(_firestore
        .collection('users')
        .doc(userId)
        .collection('memberships')
        .doc(groupId));
    await batch.commit();
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
