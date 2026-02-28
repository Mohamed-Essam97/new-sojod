import '../entities/group_member_entity.dart';
import '../repositories/group_repository.dart';

class GetGroupMembers {
  GetGroupMembers(this._repository);

  final GroupRepository _repository;

  Future<List<GroupMemberEntity>> call(String groupId) => 
      _repository.getGroupMembers(groupId);
}
