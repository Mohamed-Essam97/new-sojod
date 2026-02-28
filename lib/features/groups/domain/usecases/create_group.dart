import '../entities/group_entity.dart';
import '../repositories/group_repository.dart';

class CreateGroup {
  CreateGroup(this._repository);

  final GroupRepository _repository;

  Future<GroupEntity> call({
    required String name,
    required String ownerId,
    String? photoUrl,
    String? description,
    String privacy = 'private',
  }) {
    return _repository.createGroup(
      name: name,
      ownerId: ownerId,
      photoUrl: photoUrl,
      description: description,
      privacy: privacy,
    );
  }
}
