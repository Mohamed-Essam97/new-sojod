import '../../domain/entities/collection_entity.dart';
import 'chapter_model.dart';

class CollectionModel {
  const CollectionModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.chapters,
  });

  final String id;
  final String nameAr;
  final String nameEn;
  final List<ChapterModel> chapters;

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String? ?? '';
    final list = json['chapters'] as List<dynamic>? ?? [];
    final chapters = list
        .map((c) => ChapterModel.fromJson(c as Map<String, dynamic>, id))
        .toList();
    return CollectionModel(
      id: id,
      nameAr: json['nameAr'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? '',
      chapters: chapters,
    );
  }

  CollectionEntity toEntity() {
    return CollectionEntity(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      chapters: chapters.map((c) => c.toEntity(nameAr, nameEn)).toList(),
    );
  }
}
