import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
    this.createdAt,
    this.timezone,
  });

  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;
  final DateTime? createdAt;
  final String? timezone;

  UserEntity copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoUrl,
    DateTime? createdAt,
    String? timezone,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      timezone: timezone ?? this.timezone,
    );
  }

  @override
  List<Object?> get props => [uid, displayName, email, photoUrl, createdAt, timezone];
}
