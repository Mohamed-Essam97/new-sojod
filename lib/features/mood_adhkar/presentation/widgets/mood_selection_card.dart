import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/mood.dart';
import '../pages/mood_recommendations_page.dart';

class MoodSelectionCard extends StatelessWidget {
  const MoodSelectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1A3A3A),
                  const Color(0xFF0F2626),
                ]
              : [
                  const Color(0xFFE0F7F4),
                  const Color(0xFFB8E6DD),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.teal.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.teal.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.mood_outlined,
                  color: AppColors.teal,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.translate('howAreYouFeeling'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F2626),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.translate('selectYourMood'),
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white70 : const Color(0xFF3D5656),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: Mood.values.map((mood) {
              return _MoodChip(
                mood: mood,
                isDark: isDark,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _MoodChip extends StatelessWidget {
  final Mood mood;
  final bool isDark;

  const _MoodChip({
    required this.mood,
    required this.isDark,
  });

  IconData _getMoodIcon() {
    switch (mood) {
      case Mood.anxious:
        return Icons.psychology_outlined;
      case Mood.grateful:
        return Icons.favorite_outline;
      case Mood.sad:
        return Icons.cloud_outlined;
      case Mood.motivated:
        return Icons.rocket_launch_outlined;
    }
  }

  Color _getMoodColor() {
    switch (mood) {
      case Mood.anxious:
        return const Color(0xFFFF9800);
      case Mood.grateful:
        return const Color(0xFFEC4899);
      case Mood.sad:
        return const Color(0xFF6366F1);
      case Mood.motivated:
        return const Color(0xFF10B981);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = _getMoodColor();

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MoodRecommendationsPage(mood: mood),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getMoodIcon(),
              color: color,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.translate(mood.getLocalizedKey()),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? color.withOpacity(0.9) : color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
