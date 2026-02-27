import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appName': "Al-Mu'min",
      'home': 'Home',
      'prayer': 'Prayer Times',
      'quran': 'Quran',
      'adhkar': 'Adhkar',
      'hijri': 'Hijri Calendar',
      'qibla': 'Qibla',
      'mosque': 'Mosque Finder',
      'tasbeeh': 'Tasbeeh',
      'settings': 'Settings',
      'nextPrayer': 'Next Prayer',
      'readQuran': 'Read Quran',
      'qiblaCompass': 'Qibla',
      'mosqueFinder': 'Mosque Finder',
      'tasbeehCounter': 'Tasbeeh',
      'permissions': 'Permissions',
      'locationRequired': 'Location access is needed for prayer times and mosque finder.',
      'notificationsRequired': 'Notifications are needed for adhan reminders.',
      'grantPermissions': 'Grant Permissions',
      'fajr': 'Fajr',
      'sunrise': 'Sunrise',
      'dhuhr': 'Dhuhr',
      'asr': 'Asr',
      'maghrib': 'Maghrib',
      'isha': 'Isha',
      'morning': 'Morning',
      'evening': 'Evening',
      'sleep': 'Sleep',
      'afterPrayer': 'After Prayer',
      'wakeUp': 'Wake Up',
      'completionDua': 'Completion Dua',
      'appearance': 'Appearance',
      'language': 'Language',
      'system': 'System',
      'light': 'Light',
      'dark': 'Dark',
      'english': 'English',
      'arabic': 'Arabic',
      'about': 'About',
      'today': 'Today',
      'remaining': 'remaining',
      'upcomingPrayers': 'Upcoming Prayers',
      'viewMore': 'View More',
      'next': 'Next',
      'quranCompletionPlan': 'Quran Completion Plan',
      'duaAdhkar': 'Dua & Adhkar',
    },
    'ar': {
      'appName': 'المؤمن',
      'home': 'الرئيسية',
      'prayer': 'أوقات الصلاة',
      'quran': 'القرآن',
      'adhkar': 'الأذكار',
      'hijri': 'التقويم الهجري',
      'qibla': 'القبلة',
      'mosque': 'البحث عن المساجد',
      'tasbeeh': 'التسبيح',
      'settings': 'الإعدادات',
      'nextPrayer': 'الصلاة القادمة',
      'readQuran': 'اقرأ القرآن',
      'qiblaCompass': 'القبلة',
      'mosqueFinder': 'البحث عن المساجد',
      'tasbeehCounter': 'التسبيح',
      'permissions': 'الأذونات',
      'locationRequired': 'نحتاج موقعك لأوقات الصلاة والبحث عن المساجد.',
      'notificationsRequired': 'الإشعارات مطلوبة لتذكير الأذان.',
      'grantPermissions': 'منح الأذونات',
      'fajr': 'الفجر',
      'sunrise': 'الشروق',
      'dhuhr': 'الظهر',
      'asr': 'العصر',
      'maghrib': 'المغرب',
      'isha': 'العشاء',
      'morning': 'أذكار الصباح',
      'evening': 'أذكار المساء',
      'sleep': 'أذكار النوم',
      'afterPrayer': 'أذكار بعد الصلاة',
      'wakeUp': 'أذكار الاستيقاظ',
      'completionDua': 'دعاء الختم',
      'appearance': 'المظهر',
      'language': 'اللغة',
      'system': 'النظام',
      'light': 'فاتح',
      'dark': 'داكن',
      'english': 'الإنجليزية',
      'arabic': 'العربية',
      'about': 'حول',
      'today': 'اليوم',
      'remaining': 'متبقي',
      'upcomingPrayers': 'الصلوات القادمة',
      'viewMore': 'عرض المزيد',
      'next': 'التالي',
      'quranCompletionPlan': 'خطة إتمام القرآن',
      'duaAdhkar': 'الدعاء والأذكار',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
