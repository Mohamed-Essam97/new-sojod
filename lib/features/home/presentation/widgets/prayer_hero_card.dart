import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class PrayerHeroCard extends StatelessWidget {
  const PrayerHeroCard({
    super.key,
    required this.prayerName,
    required this.time,
    required this.countdown,
    required this.l10n,
    this.subtitle,
  });

  final String prayerName;
  final DateTime time;
  final Duration? countdown;
  final AppLocalizations l10n;
  /// Badge text (e.g. "Next prayer · Today" or "Fajr · Tomorrow"); defaults to nextPrayer · today
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat.jm().format(time);
    final hours = countdown?.inHours ?? 0;
    final mins =
        ((countdown?.inMinutes ?? 0) % 60).toString().padLeft(2, '0');
    final secs =
        ((countdown?.inSeconds ?? 0) % 60).toString().padLeft(2, '0');

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.teal, AppColors.tealDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.teal.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.overlayLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    subtitle ?? '${l10n.translate('nextPrayer')} · ${l10n.translate('today')}',
                    style: const TextStyle(
                      color: AppColors.onSurfaceMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  prayerName[0].toUpperCase() + prayerName.substring(1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.schedule_rounded,
                        color: AppColors.onSurfaceMuted, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      timeStr,
                      style: const TextStyle(
                        color: AppColors.onSurfaceMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (countdown != null)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.overlayLight,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                    color: AppColors.borderMuted, width: 1),
              ),
              child: Column(
                children: [
                  Text(
                    '$hours:$mins:$secs',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      fontFeatures: [FontFeature.tabularFigures()],
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.translate('remaining'),
                    style: const TextStyle(
                      color: AppColors.onSurfaceMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
