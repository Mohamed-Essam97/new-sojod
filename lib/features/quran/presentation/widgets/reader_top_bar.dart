import 'package:flutter/material.dart';
import 'package:wird/core/theme/app_colors.dart';

import 'reader_info_chip.dart';

class ReaderTopBar extends StatelessWidget {
  const ReaderTopBar({
    super.key,
    required this.page,
    required this.juz,
    required this.surahNameAr,
    required this.surahNameEn,
    required this.bgColor,
    required this.textColor,
    required this.onSettings,
    required this.onPlayFullSurah,
  });

  final int page;
  final int juz;
  final String surahNameAr;
  final String surahNameEn;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onSettings;
  final VoidCallback onPlayFullSurah;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 56,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 4),
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new,
                        color: textColor, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: surahNameAr.isEmpty
                          ? const SizedBox.shrink()
                          : Column(
                              key: ValueKey(surahNameAr),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  surahNameAr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'QuranFont',
                                    color: textColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    height: 1.3,
                                  ),
                                ),
                                if (surahNameEn.isNotEmpty)
                                  Text(
                                    surahNameEn,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: textColor.withValues(alpha: 0.55),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.settings_outlined,
                            color: textColor, size: 22),
                        onPressed: onSettings,
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert_rounded,
                            color: textColor, size: 22),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onSelected: (value) {
                          switch (value) {
                            case 'playFullSurah':
                              onPlayFullSurah();
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem<String>(
                            value: 'playFullSurah',
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: _PlayFullSurahMenuItem(
                              textColor: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReaderInfoChip(
                    icon: Icons.auto_stories_rounded,
                    label: 'Page $page',
                    textColor: textColor,
                  ),
                  const SizedBox(width: 8),
                  ReaderInfoChip(
                    icon: Icons.layers_rounded,
                    label: 'Juz $juz',
                    textColor: textColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayFullSurahMenuItem extends StatelessWidget {
  const _PlayFullSurahMenuItem({required this.textColor});

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtitleColor = textColor.withValues(alpha: isDark ? 0.7 : 0.6);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.teal.withValues(alpha: isDark ? 0.25 : 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.play_circle_rounded,
            size: 24,
            color: AppColors.teal,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Play full surah',
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Listen to the entire surah',
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.chevron_right_rounded,
          size: 20,
          color: subtitleColor,
        ),
      ],
    );
  }
}
