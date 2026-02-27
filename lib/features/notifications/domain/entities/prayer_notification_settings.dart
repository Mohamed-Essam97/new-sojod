import 'package:equatable/equatable.dart';

class PrayerNotificationSettings extends Equatable {
  final bool fajrEnabled;
  final bool dhuhrEnabled;
  final bool asrEnabled;
  final bool maghribEnabled;
  final bool ishaEnabled;

  const PrayerNotificationSettings({
    this.fajrEnabled = true,
    this.dhuhrEnabled = true,
    this.asrEnabled = true,
    this.maghribEnabled = true,
    this.ishaEnabled = true,
  });

  PrayerNotificationSettings copyWith({
    bool? fajrEnabled,
    bool? dhuhrEnabled,
    bool? asrEnabled,
    bool? maghribEnabled,
    bool? ishaEnabled,
  }) {
    return PrayerNotificationSettings(
      fajrEnabled: fajrEnabled ?? this.fajrEnabled,
      dhuhrEnabled: dhuhrEnabled ?? this.dhuhrEnabled,
      asrEnabled: asrEnabled ?? this.asrEnabled,
      maghribEnabled: maghribEnabled ?? this.maghribEnabled,
      ishaEnabled: ishaEnabled ?? this.ishaEnabled,
    );
  }

  bool get anyEnabled =>
      fajrEnabled || dhuhrEnabled || asrEnabled || maghribEnabled || ishaEnabled;

  @override
  List<Object?> get props =>
      [fajrEnabled, dhuhrEnabled, asrEnabled, maghribEnabled, ishaEnabled];
}
