import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import 'stat_chip.dart';

class QuranHeader extends StatelessWidget {
  const QuranHeader({
    super.key,
    required this.lastPage,
    required this.l10n,
    required this.onContinue,
  });

  final int lastPage;
  final AppLocalizations l10n;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.teal, AppColors.tealDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'القرآن الكريم',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'QuranFont',
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatChip(label: '114', sub: l10n.translate('surahs')),
                  const SizedBox(width: 8),
                  StatChip(label: '30', sub: l10n.translate('juz')),
                  const SizedBox(width: 8),
                  StatChip(label: '604', sub: l10n.translate('pages')),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: onContinue,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.overlayLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppColors.borderMuted, width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.cardLightTranslucent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.bookmark_rounded,
                            color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.translate('continueReading'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.translate('lastReadPage', [lastPage.toString()]),
                              style: const TextStyle(
                                color: AppColors.onSurfaceMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 38,
                            height: 38,
                            child: CircularProgressIndicator(
                              value: lastPage / 604,
                              strokeWidth: 3,
                              backgroundColor: AppColors.overlayLight,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          ),
                          Text(
                            '${(lastPage / 604 * 100).toInt()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right_rounded,
                          color: AppColors.onSurfaceMuted, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
