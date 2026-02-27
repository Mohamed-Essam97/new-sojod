import 'package:flutter/material.dart';
import 'package:quran_with_tafsir/quran_with_tafsir.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import 'surah_tile.dart';

class SurahList extends StatelessWidget {
  const SurahList({
    super.key,
    required this.surahs,
    required this.l10n,
    required this.onTap,
  });

  final List<SurahMetadata> surahs;
  final AppLocalizations l10n;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (surahs.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded,
                size: 48,
                color: isDark ? AppColors.textSecondaryDark : AppColors.grey),
            const SizedBox(height: 12),
            Text(
              l10n.translate('noSurahsFound'),
              style: TextStyle(
                color: isDark ? AppColors.textSecondaryDark : AppColors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: surahs.length,
      itemBuilder: (context, i) {
        final s = surahs[i];
        return SurahTile(
          number: s.number,
          nameEn: s.nameEn,
          nameAr: s.nameAr,
          ayahCount: s.ayahCount,
          isMeccan: s.isMeccan,
          l10n: l10n,
          onTap: () => onTap(s.number),
        );
      },
    );
  }
}
