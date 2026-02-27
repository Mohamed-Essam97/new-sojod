import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_with_tafsir/quran_with_tafsir.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/quran_reading_theme.dart';
import '../cubit/quran_cubit.dart';
import '../cubit/quran_state.dart';

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
        audioPlayer: _audioPlayer,
      ),
    );
  }
}

class _QuranReaderView extends StatelessWidget {
  final int initialPage;
  final AudioPlayer audioPlayer;

  const _QuranReaderView({
    required this.initialPage,
    required this.audioPlayer,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranCubit, QuranState>(
      builder: (context, state) {
        final s = state as QuranState? ?? QuranState.initial();
        final themeType = QuranReadingThemeType.values.firstWhere(
          (e) => e.name == s.readingTheme,
          orElse: () => QuranReadingThemeType.sepia,
        );
        final bgColor = themeType.background;
        final textColor = themeType.textColor;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            title: const Text('Quran'),
            backgroundColor: bgColor,
            foregroundColor: textColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () => _showReaderSettings(context),
              ),
            ],
          ),
          body: PageView.builder(
            controller: PageController(initialPage: initialPage - 1),
            onPageChanged: (i) {
              context.read<QuranCubit>().setLastReadPage(i + 1);
            },
            itemCount: 604,
            itemBuilder: (context, index) {
              final page = index + 1;
              final ayahs = context.read<QuranCubit>().getPage(page);
              return _PageView(
                page: page,
                ayahs: ayahs,
                fontSize: s.fontSize,
                textColor: textColor,
                audioPlayer: audioPlayer,
                cubit: context.read<QuranCubit>(),
              );
            },
          ),
        );
      },
    );
  }

  void _showReaderSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return BlocProvider.value(
          value: context.read<QuranCubit>(),
          child: _ReaderSettingsSheet(),
        );
      },
    );
  }
}

class _PageView extends StatelessWidget {
  final int page;
  final List<Ayah> ayahs;
  final double fontSize;
  final Color textColor;
  final AudioPlayer audioPlayer;
  final QuranCubit cubit;

  const _PageView({
    required this.page,
    required this.ayahs,
    required this.fontSize,
    required this.textColor,
    required this.audioPlayer,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...ayahs.map((ayah) => _AyahTile(
                ayah: ayah,
                fontSize: fontSize,
                textColor: textColor,
                audioPlayer: audioPlayer,
                cubit: cubit,
              )),
          const SizedBox(height: 24),
          Text(
            '— $page —',
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }
}

class _AyahTile extends StatelessWidget {
  final Ayah ayah;
  final double fontSize;
  final Color textColor;
  final AudioPlayer audioPlayer;
  final QuranCubit cubit;

  const _AyahTile({
    required this.ayah,
    required this.fontSize,
    required this.textColor,
    required this.audioPlayer,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAyahSheet(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.teal.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${ayah.id}',
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                ayah.text,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'QuranFont',
                  fontSize: fontSize,
                  height: 2.0,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAyahSheet(BuildContext context) {
    final tafsir = cubit.getTafsir(ayah.surahNumber)[ayah.id];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        expand: false,
        builder: (_, controller) => SingleChildScrollView(
          controller: controller,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                ayah.text,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontFamily: 'QuranFont',
                  fontSize: 24,
                  height: 2.0,
                ),
              ),
              if (tafsir != null) ...[
                const SizedBox(height: 16),
                Text('Tafsir', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  tafsir,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontFamily: 'TafsirFont',
                    fontSize: 16,
                    height: 1.8,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.bookmark_add),
                    onPressed: () {
                      cubit.toggleBookmark(ayah.surahNumber, ayah.id);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up),
                    onPressed: () async {
                      final url = cubit.getAudioUrl(ayah.surahNumber, ayah.id);
                      await audioPlayer.setUrl(url);
                      audioPlayer.play();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReaderSettingsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranCubit, QuranState>(
      builder: (context, state) {
        final s = state as QuranState? ?? QuranState.initial();
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Font Size: ${s.fontSize.toInt()}'),
              Slider(
                value: s.fontSize,
                min: 16,
                max: 36,
                onChanged: (v) => context.read<QuranCubit>().setFontSize(v),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: QuranReadingThemeType.values.map((t) {
                  final selected = s.readingTheme == t.name;
                  return ChoiceChip(
                    label: Text(t.name),
                    selected: selected,
                    onSelected: (_) =>
                        context.read<QuranCubit>().setReadingTheme(t.name),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
