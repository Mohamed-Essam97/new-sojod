import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/card_decoration_builder.dart';
import '../../../../core/assets/app_svgs.dart';
import '../../../../core/localization/app_localizations.dart';

/// Stacked bottom navigation bar with horizontal insets and shadow.
/// Bar is inset from left/right so the background shows through; creates
/// a stacked/floating look with CardDecorationBuilder.
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final items = [
      (asset: AppSvgs.home, label: l10n.translate('home')),
      (asset: AppSvgs.calendar, label: l10n.translate('hijri')),
      (asset: AppSvgs.dua, label: l10n.translate('adhkar')),
      (asset: AppSvgs.settings, label: l10n.translate('settings')),
    ];

    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(AppConstants.mediumRadius), topRight: Radius.circular(AppConstants.mediumRadius)),
        child: Container(
          height: 70,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppConstants.paddingCard / 2,
              // horizontal: AppConstants.paddingCard / 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StackedNavBarItem(
                  assetPath: items[0].asset,
                  label: items[0].label,
                  isSelected: currentIndex == 0,
                  onTap: () => onTap(0),
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                _StackedNavBarItem(
                  assetPath: items[1].asset,
                  label: items[1].label,
                  isSelected: currentIndex == 1,
                  onTap: () => onTap(1),
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                // const SizedBox(width: 72),
                _StackedNavBarItem(
                  assetPath: items[2].asset,
                  label: items[2].label,
                  isSelected: currentIndex == 2,
                  onTap: () => onTap(2),
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                _StackedNavBarItem(
                  assetPath: items[3].asset,
                  label: items[3].label,
                  isSelected: currentIndex == 3,
                  onTap: () => onTap(3),
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StackedNavBarItem extends StatelessWidget {
  final String assetPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _StackedNavBarItem({
    required this.assetPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.teal : colorScheme.onSurface.withValues(alpha: 0.6);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              assetPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: (textTheme.labelSmall ?? const TextStyle()).copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
