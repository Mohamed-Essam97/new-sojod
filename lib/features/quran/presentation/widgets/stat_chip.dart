import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class StatChip extends StatelessWidget {
  const StatChip({
    super.key,
    required this.label,
    required this.sub,
  });

  final String label;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardLightTranslucent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            sub,
            style: const TextStyle(
              color: AppColors.onSurfaceMuted,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}
