import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SurahHeader extends StatelessWidget {
  const SurahHeader({
    super.key,
    required this.surahNumber,
    required this.surahNameAr,
    required this.surahNameEn,
    required this.textColor,
  });

  final int surahNumber;
  final String surahNameAr;
  final String surahNameEn;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, top: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.teal.withValues(alpha: 0.4),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Text(
                      surahNameAr.isNotEmpty
                          ? 'سورة $surahNameAr'
                          : 'سورة $surahNumber',
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        color: AppColors.teal,
                        fontFamily: 'QuranFont',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.4,
                      ),
                    ),
                    if (surahNameEn.isNotEmpty)
                      Text(
                        surahNameEn,
                        style: TextStyle(
                          color: AppColors.teal.withValues(alpha: 0.7),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.teal.withValues(alpha: 0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (surahNumber != 1 && surahNumber != 9) ...[
            const SizedBox(height: 14),
            Text(
              'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'QuranFont',
                color: textColor.withValues(alpha: 0.75),
                fontSize: 20,
                height: 1.8,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
