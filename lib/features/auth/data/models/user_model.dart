import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.displayName,
    required super.email,
    super.photoUrl,
    super.createdAt,
    super.timezone,
  });

  factory UserModel.fromFirebaseUser(
    String uid,
    String displayName,
    String email,
    String? photoUrl,
  ) {
    return UserModel(
      uid: uid,
      displayName: displayName,
      email: email,
      photoUrl: photoUrl,
      createdAt: DateTime.now(),
      timezone: DateTime.now().timeZoneName,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      timezone: data['timezone'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'timezone': timezone ?? DateTime.now().timeZoneName,
    };
  }

  UserModel copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoUrl,
    DateTime? createdAt,
    String? timezone,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      timezone: timezone ?? this.timezone,
    );
  }
}
