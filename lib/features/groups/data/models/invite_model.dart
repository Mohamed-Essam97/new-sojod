import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/invite_entity.dart';

class InviteModel extends InviteEntity {
  const InviteModel({
    required super.code,
    required super.groupId,
    required super.createdBy,
    super.expiresAt,
    super.maxUses,
    super.uses,
  });

  factory InviteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InviteModel(
      code: doc.id,
      groupId: data['groupId'] ?? '',
      createdBy: data['createdBy'] ?? '',
      expiresAt: (data['expiresAt'] as Timestamp?)?.toDate(),
      maxUses: data['maxUses'] ?? 20,
      uses: data['uses'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'groupId': groupId,
      'createdBy': createdBy,
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
      'maxUses': maxUses,
      'uses': uses,
    };
  }
}
