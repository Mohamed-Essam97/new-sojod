import '../repositories/group_repository.dart';

class JoinGroup {
  JoinGroup(this._repository);

  final GroupRepository _repository;

  Future<void> call({
    required String groupId,
    required String userId,
    required String displayName,
    String? photoUrl,
    String? inviteCode,
  }) {
    return _repository.joinGroup(
      groupId,
      userId,
      displayName,
      photoUrl,
      inviteCode: inviteCode,
    );
  }
}
