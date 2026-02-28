/// App-wide constants
class AppConstants {
  AppConstants._();

  static const String appName = "Wird";

  // Layout padding
  static const double paddingScreenHorizontal = 24.0;
  static const double paddingScreenVertical = 20.0;
  static const double paddingCard = 8.0;
  static const double paddingCardLarge = 20.0;
  static const double layoutPadding = 24.0;
  static const double xLargePadding = 24.0;

  // Border radius
  static const double mediumRadius = 12.0;

  // Storage keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyLocale = 'locale';
  static const String keyPrayerMethod = 'prayer_calculation_method';
  static const String keyEnabledPrayers = 'enabled_prayers';
  static const String keySelectedAdhan = 'selected_adhan';
  static const String keyAutoAdhan = 'auto_adhan';
  static const String keyLastReadPage = 'last_read_page';
  static const String keyLastReadSurah = 'last_read_surah';
  static const String keyQuranTheme = 'quran_theme';
  static const String keyQuranFontSize = 'quran_font_size';
  static const String keyQuranReciter = 'quran_reciter';
  static const String keyQuranReadingMode = 'quran_reading_mode';
  static const String keyHijriAdjustment = 'hijri_adjustment';
  static const String keyTasbeehCount = 'tasbeeh_count';
  static const String keyAdhkarProgress = 'adhkar_progress';
  static const String keyPermissionsGranted = 'permissions_granted';
  static const String keyLocationLat = 'location_lat';
  static const String keyLocationLng = 'location_lng';
  static const String keyLocationName = 'location_name';

  // Notification settings
  static const String keyPrayerNotifFajr = 'notif_prayer_fajr';
  static const String keyPrayerNotifDhuhr = 'notif_prayer_dhuhr';
  static const String keyPrayerNotifAsr = 'notif_prayer_asr';
  static const String keyPrayerNotifMaghrib = 'notif_prayer_maghrib';
  static const String keyPrayerNotifIsha = 'notif_prayer_isha';
  static const String keyAdhkarMorningEnabled = 'notif_adhkar_morning_enabled';
  static const String keyAdhkarMorningHour = 'notif_adhkar_morning_hour';
  static const String keyAdhkarMorningMinute = 'notif_adhkar_morning_minute';
  static const String keyAdhkarEveningEnabled = 'notif_adhkar_evening_enabled';
  static const String keyAdhkarEveningHour = 'notif_adhkar_evening_hour';
  static const String keyAdhkarEveningMinute = 'notif_adhkar_evening_minute';
  static const String keyAdhkarSleepEnabled = 'notif_adhkar_sleep_enabled';
  static const String keyAdhkarSleepHour = 'notif_adhkar_sleep_hour';
  static const String keyAdhkarSleepMinute = 'notif_adhkar_sleep_minute';
}
