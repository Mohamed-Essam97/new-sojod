import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
    required FacebookAuth facebookAuth,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore,
        _googleSignIn = googleSignIn,
        _facebookAuth = facebookAuth;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;

  @override
  Future<UserEntity?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      
      if (firebaseUser == null) return null;

      final userModel = UserModel.fromFirebaseUser(
        firebaseUser.uid,
        firebaseUser.displayName ?? googleUser.displayName ?? 'User',
        firebaseUser.email ?? googleUser.email,
        firebaseUser.photoURL,
      );

      await _saveUserToFirestore(userModel);
      return userModel;
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  @override
  Future<UserEntity?> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await _facebookAuth.login(
        permissions: ['email', 'public_profile'],
      );

      if (loginResult.status != LoginStatus.success) {
        return null;
      }

      final accessToken = loginResult.accessToken;
      if (accessToken == null) return null;

      final credential = FacebookAuthProvider.credential(accessToken.token);

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      
      if (firebaseUser == null) return null;

      final userData = await _facebookAuth.getUserData();

      final userModel = UserModel.fromFirebaseUser(
        firebaseUser.uid,
        firebaseUser.displayName ?? userData['name'] ?? 'User',
        firebaseUser.email ?? userData['email'] ?? '',
        firebaseUser.photoURL ?? userData['picture']?['data']?['url'],
      );

      await _saveUserToFirestore(userModel);
      return userModel;
    } catch (e) {
      throw Exception('Facebook sign in failed: $e');
    }
  }

  Future<void> _saveUserToFirestore(UserModel user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final docSnapshot = await userDoc.get();
    
    if (!docSnapshot.exists) {
      await userDoc.set(user.toFirestore());
    } else {
      await userDoc.update({
        'displayName': user.displayName,
        'photoUrl': user.photoUrl,
      });
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
      _facebookAuth.logOut(),
    ]);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;

    try {
      final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      
      try {
        final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
        if (userDoc.exists) {
          return UserModel.fromFirestore(userDoc);
        }
        return null;
      } catch (e) {
        return null;
      }
    });
  }

  @override
  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return;

    await firebaseUser.updateDisplayName(displayName);
    await firebaseUser.updatePhotoURL(photoUrl);

    await _firestore.collection('users').doc(firebaseUser.uid).update({
      if (displayName != null) 'displayName': displayName,
      if (photoUrl != null) 'photoUrl': photoUrl,
    });
  }
}
