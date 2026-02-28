import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/reciter.dart';

class ReciterListItem extends StatelessWidget {
  const ReciterListItem({
    super.key,
    required this.reciter,
    required this.isSelected,
    required this.isDark,
    required this.isRtl,
    required this.onTap,
  });

  final Reciter reciter;
  final bool isSelected;
  final bool isDark;
  final bool isRtl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.teal.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              _buildAvatar(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isRtl ? reciter.nameAr : reciter.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.teal
                            : (isDark ? Colors.white : Colors.black87),
                      ),
                    ),
                    if (reciter.bitrate != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        reciter.bitrate!,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.teal,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    const double size = 48;
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: reciter.imageUrl != null
            ? Image.asset(
                reciter.imageUrl!,
                fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _placeholderAvatar(),
              )
            : _placeholderAvatar(),
      ),
    );
  }

  Widget _placeholderAvatar() {
    return Container(
      color: AppColors.teal.withValues(alpha: 0.2),
      child: Icon(
        Icons.person_rounded,
        color: AppColors.teal.withValues(alpha: 0.6),
        size: 24,
      ),
    );
  }
}
