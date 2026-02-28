import '../repositories/auth_repository.dart';

class UpdateProfile {
  UpdateProfile(this._repository);

  final AuthRepository _repository;

  Future<void> call({String? displayName, String? photoUrl}) {
    return _repository.updateProfile(
      displayName: displayName,
      photoUrl: photoUrl,
    );
  }
}
