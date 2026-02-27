import 'package:equatable/equatable.dart';

import 'mood.dart';

class MoodRecommendation extends Equatable {
  final Mood mood;
  final List<DuaRecommendation> duas;
  final List<AyahRecommendation> ayahs;
  final List<DhikrRecommendation> dhikr;

  const MoodRecommendation({
    required this.mood,
    required this.duas,
    required this.ayahs,
    required this.dhikr,
  });

  @override
  List<Object?> get props => [mood, duas, ayahs, dhikr];
}

class DuaRecommendation extends Equatable {
  final String arabic;
  final String transliteration;
  final String translation;

  const DuaRecommendation({
    required this.arabic,
    required this.transliteration,
    required this.translation,
  });

  @override
  List<Object?> get props => [arabic, transliteration, translation];
}

class AyahRecommendation extends Equatable {
  final String arabic;
  final String translation;
  final String reference;

  const AyahRecommendation({
    required this.arabic,
    required this.translation,
    required this.reference,
  });

  @override
  List<Object?> get props => [arabic, translation, reference];
}

class DhikrRecommendation extends Equatable {
  final String arabic;
  final String transliteration;
  final String translation;
  final int? count;

  const DhikrRecommendation({
    required this.arabic,
    required this.transliteration,
    required this.translation,
    this.count,
  });

  @override
  List<Object?> get props => [arabic, transliteration, translation, count];
}
