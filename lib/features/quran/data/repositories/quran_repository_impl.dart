import 'package:hive_flutter/hive_flutter.dart';
import 'package:quran_with_tafsir/quran_with_tafsir.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/repositories/quran_repository.dart';

class QuranRepositoryImpl implements QuranRepository {
  final SharedPreferences prefs;

  QuranRepositoryImpl({required this.prefs});

  QuranService get _service => QuranService.instance;

  @override
  List<SurahMetadata> getAllSurahs() => _service.getAllSurahs();

  @override
  Surah getSurah(int surahNumber, {QuranLanguage language = QuranLanguage.arabic}) {
    return _service.getSurah(surahNumber, language: language);
  }

  @override
  Ayah getAyah(int surahNumber, int ayahNumber,
      {QuranLanguage language = QuranLanguage.arabic}) {
    return _service.getAyah(surahNumber, ayahNumber, language: language);
  }

  @override
  List<Ayah> getPage(int page) => _service.getPage(page);

  @override
  List<Ayah> getJuz(int juz) => _service.getJuz(juz);

  @override
  Map<int, String> getTafsir(int surahNumber) =>
      _service.getTafsir(surahNumber, language: QuranLanguage.arabic);

  @override
  Future<List<Ayah>> search(String query,
      {QuranLanguage? language, int limit = 50}) async {
    return _service.searchAsync(query,
        language: language ?? QuranLanguage.arabic, limit: limit);
  }

  @override
  String getAudioUrl(int surahNumber, int ayahNumber,
      {String reciterIdentifier = 'Alafasy_128kbps'}) {
    return _service.getAudioUrl(surahNumber, ayahNumber,
        reciterIdentifier: reciterIdentifier);
  }

  @override
  Map<String, String> getReciters() => Reciters.displayNames;

  @override
  int getLastReadPage() =>
      prefs.getInt(AppConstants.keyLastReadPage) ?? 1;

  @override
  Future<void> setLastReadPage(int page) async {
    await prefs.setInt(AppConstants.keyLastReadPage, page);
  }

  @override
  int? getLastReadSurah() => prefs.getInt(AppConstants.keyLastReadSurah);

  @override
  Future<void> setLastReadSurah(int? surah) async {
    if (surah == null) {
      await prefs.remove(AppConstants.keyLastReadSurah);
    } else {
      await prefs.setInt(AppConstants.keyLastReadSurah, surah);
    }
  }

  @override
  String getReadingTheme() =>
      prefs.getString(AppConstants.keyQuranTheme) ?? 'sepia';

  @override
  Future<void> setReadingTheme(String theme) async {
    await prefs.setString(AppConstants.keyQuranTheme, theme);
  }

  @override
  double getFontSize() =>
      prefs.getDouble(AppConstants.keyQuranFontSize) ?? 24.0;

  @override
  Future<void> setFontSize(double size) async {
    await prefs.setDouble(AppConstants.keyQuranFontSize, size);
  }

  @override
  String getReadingMode() =>
      prefs.getString(AppConstants.keyQuranReadingMode) ?? 'page';

  @override
  Future<void> setReadingMode(String mode) async {
    await prefs.setString(AppConstants.keyQuranReadingMode, mode);
  }

  @override
  String getSelectedReciter() =>
      prefs.getString(AppConstants.keyQuranReciter) ?? Reciters.alafasy;

  @override
  Future<void> setSelectedReciter(String reciter) async {
    await prefs.setString(AppConstants.keyQuranReciter, reciter);
  }

  @override
  Future<void> addBookmark(int surahNumber, int ayahNumber) async {
    final box = Hive.box('bookmarks');
    final key = '$surahNumber:$ayahNumber';
    await box.put(key, {'surah': surahNumber, 'ayah': ayahNumber});
  }

  @override
  Future<void> removeBookmark(int surahNumber, int ayahNumber) async {
    final box = Hive.box('bookmarks');
    await box.delete('$surahNumber:$ayahNumber');
  }

  @override
  Future<bool> isBookmarked(int surahNumber, int ayahNumber) async {
    final box = Hive.box('bookmarks');
    return box.containsKey('$surahNumber:$ayahNumber');
  }

  @override
  Future<List<({int surah, int ayah})>> getBookmarks() async {
    final box = Hive.box('bookmarks');
    final list = <({int surah, int ayah})>[];
    for (final key in box.keys) {
      final v = box.get(key);
      if (v is Map && v['surah'] != null && v['ayah'] != null) {
        list.add((surah: v['surah'] as int, ayah: v['ayah'] as int));
      }
    }
    return list;
  }
}
