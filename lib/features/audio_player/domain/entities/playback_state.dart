import 'package:equatable/equatable.dart';

enum PlaybackMode { idle, playing, paused }

class AudioPlaybackState extends Equatable {
  const AudioPlaybackState({
    this.mode = PlaybackMode.idle,
    this.currentSurah,
    this.currentAyah,
    this.surahName,
    this.totalAyahs = 0,
    this.currentIndex = 0,
    this.reciterName,
  });

  final PlaybackMode mode;
  final int? currentSurah;
  final int? currentAyah;
  final String? surahName;
  final int totalAyahs;
  final int currentIndex;
  final String? reciterName;

  bool get isPlaying => mode == PlaybackMode.playing;
  bool get isIdle => mode == PlaybackMode.idle;

  AudioPlaybackState copyWith({
    PlaybackMode? mode,
    int? currentSurah,
    int? currentAyah,
    String? surahName,
    int? totalAyahs,
    int? currentIndex,
    String? reciterName,
  }) {
    return AudioPlaybackState(
      mode: mode ?? this.mode,
      currentSurah: currentSurah ?? this.currentSurah,
      currentAyah: currentAyah ?? this.currentAyah,
      surahName: surahName ?? this.surahName,
      totalAyahs: totalAyahs ?? this.totalAyahs,
      currentIndex: currentIndex ?? this.currentIndex,
      reciterName: reciterName ?? this.reciterName,
    );
  }

  @override
  List<Object?> get props => [
        mode,
        currentSurah,
        currentAyah,
        surahName,
        totalAyahs,
        currentIndex,
        reciterName,
      ];
}
