import 'package:equatable/equatable.dart';

class InviteEntity extends Equatable {
  const InviteEntity({
    required this.code,
    required this.groupId,
    required this.createdBy,
    this.expiresAt,
    this.maxUses = 20,
    this.uses = 0,
  });

  final String code;
  final String groupId;
  final String createdBy;
  final DateTime? expiresAt;
  final int maxUses;
  final int uses;

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  bool get isMaxed => uses >= maxUses;
  bool get isValid => !isExpired && !isMaxed;

  InviteEntity copyWith({
    String? code,
    String? groupId,
    String? createdBy,
    DateTime? expiresAt,
    int? maxUses,
    int? uses,
  }) {
    return InviteEntity(
      code: code ?? this.code,
      groupId: groupId ?? this.groupId,
      createdBy: createdBy ?? this.createdBy,
      expiresAt: expiresAt ?? this.expiresAt,
      maxUses: maxUses ?? this.maxUses,
      uses: uses ?? this.uses,
    );
  }

  @override
  List<Object?> get props => [code, groupId, createdBy, expiresAt, maxUses, uses];
}
