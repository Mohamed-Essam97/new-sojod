import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_with_tafsir/quran_with_tafsir.dart';

import '../../domain/repositories/quran_repository.dart';

import 'quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  final QuranRepository _repository;

  QuranCubit(this._repository) : super(QuranState.initial()) {
    _loadSettings();
  }

  void _loadSettings() {
    emit(state.copyWith(
      lastReadPage: _repository.getLastReadPage(),
      lastReadSurah: _repository.getLastReadSurah(),
      readingTheme: _repository.getReadingTheme(),
      fontSize: _repository.getFontSize(),
      readingMode: _repository.getReadingMode(),
      selectedReciter: _repository.getSelectedReciter(),
    ));
  }

  List<Ayah> getPage(int page) => _repository.getPage(page);

  List<Ayah> getJuz(int juz) => _repository.getJuz(juz);

  List<SurahMetadata> getSurahs() => _repository.getAllSurahs();

  Surah getSurah(int surahNumber, {bool english = false}) =>
      _repository.getSurah(surahNumber,
          language: english ? QuranLanguage.english : QuranLanguage.arabic);

  Ayah getAyah(int surahNumber, int ayahNumber, {bool english = false}) =>
      _repository.getAyah(surahNumber, ayahNumber,
          language: english ? QuranLanguage.english : QuranLanguage.arabic);

  Map<int, String> getTafsir(int surahNumber) =>
      _repository.getTafsir(surahNumber);

  Future<List<Ayah>> search(String query, {bool english = false}) =>
      _repository.search(query,
          language: english ? QuranLanguage.english : QuranLanguage.arabic);

  String getAudioUrl(int surahNumber, int ayahNumber) =>
      _repository.getAudioUrl(surahNumber, ayahNumber,
          reciterIdentifier: state.selectedReciter);

  Map<String, String> getReciters() => _repository.getReciters();

  Future<void> setLastReadPage(int page) async {
    await _repository.setLastReadPage(page);
    emit(state.copyWith(lastReadPage: page));
  }

  Future<void> setLastReadSurah(int? surah) async {
    await _repository.setLastReadSurah(surah);
    emit(state.copyWith(lastReadSurah: surah));
  }

  Future<void> setReadingTheme(String theme) async {
    await _repository.setReadingTheme(theme);
    emit(state.copyWith(readingTheme: theme));
  }

  Future<void> setFontSize(double size) async {
    await _repository.setFontSize(size);
    emit(state.copyWith(fontSize: size));
  }

  Future<void> setReadingMode(String mode) async {
    await _repository.setReadingMode(mode);
    emit(state.copyWith(readingMode: mode));
  }

  Future<void> setSelectedReciter(String reciter) async {
    await _repository.setSelectedReciter(reciter);
    emit(state.copyWith(selectedReciter: reciter));
  }

  Future<void> toggleBookmark(int surahNumber, int ayahNumber) async {
    final isBookmarked =
        await _repository.isBookmarked(surahNumber, ayahNumber);
    if (isBookmarked) {
      await _repository.removeBookmark(surahNumber, ayahNumber);
    } else {
      await _repository.addBookmark(surahNumber, ayahNumber);
    }
    emit(state.copyWith());
  }

  Future<bool> isBookmarked(int surahNumber, int ayahNumber) =>
      _repository.isBookmarked(surahNumber, ayahNumber);
}
