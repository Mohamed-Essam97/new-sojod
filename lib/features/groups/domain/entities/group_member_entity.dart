import 'package:equatable/equatable.dart';

class GroupMemberEntity extends Equatable {
  const GroupMemberEntity({
    required this.uid,
    required this.displayName,
    required this.role,
    this.photoUrl,
    this.joinedAt,
  });

  final String uid;
  final String displayName;
  final String role;
  final String? photoUrl;
  final DateTime? joinedAt;

  bool get isOwner => role == 'owner';
  bool get isAdmin => role == 'admin';
  bool get isMember => role == 'member';

  GroupMemberEntity copyWith({
    String? uid,
    String? displayName,
    String? role,
    String? photoUrl,
    DateTime? joinedAt,
  }) {
    return GroupMemberEntity(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  @override
  List<Object?> get props => [uid, displayName, role, photoUrl, joinedAt];
}
