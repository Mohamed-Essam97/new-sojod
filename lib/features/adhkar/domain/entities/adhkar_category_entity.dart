import 'package:equatable/equatable.dart';

class AdhkarCategoryEntity extends Equatable {
  final String id;
  final String nameEn;
  final String nameAr;
  final List<DhikrEntity> dhikrs;

  const AdhkarCategoryEntity({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.dhikrs,
  });

  @override
  List<Object?> get props => [id, nameEn, nameAr, dhikrs];
}

class DhikrEntity extends Equatable {
  final String arabic;
  final String? transliteration;
  final String? translation;
  final int count;

  const DhikrEntity({
    required this.arabic,
    this.transliteration,
    this.translation,
    this.count = 1,
  });

  @override
  List<Object?> get props => [arabic, transliteration, translation, count];
}
