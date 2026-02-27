import 'package:flutter/material.dart';

import '../../../../core/assets/app_svgs.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import 'nav_item.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barBg = isDark ? AppColors.darkCard : Colors.white;

    final items = [
      (asset: AppSvgs.home, label: l10n.translate('home')),
      (asset: AppSvgs.quran, label: l10n.translate('quran')),
      (asset: AppSvgs.dua, label: l10n.translate('adhkar')),
      (asset: AppSvgs.settings, label: l10n.translate('settings')),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: barBg,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                blurRadius: 24,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: List.generate(items.length, (i) {
              return Expanded(
                child: NavItem(
                  assetPath: items[i].asset,
                  label: items[i].label,
                  isSelected: currentIndex == i,
                  isDark: isDark,
                  onTap: () => onTap(i),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
