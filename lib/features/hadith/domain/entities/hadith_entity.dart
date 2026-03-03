import 'package:equatable/equatable.dart';

class HadithEntity extends Equatable {
  const HadithEntity({
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

  /// Short excerpt for list/card (first ~80 chars of Arabic).
  String get excerpt {
    const maxLen = 80;
    if (arabic.length <= maxLen) return arabic;
    return '${arabic.substring(0, maxLen)}...';
  }

  @override
  List<Object?> get props => [id, number, arabic, referenceAr, referenceEn, collectionId, chapterId];
}
