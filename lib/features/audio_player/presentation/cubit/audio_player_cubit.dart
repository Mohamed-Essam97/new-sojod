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
        
        emit(state.copyWith(
          mode: isPlaying ? PlaybackMode.playing : PlaybackMode.paused,
          currentIndex: currentIndex,
        ));

        if (playbackState.processingState == AudioProcessingState.completed) {
          emit(const AudioPlaybackState());
        }
      });

      _mediaItemSub = _audioHandler?.mediaItem.listen((item) {
        if (item != null) {
          // Update current ayah from media item extras
          final ayahNumber = item.extras?['ayah'] as int?;
          if (ayahNumber != null) {
            emit(state.copyWith(currentAyah: ayahNumber));
          }
        }
      });
    } catch (e) {
      // Fallback: audio_service not available, continue without background support
    }
  }

  Future<void> playSurah(int surahNumber, {Reciter? customReciter}) async {
    try {
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
        artUri: (reciter.imageUrl != null && reciter.imageUrl!.isNotEmpty) 
            ? Uri.parse(reciter.imageUrl!) 
            : null,
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
        artUri: (reciter.imageUrl != null && reciter.imageUrl!.isNotEmpty) 
            ? Uri.parse(reciter.imageUrl!) 
            : null,
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

  @override
  Future<void> close() {
    _playbackStateSub?.cancel();
    _mediaItemSub?.cancel();
    _audioHandler?.dispose();
    return super.close();
  }
}
