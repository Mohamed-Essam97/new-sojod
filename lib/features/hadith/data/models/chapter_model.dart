import '../../domain/entities/chapter_entity.dart';
import 'hadith_model.dart';

class ChapterModel {
  const ChapterModel({
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
  final List<HadithModel> hadiths;

  factory ChapterModel.fromJson(Map<String, dynamic> json, String collectionId) {
    final list = json['hadiths'] as List<dynamic>? ?? [];
    final chId = json['id'] as String? ?? '';
    final titleAr = json['titleAr'] as String? ?? '';
    final titleEn = json['titleEn'] as String? ?? '';
    final hadiths = <HadithModel>[];
    for (var i = 0; i < list.length; i++) {
      final h = list[i] as Map<String, dynamic>;
      final hid = h['id'] as String? ?? '${collectionId}_${chId}_${i + 1}';
      hadiths.add(HadithModel.fromJson(
        {...h, 'id': hid},
        collectionId: collectionId,
        chapterId: chId,
        chapterTitleAr: titleAr,
        chapterTitleEn: titleEn,
      ));
    }
    return ChapterModel(
      id: chId,
      titleAr: titleAr,
      titleEn: titleEn,
      collectionId: collectionId,
      hadiths: hadiths,
    );
  }

  ChapterEntity toEntity(String? collectionNameAr, String? collectionNameEn) {
    return ChapterEntity(
      id: id,
      titleAr: titleAr,
      titleEn: titleEn,
      collectionId: collectionId,
      hadiths: hadiths.map((h) {
        final m = HadithModel(
          id: h.id,
          number: h.number,
          arabic: h.arabic,
          referenceAr: h.referenceAr,
          referenceEn: h.referenceEn,
          collectionId: h.collectionId,
          chapterId: h.chapterId,
          chapterTitleAr: titleAr,
          chapterTitleEn: titleEn,
          collectionNameAr: collectionNameAr,
          collectionNameEn: collectionNameEn,
        );
        return m.toEntity();
      }).toList(),
    );
  }
}
