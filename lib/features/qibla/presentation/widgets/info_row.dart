import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class InfoRow extends StatelessWidget {
  final double heading;
  final double qibla;
  final bool isDark;

  const InfoRow({
    super.key,
    required this.heading,
    required this.qibla,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: InfoChip(
            icon: Icons.navigation_rounded,
            label: l10n.translate('heading'),
            value: '${heading.toStringAsFixed(0)}${l10n.translate('degrees')}',
            color: AppColors.indigo,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InfoChip(
            icon: Icons.mosque_rounded,
            label: l10n.translate('qibla'),
            value: '${qibla.toStringAsFixed(1)}${l10n.translate('degrees')}',
            color: AppColors.teal,
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const InfoChip({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.15 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
