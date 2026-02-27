import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class DirectionHint extends StatelessWidget {
  final String hint;
  final bool isAligned;
  final double angleDiff;
  final bool isDark;

  const DirectionHint({
    super.key,
    required this.hint,
    required this.isAligned,
    required this.angleDiff,
    required this.isDark,
  });

  static String buildHint(AppLocalizations l10n, double angleDiff) {
    if (angleDiff.abs() < 5) {
      return l10n.translate('facingQibla');
    }
    final deg = angleDiff.abs().toStringAsFixed(0);
    if (angleDiff > 0) {
      return l10n.translate('turnRight', [deg]);
    }
    return l10n.translate('turnLeft', [deg]);
  }

  @override
  Widget build(BuildContext context) {
    final color = isAligned ? AppColors.emerald : AppColors.teal;
    final icon = isAligned
        ? Icons.check_circle_rounded
        : (angleDiff > 0
            ? Icons.rotate_right_rounded
            : Icons.rotate_left_rounded);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1.4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Text(
            hint,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
