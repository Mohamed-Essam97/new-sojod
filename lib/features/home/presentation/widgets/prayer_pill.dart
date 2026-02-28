import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';

class PrayerPill extends StatelessWidget {
  const PrayerPill({
    super.key,
    required this.name,
    required this.time,
    required this.isNext,
    this.dateLabel,
  });

  final String name;
  final DateTime time;
  final bool isNext;
  /// Optional label for non-today (e.g. "Tomorrow", "Mon 3")
  final String? dateLabel;

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat.jm().format(time);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isNext
        ? AppColors.teal
        : (isDark ? AppColors.darkCard : Colors.white);
    final nameColor = isNext ? Colors.white : AppColors.teal;
    final timeColor = isNext
        ? AppColors.onSurfaceMuted
        : (isDark ? AppColors.textSecondaryDark : AppColors.grey);

    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isNext
                ? AppColors.teal.withValues(alpha: 0.25)
                : Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isNext
                  ? AppColors.overlayLight
                  : AppColors.teal.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.wb_sunny_rounded,
              size: 14,
              color: isNext ? Colors.white : AppColors.teal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              color: nameColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (dateLabel != null)
            Text(
              dateLabel!,
              style: TextStyle(
                color: timeColor,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          Text(
            timeStr,
            style: TextStyle(
              color: timeColor,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
