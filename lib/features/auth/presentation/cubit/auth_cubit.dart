import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/upload_profile_image.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required SignInWithGoogle signInWithGoogle,
    required SignOut signOut,
    required GetCurrentUser getCurrentUser,
    required UpdateProfile updateProfile,
    required UploadProfileImage uploadProfileImage,
    required AuthRepository authRepository,
  })  : _signInWithGoogle = signInWithGoogle,
        _signOut = signOut,
        _getCurrentUser = getCurrentUser,
        _updateProfile = updateProfile,
        _uploadProfileImage = uploadProfileImage,
        _authRepository = authRepository,
        super(const AuthInitial()) {
    _authStateSubscription = _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    });
  }

  final SignInWithGoogle _signInWithGoogle;
  final SignOut _signOut;
  final GetCurrentUser _getCurrentUser;
  final UpdateProfile _updateProfile;
  final UploadProfileImage _uploadProfileImage;
  final AuthRepository _authRepository;

  StreamSubscription? _authStateSubscription;

  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());
    try {
      final user = await _getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signInWithGoogleMethod() async {
    emit(const AuthLoading());
    try {
      final user = await _signInWithGoogle();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthError('Google sign in cancelled'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOutMethod() async {
    emit(const AuthLoading());
    try {
      await _signOut();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> updateUserProfile({String? displayName, String? photoUrl}) async {
    try {
      await _updateProfile(displayName: displayName, photoUrl: photoUrl);
      final user = await _getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> uploadAndUpdateProfileImage(String filePath) async {
    try {
      emit(const AuthLoading());
      final photoUrl = await _uploadProfileImage(filePath);
      await _updateProfile(photoUrl: photoUrl);
      final user = await _getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
