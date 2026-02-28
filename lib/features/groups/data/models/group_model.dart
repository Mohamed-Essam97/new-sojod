import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/group_entity.dart';

class GroupModel extends GroupEntity {
  const GroupModel({
    required super.id,
    required super.name,
    required super.ownerId,
    super.photoUrl,
    super.description,
    super.privacy,
    super.createdAt,
  });

  factory GroupModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroupModel(
      id: doc.id,
      name: data['name'] ?? '',
      ownerId: data['ownerId'] ?? '',
      photoUrl: data['photoUrl'],
      description: data['description'],
      privacy: data['privacy'] ?? 'private',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'ownerId': ownerId,
      'photoUrl': photoUrl,
      'description': description,
      'privacy': privacy,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}
