import 'package:flutter/material.dart';

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
  });

  final int page;
  final int juz;
  final String surahNameAr;
  final String surahNameEn;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onSettings;

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
                  IconButton(
                    icon: Icon(Icons.tune_rounded,
                        color: textColor, size: 22),
                    onPressed: onSettings,
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
