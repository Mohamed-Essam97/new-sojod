import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/wird_logo.dart';

/// Branding-quality in-app splash: logo, app name, subtle Islamic geometric
/// background, 1.2s fade + scale animation.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: _IslamicGeometricPainter(
              color: (isDark ? AppColors.teal : AppColors.teal)
                  .withValues(alpha: 0.06),
              baseColor: bgColor,
            ),
            size: Size.infinite,
          ),
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LogoCircle(isDark: isDark),
                  const SizedBox(height: 28),
                  Text(
                    'Wird',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.teal,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.4,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Al-Mu'min",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoCircle extends StatelessWidget {
  const _LogoCircle({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      height: 112,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.teal.withValues(alpha: isDark ? 0.2 : 0.12),
        boxShadow: [
          BoxShadow(
            color: AppColors.teal.withValues(alpha: 0.25),
            blurRadius: 28,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Center(
        child: WirdLogo(size: 64, color: AppColors.teal),
      ),
    );
  }
}

/// Subtle Islamic geometric pattern (8-fold star / tessellation).
class _IslamicGeometricPainter extends CustomPainter {
  _IslamicGeometricPainter({required this.color, required this.baseColor});

  final Color color;
  final Color baseColor;

  @override
  void paint(Canvas canvas, Size size) {
    const cellSize = 80.0;
    final cols = (size.width / cellSize).ceil() + 2;
    final rows = (size.height / cellSize).ceil() + 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (var row = -1; row <= rows; row++) {
      for (var col = -1; col <= cols; col++) {
        final cx = col * cellSize;
        final cy = row * cellSize;
        _drawStar8(canvas, Offset(cx, cy), cellSize * 0.22, paint);
      }
    }
  }

  void _drawStar8(Canvas canvas, Offset center, double radius, Paint paint) {
    const points = 8;
    final path = Path();
    for (var i = 0; i < points * 2; i++) {
      final r = i.isEven ? radius : radius * 0.45;
      final angle = (i * math.pi / points) - math.pi / 2;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
