import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../quran/domain/repositories/quran_repository.dart';
import '../../../reciters/domain/entities/reciter.dart';
import '../../../reciters/domain/repositories/reciter_repository.dart';
import '../../data/services/audio_handler.dart';
import '../../domain/entities/playback_state.dart';

class AudioPlayerCubit extends Cubit<AudioPlaybackState> {
  AudioPlayerCubit(
    this._quranRepository,
    this._reciterRepository,
  ) : super(const AudioPlaybackState()) {
    _initAudioService();
  }

  final QuranRepository _quranRepository;
  final ReciterRepository _reciterRepository;
  
  QuranAudioHandler? _audioHandler;
  StreamSubscription<PlaybackState>? _playbackStateSub;
  StreamSubscription<MediaItem?>? _mediaItemSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;

  Future<void> _initAudioService() async {
    try {
      _audioHandler = await AudioService.init(
        builder: () => QuranAudioHandler(),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.wird.app.audio',
          androidNotificationChannelName: 'Quran Audio',
          androidNotificationOngoing: true,
          androidStopForegroundOnPause: true,
        ),
      );

      _playbackStateSub = _audioHandler?.playbackState.listen((playbackState) {
        final isPlaying = playbackState.playing;
        final currentIndex = playbackState.queueIndex ?? 0;
        final completed = playbackState.processingState == AudioProcessingState.completed;

        emit(state.copyWith(
          mode: isPlaying ? PlaybackMode.playing : PlaybackMode.paused,
          currentIndex: currentIndex,
          position: playbackState.updatePosition,
        ));

        if (completed) {
          _onPlaybackCompleted();
        }
      });

      _mediaItemSub = _audioHandler?.mediaItem.listen((item) {
        if (item != null) {
          final ayahNumber = item.extras?['ayah'] as int?;
          if (ayahNumber != null) {
            emit(state.copyWith(currentAyah: ayahNumber));
          }
        }
      });

      _positionSub = _audioHandler?.positionStream.listen((position) {
        emit(state.copyWith(position: position));
      });
      _durationSub = _audioHandler?.durationStream.listen((duration) {
        if (duration != null) emit(state.copyWith(duration: duration));
      });
    } catch (e) {
      // Fallback: audio_service not available
    }
  }

  void _onPlaybackCompleted() {
    final surah = state.currentSurah;
    if (surah != null && surah < 114) {
      playSurah(surah + 1);
    } else {
      emit(const AudioPlaybackState());
    }
  }

  Future<void> playSurah(int surahNumber, {Reciter? customReciter}) async {
    try {
      // Update selection immediately so only one surah appears selected
      emit(state.copyWith(currentSurah: surahNumber));

      final surah = _quranRepository.getSurah(surahNumber);
      if (surah.verses.isEmpty) return;

      final surahs = _quranRepository.getAllSurahs();
      final meta = surahs.firstWhere(
        (s) => s.number == surahNumber,
        orElse: () => surahs.first,
      );

      final reciter = customReciter ?? _reciterRepository.getSelectedReciter();
      
      // Generate audio URLs and media items
      final urls = surah.verses
          .map((v) => _quranRepository.getAudioUrl(
                surahNumber,
                v.id,
                reciterIdentifier: reciter.id,
              ))
          .toList();

      final mediaItems = surah.verses.map((v) => MediaItem(
        id: '${surahNumber}_${v.id}',
        album: meta.nameEn,
        title: 'Ayah ${v.id}',
        artist: reciter.name,
        artUri: _artUriFromReciter(reciter.imageUrl),
        extras: {'surah': surahNumber, 'ayah': v.id},
      )).toList();

      if (_audioHandler != null) {
        await _audioHandler!.setAudioSourceFromUrls(urls, mediaItems);
        await _audioHandler!.play();
      }

      emit(state.copyWith(
        mode: PlaybackMode.playing,
        currentSurah: surahNumber,
        currentAyah: surah.verses.first.id,
        surahName: meta.nameAr,
        totalAyahs: surah.verses.length,
        currentIndex: 0,
        reciterName: reciter.nameAr,
      ));
    } catch (e) {
      emit(state.copyWith(mode: PlaybackMode.idle));
    }
  }

  Future<void> playAyah(int surahNumber, int ayahNumber, {Reciter? customReciter}) async {
    try {
      final reciter = customReciter ?? _reciterRepository.getSelectedReciter();
      final url = _quranRepository.getAudioUrl(
        surahNumber,
        ayahNumber,
        reciterIdentifier: reciter.id,
      );

      final surahs = _quranRepository.getAllSurahs();
      final meta = surahs.firstWhere(
        (s) => s.number == surahNumber,
        orElse: () => surahs.first,
      );

      final mediaItem = MediaItem(
        id: '${surahNumber}_$ayahNumber',
        album: meta.nameEn,
        title: 'Ayah $ayahNumber',
        artist: reciter.name,
        artUri: _artUriFromReciter(reciter.imageUrl),
        extras: {'surah': surahNumber, 'ayah': ayahNumber},
      );

      if (_audioHandler != null) {
        await _audioHandler!.setAudioSourceFromUrls([url], [mediaItem]);
        await _audioHandler!.play();
      }

      emit(state.copyWith(
        mode: PlaybackMode.playing,
        currentSurah: surahNumber,
        currentAyah: ayahNumber,
        surahName: meta.nameAr,
        totalAyahs: 1,
        currentIndex: 0,
        reciterName: reciter.nameAr,
      ));
    } catch (e) {
      emit(state.copyWith(mode: PlaybackMode.idle));
    }
  }

  Future<void> changeReciter(Reciter newReciter) async {
    if (state.currentSurah == null) return;

    // Save the current position
    final currentSurah = state.currentSurah!;
    final currentIndex = state.currentIndex;

    // Stop current playback
    await stop();

    // Replay with new reciter, starting from the same position
    await playSurah(currentSurah, customReciter: newReciter);
    
    // Skip to the previously playing ayah
    if (currentIndex > 0 && _audioHandler != null) {
      await _audioHandler!.skipToQueueItem(currentIndex);
    }
  }

  Future<void> togglePlayPause() async {
    if (_audioHandler == null) return;

    if (state.isPlaying) {
      await _audioHandler!.pause();
    } else {
      await _audioHandler!.play();
    }
  }

  Future<void> stop() async {
    if (_audioHandler != null) {
      await _audioHandler!.stop();
    }
    emit(const AudioPlaybackState());
  }

  Future<void> skipNext() async {
    await _audioHandler?.skipToNext();
  }

  Future<void> skipPrevious() async {
    await _audioHandler?.skipToPrevious();
  }

  /// Load and play the next surah (1–114). No-op if at 114.
  Future<void> playNextSurah() async {
    final current = state.currentSurah;
    if (current == null || current >= 114) return;
    await playSurah(current + 1);
  }

  /// Load and play the previous surah (1–114). No-op if at 1.
  Future<void> playPreviousSurah() async {
    final current = state.currentSurah;
    if (current == null || current <= 1) return;
    await playSurah(current - 1);
  }

  Future<void> seek(Duration position) async {
    await _audioHandler?.seek(position);
  }

  Future<void> seekToAyah(int ayahIndex) async {
    if (ayahIndex < 0 || ayahIndex >= state.totalAyahs) return;
    await _audioHandler?.skipToQueueItem(ayahIndex);
  }

  Future<void> setSpeed(double speed) async {
    if (speed < 0.5 || speed > 2.0) return;
    await _audioHandler?.setSpeed(speed);
    emit(state.copyWith(speed: speed));
  }

  /// Only use http(s) URLs for MediaItem.artUri. Asset paths cause "No host specified" when fetched.
  static Uri? _artUriFromReciter(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return null;
    final u = imageUrl.trimLeft().toLowerCase();
    if (u.startsWith('http://') || u.startsWith('https://')) {
      return Uri.parse(imageUrl);
    }
    return null;
  }

  @override
  Future<void> close() {
    _playbackStateSub?.cancel();
    _mediaItemSub?.cancel();
    _positionSub?.cancel();
    _durationSub?.cancel();
    _audioHandler?.dispose();
    return super.close();
  }
}
