import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ReaderInfoChip extends StatelessWidget {
  const ReaderInfoChip({
    super.key,
    required this.icon,
    required this.label,
    required this.textColor,
  });

  final IconData icon;
  final String label;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.teal.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.teal.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.teal),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.teal,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
