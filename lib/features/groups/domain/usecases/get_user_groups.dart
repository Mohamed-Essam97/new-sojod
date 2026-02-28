import '../entities/group_entity.dart';
import '../repositories/group_repository.dart';

class GetUserGroups {
  GetUserGroups(this._repository);

  final GroupRepository _repository;

  Future<List<GroupEntity>> call(String userId) => _repository.getUserGroups(userId);
}
