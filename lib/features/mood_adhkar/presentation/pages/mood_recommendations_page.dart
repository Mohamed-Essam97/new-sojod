import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/mood_adhkar_data.dart';
import '../../domain/entities/mood.dart';
import '../../domain/entities/mood_recommendation.dart';

class MoodRecommendationsPage extends StatelessWidget {
  final Mood mood;

  const MoodRecommendationsPage({
    super.key,
    required this.mood,
  });

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final recommendation = MoodAdhkarData.getRecommendation(mood);
    final moodColor = _getMoodColor();

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: isDark ? const Color(0xFF0F1A1A) : Colors.white,
            iconTheme: IconThemeData(
              color: moodColor,
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getMoodIcon(),
                    color: moodColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.translate(mood.getLocalizedKey()),
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0F2626),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      moodColor.withOpacity(0.15),
                      moodColor.withOpacity(0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  l10n.translate('recommendedForYou'),
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : const Color(0xFF3D5656),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSection(
                  context,
                  l10n.translate('duas'),
                  Icons.menu_book_outlined,
                  recommendation.duas
                      .map((d) => _DuaCard(
                            dua: d,
                            isDark: isDark,
                            moodColor: moodColor,
                          ))
                      .toList(),
                  isDark,
                  moodColor,
                ),
                const SizedBox(height: 24),
                _buildSection(
                  context,
                  l10n.translate('ayahs'),
                  Icons.book_outlined,
                  recommendation.ayahs
                      .map((a) => _AyahCard(
                            ayah: a,
                            isDark: isDark,
                            moodColor: moodColor,
                          ))
                      .toList(),
                  isDark,
                  moodColor,
                ),
                const SizedBox(height: 24),
                _buildSection(
                  context,
                  l10n.translate('dhikr'),
                  Icons.circle_outlined,
                  recommendation.dhikr
                      .map((d) => _DhikrCard(
                            dhikr: d,
                            isDark: isDark,
                            moodColor: moodColor,
                          ))
                      .toList(),
                  isDark,
                  moodColor,
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
    bool isDark,
    Color moodColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: moodColor,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F2626),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

class _DuaCard extends StatelessWidget {
  final DuaRecommendation dua;
  final bool isDark;
  final Color moodColor;

  const _DuaCard({
    required this.dua,
    required this.isDark,
    required this.moodColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2626) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: moodColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dua.arabic,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 20,
              height: 1.8,
              fontFamily: 'TafsirFont',
              color: isDark ? Colors.white : const Color(0xFF0F2626),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: moodColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dua.transliteration,
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: isDark ? Colors.white70 : const Color(0xFF3D5656),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  dua.translation,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white : const Color(0xFF0F2626),
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

class _AyahCard extends StatelessWidget {
  final AyahRecommendation ayah;
  final bool isDark;
  final Color moodColor;

  const _AyahCard({
    required this.ayah,
    required this.isDark,
    required this.moodColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2626) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: moodColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.teal.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  ayah.reference,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.teal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            ayah.arabic,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 22,
              height: 1.8,
              fontFamily: 'QuranFont',
              color: isDark ? Colors.white : const Color(0xFF0F2626),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: moodColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              ayah.translation,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : const Color(0xFF0F2626),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DhikrCard extends StatelessWidget {
  final DhikrRecommendation dhikr;
  final bool isDark;
  final Color moodColor;

  const _DhikrCard({
    required this.dhikr,
    required this.isDark,
    required this.moodColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2626) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: moodColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dhikr.count != null)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: moodColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.repeat,
                        size: 14,
                        color: moodColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${dhikr.count}×',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: moodColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          if (dhikr.count != null) const SizedBox(height: 12),
          Text(
            dhikr.arabic,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 20,
              height: 1.8,
              fontFamily: 'TafsirFont',
              color: isDark ? Colors.white : const Color(0xFF0F2626),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: moodColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dhikr.transliteration,
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: isDark ? Colors.white70 : const Color(0xFF3D5656),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  dhikr.translation,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white : const Color(0xFF0F2626),
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
