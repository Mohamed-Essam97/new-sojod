import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import 'juz_card.dart';

const _juzTitles = [
  'الم', 'سَيَقُولُ', 'تِلْكَ الرُّسُلُ', 'لَن تَنَالُوا', 'وَالْمُحْصَنَاتُ',
  'لَا يُحِبُّ اللَّهُ', 'وَإِذَا سَمِعُوا', 'وَلَوْ أَنَّنَا', 'قَالَ الْمَلَأُ',
  'وَاعْلَمُوا', 'يَعْتَذِرُونَ', 'وَمَا مِن دَابَّةٍ', 'وَمَا أُبَرِّئُ',
  'رُبَمَا', 'سُبْحَانَ الَّذِي', 'قَالَ أَلَمْ', 'اقْتَرَبَ', 'قَدْ أَفْلَحَ',
  'وَقَالَ الَّذِينَ', 'أَمَّنْ خَلَقَ', 'اتْلُ مَا أُوحِيَ', 'وَمَن يَقْنُتْ',
  'وَمَا لِيَ', 'فَمَنْ أَظْلَمُ', 'إِلَيْهِ يُرَدُّ', 'حم', 'قَالَ فَمَا خَطْبُكُم',
  'قَدْ سَمِعَ اللَّهُ', 'تَبَارَكَ الَّذِي', 'عَمَّ يَتَسَاءَلُونَ',
];

class JuzGrid extends StatelessWidget {
  const JuzGrid({
    super.key,
    required this.l10n,
    required this.onTap,
  });

  final AppLocalizations l10n;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: 30,
      itemBuilder: (context, i) {
        final juz = i + 1;
        return JuzCard(
          juz: juz,
          title: _juzTitles[i],
          l10n: l10n,
          onTap: () => onTap(juz),
        );
      },
    );
  }
}
