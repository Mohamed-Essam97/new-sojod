import '../entities/invite_entity.dart';
import '../repositories/group_repository.dart';

class CreateInvite {
  CreateInvite(this._repository);

  final GroupRepository _repository;

  Future<InviteEntity> call({
    required String groupId,
    required String createdBy,
    DateTime? expiresAt,
    int maxUses = 20,
  }) {
    return _repository.createInvite(
      groupId: groupId,
      createdBy: createdBy,
      expiresAt: expiresAt,
      maxUses: maxUses,
    );
  }
}
