import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';

class NavItem extends StatelessWidget {
  final String assetPath;
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.assetPath,
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor =
        isSelected ? AppColors.teal : (isDark ? AppColors.grey : AppColors.grey);
    final labelColor = isSelected
        ? AppColors.teal
        : (isDark ? AppColors.textSecondaryDark : AppColors.grey);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.teal.withValues(alpha: 0.13)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: SvgPicture.asset(
              assetPath,
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: labelColor,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
