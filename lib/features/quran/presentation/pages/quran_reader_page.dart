import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/quran_reading_theme.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../reciters/domain/entities/reciter.dart';
import '../../../reciters/domain/repositories/reciter_repository.dart';
import '../../../reciters/presentation/widgets/reciter_selection_sheet.dart';
import '../../../wird/presentation/cubit/wird_cubit.dart';
import '../../../wird/presentation/cubit/wird_state.dart';
import '../cubit/quran_cubit.dart';
import '../cubit/quran_state.dart';
import '../widgets/floating_audio_player.dart';
import '../widgets/page_content.dart';
import '../widgets/reader_bottom_bar.dart';
import '../widgets/reader_settings_sheet.dart';
import '../widgets/reader_top_bar.dart';

class QuranReaderPage extends StatefulWidget {
  final int initialPage;
  final int? initialSurah;

  const QuranReaderPage({
    super.key,
    this.initialPage = 1,
    this.initialSurah,
  });

  @override
  State<QuranReaderPage> createState() => _QuranReaderPageState();
}

class _QuranReaderPageState extends State<QuranReaderPage> {
  final _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QuranCubit>(),
      child: _QuranReaderView(
        initialPage: widget.initialPage,
        initialSurah: widget.initialSurah,
        audioPlayer: _audioPlayer,
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Reader view (stateful to manage bars, selection, playback)
// ─────────────────────────────────────────────────
class _QuranReaderView extends StatefulWidget {
  final int initialPage;
  final int? initialSurah;
  final AudioPlayer audioPlayer;

  const _QuranReaderView({
    required this.initialPage,
    this.initialSurah,
    required this.audioPlayer,
  });

  @override
  State<_QuranReaderView> createState() => _QuranReaderViewState();
}

class _QuranReaderViewState extends State<_QuranReaderView> {
  late final PageController _pageController;

  bool _barsVisible = true;
  int _currentPage = 1;
  bool _isPlayingSurah = false;

  // Current surah info shown in the top bar
  String _currentSurahNameAr = '';
  String _currentSurahNameEn = '';
  int _currentJuz = 1;

  // Track playing surah metadata for the floating player display
  String _playingSurahName = '';
  int _playingTotalAyahs = 0;
  int _playingSurahNumber = 0;
  final _playingIndexNotifier = ValueNotifier<int>(0);

  // Current reciter (from ReciterRepository, updated when user changes)
  late Reciter _currentReciter;

  /// Notifier for the currently tapped (selected) ayah — used for highlight.
  final _selectedAyahNotifier = ValueNotifier<int?>(null);

  /// Notifier for the ayah currently being played — used for playing highlight.
  final _playingAyahNotifier = ValueNotifier<int?>(null);

  StreamSubscription<int?>? _indexSub;
  StreamSubscription<PlayerState>? _playerStateSub;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage - 1);
    _currentReciter = sl<ReciterRepository>().getSelectedReciter();
    // Load surah info after the first frame so context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadSurahInfo(context, _currentPage);
      }
    });
  }

  void _loadSurahInfo(BuildContext context, int page) {
    final cubit = context.read<QuranCubit>();
    final ayahs = cubit.getPage(page);
    if (ayahs.isEmpty) return;
    final surahNumber = ayahs.first.surahNumber;
    final juz = ayahs.first.juz;
    final surahs = cubit.getSurahs();
    final meta = surahs.firstWhere(
      (s) => s.number == surahNumber,
      orElse: () => surahs.first,
    );
    setState(() {
      _currentSurahNameAr = meta.nameAr;
      _currentSurahNameEn = meta.nameEn;
      _currentJuz = juz;
    });
  }

  Future<void> _autoPlaySurah(BuildContext context, int surahNumber) async {
    final cubit = context.read<QuranCubit>();
    final surah = cubit.getSurah(surahNumber);
    if (surah.verses.isEmpty) return;

    final surahs = cubit.getSurahs();
    final meta = surahs.firstWhere(
      (s) => s.number == surahNumber,
      orElse: () => surahs.first,
    );

    final playlist = ConcatenatingAudioSource(
      children: surah.verses
          .map((v) => AudioSource.uri(
                Uri.parse(cubit.getAudioUrl(surahNumber, v.id)),
              ))
          .toList(),
    );

    await widget.audioPlayer.setAudioSource(playlist);

    _indexSub?.cancel();
    _indexSub = widget.audioPlayer.currentIndexStream.listen((index) {
      if (index != null && index < surah.verses.length) {
        _playingAyahNotifier.value = surah.verses[index].id;
        _playingIndexNotifier.value = index;
      }
    });

    _playerStateSub?.cancel();
    _playerStateSub = widget.audioPlayer.playerStateStream.listen((ps) {
      if (ps.processingState == ProcessingState.completed) {
        _indexSub?.cancel();
        _playingAyahNotifier.value = null;
        _playingIndexNotifier.value = 0;
        if (mounted) setState(() => _isPlayingSurah = false);
      }
    });

    setState(() {
      _isPlayingSurah = true;
      _playingSurahName = meta.nameAr;
      _playingTotalAyahs = surah.verses.length;
      _playingSurahNumber = surahNumber;
    });
    widget.audioPlayer.play();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _selectedAyahNotifier.dispose();
    _playingAyahNotifier.dispose();
    _playingIndexNotifier.dispose();
    _indexSub?.cancel();
    _playerStateSub?.cancel();
    super.dispose();
  }

  void _toggleBars() => setState(() => _barsVisible = !_barsVisible);

  // ── Play entire surah ──────────────────────────────────────────────────────
  Future<void> _stopPlayback() async {
    await widget.audioPlayer.stop();
    _indexSub?.cancel();
    _playerStateSub?.cancel();
    _playingAyahNotifier.value = null;
    _playingIndexNotifier.value = 0;
    setState(() => _isPlayingSurah = false);
  }

  Future<void> _togglePlaySurah(BuildContext context) async {
    if (_isPlayingSurah) {
      await _stopPlayback();
      return;
    }

    final cubit = context.read<QuranCubit>();
    final pageAyahs = cubit.getPage(_currentPage);
    if (pageAyahs.isEmpty) return;

    final surahNumber = pageAyahs.first.surahNumber;
    final surah = cubit.getSurah(surahNumber);
    if (surah.verses.isEmpty) return;

    // Resolve surah name for the floating player
    final surahs = cubit.getSurahs();
    final meta = surahs.firstWhere(
      (s) => s.number == surahNumber,
      orElse: () => surahs.first,
    );

    final playlist = ConcatenatingAudioSource(
      children: surah.verses
          .map((v) => AudioSource.uri(
                Uri.parse(cubit.getAudioUrl(surahNumber, v.id)),
              ))
          .toList(),
    );

    await widget.audioPlayer.setAudioSource(playlist);

    _indexSub?.cancel();
    _indexSub = widget.audioPlayer.currentIndexStream.listen((index) {
      if (index != null && index < surah.verses.length) {
        _playingAyahNotifier.value = surah.verses[index].id;
        _playingIndexNotifier.value = index;
      }
    });

    _playerStateSub?.cancel();
    _playerStateSub = widget.audioPlayer.playerStateStream.listen((ps) {
      if (ps.processingState == ProcessingState.completed) {
        _indexSub?.cancel();
        _playingAyahNotifier.value = null;
        _playingIndexNotifier.value = 0;
        if (mounted) setState(() => _isPlayingSurah = false);
      }
    });

    setState(() {
      _isPlayingSurah = true;
      _playingSurahName = meta.nameAr;
      _playingTotalAyahs = surah.verses.length;
      _playingSurahNumber = surahNumber;
    });
    widget.audioPlayer.play();
  }

  Future<void> _onChangeReciter(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    await ReciterSelectionSheet.show(
      context,
      currentReciter: _currentReciter,
      isDark: isDark,
      onReciterSelected: (reciter) => _applyReciterChange(context, reciter),
    );
  }

  Future<void> _applyReciterChange(BuildContext context, Reciter reciter) async {
    setState(() => _currentReciter = reciter);
    context.read<QuranCubit>().setSelectedReciter(reciter.id);

    if (!_isPlayingSurah) return;

    await widget.audioPlayer.stop();
    _indexSub?.cancel();
    _playerStateSub?.cancel();

    final cubit = context.read<QuranCubit>();
    final surah = cubit.getSurah(_playingSurahNumber);
    if (surah.verses.isEmpty) return;

    final currentIndex = _playingIndexNotifier.value;
    final playlist = ConcatenatingAudioSource(
      children: surah.verses
          .map((v) => AudioSource.uri(
                Uri.parse(cubit.getAudioUrl(_playingSurahNumber, v.id)),
              ))
          .toList(),
    );

    await widget.audioPlayer.setAudioSource(playlist);
    await widget.audioPlayer.seek(Duration.zero, index: currentIndex);

    _indexSub = widget.audioPlayer.currentIndexStream.listen((index) {
      if (index != null && index < surah.verses.length) {
        _playingAyahNotifier.value = surah.verses[index].id;
        _playingIndexNotifier.value = index;
      }
    });

    _playerStateSub = widget.audioPlayer.playerStateStream.listen((ps) {
      if (ps.processingState == ProcessingState.completed) {
        _indexSub?.cancel();
        _playingAyahNotifier.value = null;
        _playingIndexNotifier.value = 0;
        if (mounted) setState(() => _isPlayingSurah = false);
      }
    });

    widget.audioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranCubit, QuranState>(
      builder: (context, state) {
        final themeType = QuranReadingThemeType.values.firstWhere(
          (e) => e.name == state.readingTheme,
          orElse: () => QuranReadingThemeType.sepia,
        );
        final bgColor = themeType.background;
        final textColor = themeType.textColor;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: themeType == QuranReadingThemeType.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: Scaffold(
            backgroundColor: bgColor,
            body: GestureDetector(
              onTap: _toggleBars,
              child: Stack(
                children: [
                  // ── Main reading area ──────────────────────────────
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (i) {
                      final page = i + 1;
                      setState(() => _currentPage = page);
                      context.read<QuranCubit>().setLastReadPage(page);
                      _loadSurahInfo(context, page);
                      // Track page for Wird progress
                      _trackWirdPage(context, page);
                      // Stop surah playback when page changes
                      if (_isPlayingSurah) {
                        widget.audioPlayer.stop();
                        _indexSub?.cancel();
                        _playerStateSub?.cancel();
                        _playingAyahNotifier.value = null;
                        _isPlayingSurah = false;
                      }
                    },
                    itemCount: 604,
                    itemBuilder: (context, index) {
                      final page = index + 1;
                      final ayahs = context.read<QuranCubit>().getPage(page);
                      return PageContent(
                        page: page,
                        ayahs: ayahs,
                        fontSize: state.fontSize,
                        textColor: textColor,
                        bgColor: bgColor,
                        audioPlayer: widget.audioPlayer,
                        cubit: context.read<QuranCubit>(),
                        selectedAyahNotifier: _selectedAyahNotifier,
                        playingAyahNotifier: _playingAyahNotifier,
                      );
                    },
                  ),

                  // ── Top bar ──────────────────────────────────────
                  AnimatedSlide(
                    offset: _barsVisible ? Offset.zero : const Offset(0, -1),
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeInOut,
                    child: ReaderTopBar(
                      page: _currentPage,
                      juz: _currentJuz,
                      surahNameAr: _currentSurahNameAr,
                      surahNameEn: _currentSurahNameEn,
                      bgColor: bgColor,
                      textColor: textColor,
                      onSettings: () => _showSettings(context),
                      onPlayFullSurah: () => _togglePlaySurah(context),
                    ),
                  ),

                  // ── Floating audio player ────────────────────────
                  if (_isPlayingSurah)
                    Positioned(
                      left: 24,
                      right: 24,
                      bottom: 72,
                      child: FloatingAudioPlayer(
                        isPlaying: true,
                        surahName: _playingSurahName,
                        totalAyahs: _playingTotalAyahs,
                        playingIndexNotifier: _playingIndexNotifier,
                        audioPlayer: widget.audioPlayer,
                        reciter: _currentReciter,
                        l10n: AppLocalizations.of(context),
                        isRtl:
                            Directionality.of(context) == TextDirection.rtl,
                        onPlay: () => _togglePlaySurah(context),
                        onStop: _stopPlayback,
                        onChangeReciter: () => _onChangeReciter(context),
                      ),
                    ),

                  // ── Wird progress pill ──────────────────────────
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 52,
                    child: _WirdProgressPill(barsVisible: _barsVisible),
                  ),

                  // ── Bottom bar ───────────────────────────────────
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: AnimatedSlide(
                      offset: _barsVisible ? Offset.zero : const Offset(0, 1),
                      duration: const Duration(milliseconds: 240),
                      curve: Curves.easeInOut,
                      child: ReaderBottomBar(
                        page: _currentPage,
                        l10n: AppLocalizations.of(context),
                        bgColor: bgColor,
                        textColor: textColor,
                        onPrev: () {
                          if (_currentPage > 1) {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        onNext: () {
                          if (_currentPage < 604) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _trackWirdPage(BuildContext context, int page) {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      sl<WirdCubit>().trackPageRead(page);
    }
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: context.read<QuranCubit>(),
        child: const ReaderSettingsSheet(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Wird Progress Pill - shown in the reader
// ─────────────────────────────────────────────────
class _WirdProgressPill extends StatelessWidget {
  const _WirdProgressPill({required this.barsVisible});

  final bool barsVisible;

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) return const SizedBox.shrink();

    return BlocBuilder<WirdCubit, WirdState>(
      builder: (context, state) {
        if (state is! WirdLoaded) return const SizedBox.shrink();
        final wird = state.wird;
        if (wird.quranTargetPages <= 0) return const SizedBox.shrink();

        final isComplete = wird.isQuranComplete;

        return AnimatedSlide(
          offset: barsVisible ? Offset.zero : const Offset(0, 3),
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeInOut,
          child: Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isComplete
                    ? AppColors.teal.withValues(alpha: 0.9)
                    : Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isComplete
                        ? Icons.check_circle_rounded
                        : Icons.menu_book_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${wird.quranProgressPages}/${wird.quranTargetPages}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isComplete) ...[
                    const SizedBox(width: 4),
                    const Text('✓',
                        style:
                            TextStyle(color: Colors.white, fontSize: 11)),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
