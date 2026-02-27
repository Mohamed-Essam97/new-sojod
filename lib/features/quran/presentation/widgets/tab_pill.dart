import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class TabPill extends StatelessWidget {
  const TabPill({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
        height: 34,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: active ? AppColors.teal : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: active
                ? Colors.white
                : isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.grey,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
