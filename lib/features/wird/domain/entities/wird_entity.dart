import 'package:equatable/equatable.dart';

class WirdEntity extends Equatable {
  const WirdEntity({
    required this.date,
    this.quranTargetPages = 0,
    this.quranProgressPages = 0,
    this.adhkarMorningDone = false,
    this.adhkarEveningDone = false,
    this.sleepDhikrDone = false,
    this.tasbeehTarget = 0,
    this.tasbeehProgress = 0,
    this.updatedAt,
  });

  final DateTime date;
  final int quranTargetPages;
  final int quranProgressPages;
  final bool adhkarMorningDone;
  final bool adhkarEveningDone;
  final bool sleepDhikrDone;
  final int tasbeehTarget;
  final int tasbeehProgress;
  final DateTime? updatedAt;

  bool get isQuranComplete => quranProgressPages >= quranTargetPages && quranTargetPages > 0;
  bool get isTasbeehComplete => tasbeehProgress >= tasbeehTarget && tasbeehTarget > 0;
  bool get isAdhkarComplete => adhkarMorningDone && adhkarEveningDone && sleepDhikrDone;
  
  double get quranProgress => quranTargetPages > 0 ? quranProgressPages / quranTargetPages : 0;
  double get tasbeehProgressPercent => tasbeehTarget > 0 ? tasbeehProgress / tasbeehTarget : 0;

  WirdEntity copyWith({
    DateTime? date,
    int? quranTargetPages,
    int? quranProgressPages,
    bool? adhkarMorningDone,
    bool? adhkarEveningDone,
    bool? sleepDhikrDone,
    int? tasbeehTarget,
    int? tasbeehProgress,
    DateTime? updatedAt,
  }) {
    return WirdEntity(
      date: date ?? this.date,
      quranTargetPages: quranTargetPages ?? this.quranTargetPages,
      quranProgressPages: quranProgressPages ?? this.quranProgressPages,
      adhkarMorningDone: adhkarMorningDone ?? this.adhkarMorningDone,
      adhkarEveningDone: adhkarEveningDone ?? this.adhkarEveningDone,
      sleepDhikrDone: sleepDhikrDone ?? this.sleepDhikrDone,
      tasbeehTarget: tasbeehTarget ?? this.tasbeehTarget,
      tasbeehProgress: tasbeehProgress ?? this.tasbeehProgress,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        date,
        quranTargetPages,
        quranProgressPages,
        adhkarMorningDone,
        adhkarEveningDone,
        sleepDhikrDone,
        tasbeehTarget,
        tasbeehProgress,
        updatedAt,
      ];
}
