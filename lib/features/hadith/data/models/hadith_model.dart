import '../../domain/entities/hadith_entity.dart';

class HadithModel {
  const HadithModel({
    required this.id,
    required this.number,
    required this.arabic,
    required this.referenceAr,
    required this.referenceEn,
    required this.collectionId,
    required this.chapterId,
    this.chapterTitleAr,
    this.chapterTitleEn,
    this.collectionNameAr,
    this.collectionNameEn,
  });

  final String id;
  final int number;
  final String arabic;
  final String referenceAr;
  final String referenceEn;
  final String collectionId;
  final String chapterId;
  final String? chapterTitleAr;
  final String? chapterTitleEn;
  final String? collectionNameAr;
  final String? collectionNameEn;

  factory HadithModel.fromJson(
    Map<String, dynamic> json, {
    required String collectionId,
    required String chapterId,
    String? chapterTitleAr,
    String? chapterTitleEn,
    String? collectionNameAr,
    String? collectionNameEn,
  }) {
    final numVal = (json['number'] as num?)?.toInt() ?? 0;
    final rawId = json['id'] as String?;
    final id = rawId ?? '${collectionId}_${chapterId}_$numVal';
    return HadithModel(
      id: id,
      number: numVal,
      arabic: json['arabic'] as String? ?? '',
      referenceAr: json['referenceAr'] as String? ?? '',
      referenceEn: json['referenceEn'] as String? ?? '',
      collectionId: collectionId,
      chapterId: chapterId,
      chapterTitleAr: chapterTitleAr,
      chapterTitleEn: chapterTitleEn,
      collectionNameAr: collectionNameAr,
      collectionNameEn: collectionNameEn,
    );
  }

  HadithEntity toEntity() {
    return HadithEntity(
      id: id,
      number: number,
      arabic: arabic,
      referenceAr: referenceAr,
      referenceEn: referenceEn,
      collectionId: collectionId,
      chapterId: chapterId,
      chapterTitleAr: chapterTitleAr,
      chapterTitleEn: chapterTitleEn,
      collectionNameAr: collectionNameAr,
      collectionNameEn: collectionNameEn,
    );
  }
}
