import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SettingsCard extends StatelessWidget {
  final List<Widget> children;
  final bool isDark;

  const SettingsCard({
    super.key,
    required this.children,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.15 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class SettingsCardDivider extends StatelessWidget {
  final bool isDark;

  const SettingsCardDivider({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 56,
      color: isDark
          ? Colors.white.withOpacity(0.06)
          : Colors.grey.withOpacity(0.1),
    );
  }
}
