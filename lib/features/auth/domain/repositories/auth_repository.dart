import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> signInWithGoogle();
  Future<UserEntity?> signInWithFacebook();
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
  Stream<UserEntity?> get authStateChanges;
  Future<void> updateProfile({String? displayName, String? photoUrl});
  Future<String> uploadProfileImage(String filePath);
}
