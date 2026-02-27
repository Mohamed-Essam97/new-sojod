import 'package:equatable/equatable.dart';
import 'package:hijri/hijri_calendar.dart';

class HijriState extends Equatable {
  final HijriCalendar? hijriDate;
  final DateTime? gregorianDate;
  final int adjustment;

  const HijriState({
    this.hijriDate,
    this.gregorianDate,
    this.adjustment = 0,
  });

  factory HijriState.initial() => const HijriState();

  HijriState copyWith({
    HijriCalendar? hijriDate,
    DateTime? gregorianDate,
    int? adjustment,
  }) {
    return HijriState(
      hijriDate: hijriDate ?? this.hijriDate,
      gregorianDate: gregorianDate ?? this.gregorianDate,
      adjustment: adjustment ?? this.adjustment,
    );
  }

  @override
  List<Object?> get props => [hijriDate, gregorianDate, adjustment];
}
