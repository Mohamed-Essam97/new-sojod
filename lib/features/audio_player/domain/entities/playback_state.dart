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
    this.position = Duration.zero,
    this.duration,
    this.speed = 1.0,
  });

  final PlaybackMode mode;
  final int? currentSurah;
  final int? currentAyah;
  final String? surahName;
  final int totalAyahs;
  final int currentIndex;
  final String? reciterName;
  final Duration position;
  final Duration? duration;
  final double speed;

  bool get isPlaying => mode == PlaybackMode.playing;
  bool get isIdle => mode == PlaybackMode.idle;

  /// Overall progress 0.0–1.0 (ayah-based with position within current ayah).
  double get progress {
    if (totalAyahs <= 0) return 0;
    final durationMs = duration?.inMilliseconds ?? 1;
    final positionMs = position.inMilliseconds;
    final withinAyah = (positionMs / durationMs).clamp(0.0, 1.0);
    return (currentIndex + withinAyah) / totalAyahs;
  }

  AudioPlaybackState copyWith({
    PlaybackMode? mode,
    int? currentSurah,
    int? currentAyah,
    String? surahName,
    int? totalAyahs,
    int? currentIndex,
    String? reciterName,
    Duration? position,
    Duration? duration,
    double? speed,
  }) {
    return AudioPlaybackState(
      mode: mode ?? this.mode,
      currentSurah: currentSurah ?? this.currentSurah,
      currentAyah: currentAyah ?? this.currentAyah,
      surahName: surahName ?? this.surahName,
      totalAyahs: totalAyahs ?? this.totalAyahs,
      currentIndex: currentIndex ?? this.currentIndex,
      reciterName: reciterName ?? this.reciterName,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      speed: speed ?? this.speed,
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
        position,
        duration,
        speed,
      ];
}
