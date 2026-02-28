import '../repositories/auth_repository.dart';

class UploadProfileImage {
  UploadProfileImage(this._repository);

  final AuthRepository _repository;

  Future<String> call(String filePath) => _repository.uploadProfileImage(filePath);
}
