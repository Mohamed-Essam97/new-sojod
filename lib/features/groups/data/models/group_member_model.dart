import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/group_member_entity.dart';

class GroupMemberModel extends GroupMemberEntity {
  const GroupMemberModel({
    required super.uid,
    required super.displayName,
    required super.role,
    super.photoUrl,
    super.joinedAt,
  });

  factory GroupMemberModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroupMemberModel(
      uid: doc.id,
      displayName: data['displayName'] ?? '',
      role: data['role'] ?? 'member',
      photoUrl: data['photoUrl'],
      joinedAt: (data['joinedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'role': role,
      'photoUrl': photoUrl,
      'joinedAt': joinedAt != null ? Timestamp.fromDate(joinedAt!) : FieldValue.serverTimestamp(),
    };
  }
}
