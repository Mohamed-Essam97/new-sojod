import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import 'diamond_badge.dart';

class SurahTile extends StatelessWidget {
  const SurahTile({
    super.key,
    required this.number,
    required this.nameEn,
    required this.nameAr,
    required this.ayahCount,
    required this.isMeccan,
    required this.l10n,
    required this.onTap,
  });

  final int number;
  final String nameEn;
  final String nameAr;
  final int ayahCount;
  final bool isMeccan;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkCard : Colors.white;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final divColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;

    return Material(
      color: cardBg,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  DiamondBadge(number: number),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nameEn,
                          style: TextStyle(
                            color: textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: isMeccan
                                    ? AppColors.teal.withValues(alpha: 0.1)
                                    : AppColors.amber.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isMeccan
                                    ? l10n.translate('makki')
                                    : l10n.translate('madani'),
                                style: TextStyle(
                                  color: isMeccan
                                      ? AppColors.teal
                                      : AppColors.amber,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$ayahCount ${l10n.translate('verses')}',
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    nameAr,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'QuranFont',
                      color: AppColors.teal,
                      fontSize: 20,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, indent: 16, endIndent: 16, color: divColor),
          ],
        ),
      ),
    );
  }
}
