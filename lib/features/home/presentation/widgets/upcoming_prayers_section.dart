import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/home_state.dart';
import 'prayer_pill.dart';

/// Displays upcoming prayers for the next 7 days in a horizontal list.
/// "See all" navigates to the full 7-day prayer list.
/// Tapping a pill selects it and shows it in the hero card.
class UpcomingPrayersSection extends StatelessWidget {
  const UpcomingPrayersSection({
    super.key,
    required this.upcomingPrayers,
    required this.nextPrayerName,
    required this.selectedPrayer,
    required this.onPrayerSelected,
    required this.l10n,
    required this.isDark,
  });

  final List<PrayerSelection> upcomingPrayers;
  final String? nextPrayerName;
  final PrayerSelection? selectedPrayer;
  final void Function(PrayerSelection prayer) onPrayerSelected;
  final AppLocalizations l10n;
  final bool isDark;

  static String _getPrayerDisplayName(
      String key, DateTime date, AppLocalizations l10n) {
    if (key == 'dhuhr' && date.weekday == DateTime.friday) {
      return l10n.translate('jumuah');
    }
    return l10n.translate(key);
  }

  static String _dateLabel(DateTime date, AppLocalizations l10n) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final diff = dateOnly.difference(todayDate).inDays;
    if (diff == 0) return '';
    if (diff == 1) return l10n.translate('tomorrow');
    return DateFormat.E(l10n.locale.languageCode).format(date);
  }

  @override
  Widget build(BuildContext context) {
    if (upcomingPrayers.isEmpty) return const SizedBox.shrink();

    // List shows: if next prayer is today → today's remaining; if tomorrow → tomorrow's 5
    final nextDate = upcomingPrayers.first.date;
    final listPrayers = upcomingPrayers
        .where((p) =>
            p.date.year == nextDate.year &&
            p.date.month == nextDate.month &&
            p.date.day == nextDate.day)
        .toList();

    if (listPrayers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.translate('upcomingPrayers'),
                style: TextStyle(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/prayer/7days'),
                child: Text(
                  l10n.translate('seeAll'),
                  style: const TextStyle(
                    color: AppColors.teal,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 118,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: listPrayers.length,
            itemBuilder: (context, i) {
              final p = listPrayers[i];
              final isNext = p.key == nextPrayerName;
              final displayed = selectedPrayer ?? (upcomingPrayers.isNotEmpty ? upcomingPrayers.first : null);
              final isSelected = displayed != null &&
                  p.key == displayed.key &&
                  p.date.year == displayed.date.year &&
                  p.date.month == displayed.date.month &&
                  p.date.day == displayed.date.day;
              final dateLabel = _dateLabel(p.date, l10n);
              return GestureDetector(
                onTap: () => onPrayerSelected(p),
                child: PrayerPill(
                  name: _getPrayerDisplayName(p.key, p.date, l10n),
                  time: p.time,
                  isNext: isNext,
                  isSelected: isSelected,
                  dateLabel: dateLabel.isNotEmpty ? dateLabel : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
