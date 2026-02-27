import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ReciterTile extends StatelessWidget {
  final String id;
  final String displayName;
  final String? subName;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const ReciterTile({
    super.key,
    required this.id,
    required this.displayName,
    this.subName,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? AppColors.teal
                      : AppColors.teal.withOpacity(0.08),
                ),
                child: Icon(
                  isSelected ? Icons.check_rounded : Icons.person_rounded,
                  color: isSelected
                      ? Colors.white
                      : AppColors.teal.withOpacity(0.5),
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? AppColors.teal
                            : (isDark ? Colors.white : Colors.black87),
                      ),
                    ),
                    if (subName != null)
                      Text(
                        subName!,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.radio_button_checked_rounded,
                  color: AppColors.teal,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
