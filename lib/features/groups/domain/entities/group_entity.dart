import 'package:equatable/equatable.dart';

class GroupEntity extends Equatable {
  const GroupEntity({
    required this.id,
    required this.name,
    required this.ownerId,
    this.photoUrl,
    this.description,
    this.privacy = 'private',
    this.createdAt,
  });

  final String id;
  final String name;
  final String ownerId;
  final String? photoUrl;
  final String? description;
  final String privacy;
  final DateTime? createdAt;

  GroupEntity copyWith({
    String? id,
    String? name,
    String? ownerId,
    String? photoUrl,
    String? description,
    String? privacy,
    DateTime? createdAt,
  }) {
    return GroupEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      photoUrl: photoUrl ?? this.photoUrl,
      description: description ?? this.description,
      privacy: privacy ?? this.privacy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, ownerId, photoUrl, description, privacy, createdAt];
}
