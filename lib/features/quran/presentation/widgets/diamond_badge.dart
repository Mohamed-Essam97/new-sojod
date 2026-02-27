import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class DiamondBadge extends StatelessWidget {
  const DiamondBadge({
    super.key,
    required this.number,
  });

  final int number;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      height: 42,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: 0.785,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.teal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppColors.teal.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
            ),
          ),
          Text(
            '$number',
            style: const TextStyle(
              color: AppColors.teal,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
