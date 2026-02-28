import '../entities/group_entity.dart';
import '../entities/group_member_entity.dart';
import '../entities/invite_entity.dart';

abstract class GroupRepository {
  Future<GroupEntity> createGroup({
    required String name,
    required String ownerId,
    String? photoUrl,
    String? description,
    String privacy = 'private',
  });
  
  Future<void> updateGroup(GroupEntity group);
  Future<void> deleteGroup(String groupId);
  Future<GroupEntity?> getGroup(String groupId);
  Future<List<GroupEntity>> getUserGroups(String userId);
  Stream<List<GroupEntity>> watchUserGroups(String userId);
  
  Future<InviteEntity> createInvite({
    required String groupId,
    required String createdBy,
    DateTime? expiresAt,
    int maxUses = 20,
  });
  
  Future<InviteEntity?> getInviteByCode(String code);
  Future<void> useInvite(String code);
  
  Future<void> joinGroup(String groupId, String userId, String displayName, String? photoUrl);
  Future<void> leaveGroup(String groupId, String userId);
  Future<List<GroupMemberEntity>> getGroupMembers(String groupId);
  Stream<List<GroupMemberEntity>> watchGroupMembers(String groupId);
  Future<void> updateMemberRole(String groupId, String userId, String role);
}
