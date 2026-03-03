import 'package:equatable/equatable.dart';

import 'hadith_entity.dart';

class ChapterEntity extends Equatable {
  const ChapterEntity({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.collectionId,
    required this.hadiths,
  });

  final String id;
  final String titleAr;
  final String titleEn;
  final String collectionId;
  final List<HadithEntity> hadiths;

  int get hadithCount => hadiths.length;

  @override
  List<Object?> get props => [id, titleAr, titleEn, collectionId, hadiths];
}
