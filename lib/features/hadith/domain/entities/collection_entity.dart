import 'package:equatable/equatable.dart';

import 'chapter_entity.dart';

class CollectionEntity extends Equatable {
  const CollectionEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.chapters,
  });

  final String id;
  final String nameAr;
  final String nameEn;
  final List<ChapterEntity> chapters;

  int get totalHadiths =>
      chapters.fold<int>(0, (sum, ch) => sum + ch.hadithCount);

  @override
  List<Object?> get props => [id, nameAr, nameEn, chapters];
}
