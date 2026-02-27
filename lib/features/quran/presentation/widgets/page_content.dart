import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_with_tafsir/quran_with_tafsir.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/quran_cubit.dart';
import 'ayah_block.dart';
import 'surah_header.dart';

class PageContent extends StatelessWidget {
  const PageContent({
    super.key,
    required this.page,
    required this.ayahs,
    required this.fontSize,
    required this.textColor,
    required this.bgColor,
    required this.audioPlayer,
    required this.cubit,
    required this.selectedAyahNotifier,
    required this.playingAyahNotifier,
  });

  final int page;
  final List<Ayah> ayahs;
  final double fontSize;
  final Color textColor;
  final Color bgColor;
  final AudioPlayer audioPlayer;
  final QuranCubit cubit;
  final ValueNotifier<int?> selectedAyahNotifier;
  final ValueNotifier<int?> playingAyahNotifier;

  @override
  Widget build(BuildContext context) {
    final surahGroups = <int, List<Ayah>>{};
    for (final a in ayahs) {
      surahGroups.putIfAbsent(a.surahNumber, () => []).add(a);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 72, 20, 72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...surahGroups.entries.expand((entry) {
            final surahNum = entry.key;
            final ayahList = entry.value;
            final showHeader = ayahList.first.id == 1;

            String surahNameAr = '';
            String surahNameEn = '';
            if (showHeader) {
              final allSurahs = cubit.getSurahs();
              final meta = allSurahs.firstWhere(
                (s) => s.number == surahNum,
                orElse: () => allSurahs.first,
              );
              surahNameAr = meta.nameAr;
              surahNameEn = meta.nameEn;
            }

            return [
              if (showHeader)
                SurahHeader(
                  surahNumber: surahNum,
                  surahNameAr: surahNameAr,
                  surahNameEn: surahNameEn,
                  textColor: textColor,
                ),
              AyahBlock(
                ayahs: ayahList,
                fontSize: fontSize,
                textColor: textColor,
                audioPlayer: audioPlayer,
                cubit: cubit,
                selectedAyahNotifier: selectedAyahNotifier,
                playingAyahNotifier: playingAyahNotifier,
              ),
            ];
          }),
          const SizedBox(height: 8),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 1,
                    color: AppColors.teal.withValues(alpha: 0.3),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$page',
                    style: const TextStyle(
                      color: AppColors.teal,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 32,
                    height: 1,
                    color: AppColors.teal.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
