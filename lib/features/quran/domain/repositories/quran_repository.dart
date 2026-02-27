import 'package:quran_with_tafsir/quran_with_tafsir.dart';

abstract class QuranRepository {
  List<SurahMetadata> getAllSurahs();
  Surah getSurah(int surahNumber, {QuranLanguage language = QuranLanguage.arabic});
  Ayah getAyah(int surahNumber, int ayahNumber, {QuranLanguage language = QuranLanguage.arabic});
  List<Ayah> getPage(int page);
  List<Ayah> getJuz(int juz);
  Map<int, String> getTafsir(int surahNumber);
  Future<List<Ayah>> search(String query, {QuranLanguage? language, int limit = 50});
  String getAudioUrl(int surahNumber, int ayahNumber, {String reciterIdentifier = 'Alafasy_128kbps'});
  Map<String, String> getReciters();
  int getLastReadPage();
  Future<void> setLastReadPage(int page);
  int? getLastReadSurah();
  Future<void> setLastReadSurah(int? surah);
  String getReadingTheme();
  Future<void> setReadingTheme(String theme);
  double getFontSize();
  Future<void> setFontSize(double size);
  String getReadingMode();
  Future<void> setReadingMode(String mode);
  String getSelectedReciter();
  Future<void> setSelectedReciter(String reciter);
  Future<void> addBookmark(int surahNumber, int ayahNumber);
  Future<void> removeBookmark(int surahNumber, int ayahNumber);
  Future<bool> isBookmarked(int surahNumber, int ayahNumber);
  Future<List<({int surah, int ayah})>> getBookmarks();
}
