import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'compass_painter.dart';

class CompassWidget extends StatelessWidget {
  final double heading;
  final double qiblaDirection;
  final bool isDark;
  final bool isAligned;
  final Animation<double> pulseAnimation;

  const CompassWidget({
    super.key,
    required this.heading,
    required this.qiblaDirection,
    required this.isDark,
    required this.isAligned,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: pulseAnimation,
        builder: (context, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              if (isAligned)
                Container(
                  width: 300 * pulseAnimation.value,
                  height: 300 * pulseAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.teal.withOpacity(
                        0.08 * pulseAnimation.value),
                  ),
                ),
              SizedBox(
                width: 280,
                height: 280,
                child: CustomPaint(
                  painter: CompassPainter(
                    heading: heading,
                    qiblaDirection: qiblaDirection,
                    isDark: isDark,
                    isAligned: isAligned,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
