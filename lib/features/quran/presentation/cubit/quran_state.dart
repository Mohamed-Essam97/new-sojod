import 'package:equatable/equatable.dart';

class QuranState extends Equatable {
  final int lastReadPage;
  final int? lastReadSurah;
  final String readingTheme;
  final double fontSize;
  final String readingMode;
  final String selectedReciter;

  const QuranState({
    this.lastReadPage = 1,
    this.lastReadSurah,
    this.readingTheme = 'sepia',
    this.fontSize = 24.0,
    this.readingMode = 'page',
    this.selectedReciter = 'Alafasy_128kbps',
  });

  factory QuranState.initial() => const QuranState();

  QuranState copyWith({
    int? lastReadPage,
    int? lastReadSurah,
    String? readingTheme,
    double? fontSize,
    String? readingMode,
    String? selectedReciter,
  }) {
    return QuranState(
      lastReadPage: lastReadPage ?? this.lastReadPage,
      lastReadSurah: lastReadSurah ?? this.lastReadSurah,
      readingTheme: readingTheme ?? this.readingTheme,
      fontSize: fontSize ?? this.fontSize,
      readingMode: readingMode ?? this.readingMode,
      selectedReciter: selectedReciter ?? this.selectedReciter,
    );
  }

  @override
  List<Object?> get props =>
      [lastReadPage, lastReadSurah, readingTheme, fontSize, readingMode, selectedReciter];
}
