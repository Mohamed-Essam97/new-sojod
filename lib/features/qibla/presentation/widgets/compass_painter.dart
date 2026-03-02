import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class CompassPainter extends CustomPainter {
  final double heading;
  final double qiblaDirection;
  final bool isDark;
  final bool isAligned;

  CompassPainter({
    required this.heading,
    required this.qiblaDirection,
    required this.isDark,
    required this.isAligned,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerR = size.width / 2;
    final dialR = outerR - 14;
    final innerR = dialR - 22;

    final shadowPaint = Paint()
      ..color = (isDark ? Colors.black : Colors.grey).withOpacity(0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(center, outerR - 2, shadowPaint);

    canvas.drawCircle(
      center,
      dialR,
      Paint()
        ..shader = RadialGradient(
          colors: isDark
              ? [const Color(0xFF1E2D2D), const Color(0xFF0F1A1A)]
              : [const Color(0xFFEEF7F6), const Color(0xFFD5EDE9)],
        ).createShader(Rect.fromCircle(center: center, radius: dialR)),
    );

    canvas.drawCircle(
      center,
      dialR,
      Paint()
        ..color = AppColors.teal.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    const cardinals = ['N', 'E', 'S', 'W'];
    const cardinalAngles = [0.0, 90.0, 180.0, 270.0];

    for (int i = 0; i < 360; i += 5) {
      final angle = i * math.pi / 180;
      final isCardinal = i % 90 == 0;
      final isMajor = i % 30 == 0;

      final tickLen = isCardinal ? 14.0 : (isMajor ? 9.0 : 5.0);
      final tickStart = dialR - tickLen;

      final sin = math.sin(angle);
      final cos = math.cos(angle);

      final p1 = Offset(
        center.dx + tickStart * sin,
        center.dy - tickStart * cos,
      );
      final p2 = Offset(
        center.dx + (dialR - 1) * sin,
        center.dy - (dialR - 1) * cos,
      );

      canvas.drawLine(
        p1,
        p2,
        Paint()
          ..color = isCardinal
              ? (i == 0 ? AppColors.red : AppColors.teal.withOpacity(0.9))
              : (isDark ? Colors.white24 : Colors.black26)
          ..strokeWidth = isCardinal ? 2.5 : (isMajor ? 1.5 : 0.8)
          ..strokeCap = StrokeCap.round,
      );
    }

    final labelR = dialR - 30;
    for (int i = 0; i < 4; i++) {
      final angle = cardinalAngles[i] * math.pi / 180;
      final labelPos = Offset(
        center.dx + labelR * math.sin(angle),
        center.dy - labelR * math.cos(angle),
      );

      _drawText(
        canvas,
        cardinals[i],
        labelPos,
        fontSize: 13,
        bold: true,
        color: i == 0
            ? AppColors.red
            : (isDark ? Colors.white70 : Colors.black54),
      );
    }

    canvas.drawCircle(
      center,
      innerR,
      Paint()
        ..color = isDark
            ? Colors.white.withOpacity(0.04)
            : Colors.white.withOpacity(0.7),
    );
    canvas.drawCircle(
      center,
      innerR,
      Paint()
        ..color = AppColors.teal.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Arrow angle: relative difference between Qibla bearing and device heading.
    final qiblaAngle = (qiblaDirection - heading) * math.pi / 180;
    _drawQiblaArrow(canvas, center, innerR - 4, qiblaAngle);

    canvas.drawCircle(
      center,
      12,
      Paint()
        ..color = isDark ? const Color(0xFF1E2D2D) : Colors.white
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      center,
      12,
      Paint()
        ..color = AppColors.teal
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    canvas.drawCircle(center, 4, Paint()..color = AppColors.teal);
  }

  void _drawQiblaArrow(
      Canvas canvas, Offset center, double arrowLen, double angle) {
    final sin = math.sin(angle);
    final cos = math.cos(angle);

    final tipLen = arrowLen;
    final tip = Offset(center.dx + tipLen * sin, center.dy - tipLen * cos);

    final tailLen = arrowLen * 0.35;
    final tail = Offset(
        center.dx - tailLen * sin, center.dy + tailLen * cos);

    final headSize = 14.0;
    final perpX = cos * headSize * 0.45;
    final perpY = sin * headSize * 0.45;
    final backX = -sin * headSize;
    final backY = cos * headSize;

    final headLeft = Offset(
        tip.dx + backX - perpX, tip.dy - backY - perpY);
    final headRight = Offset(
        tip.dx + backX + perpX, tip.dy - backY + perpY);

    final arrowColor =
        isAligned ? AppColors.emerald : const Color(0xFFD4AF37);

    canvas.drawLine(
      tail,
      tip,
      Paint()
        ..color = arrowColor.withOpacity(0.25)
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    canvas.drawLine(
      tail,
      tip,
      Paint()
        ..color = arrowColor
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );

    final headPath = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(headLeft.dx, headLeft.dy)
      ..lineTo(headRight.dx, headRight.dy)
      ..close();
    canvas.drawPath(headPath, Paint()..color = arrowColor);

    _drawKaabaIcon(canvas, tip, arrowColor);
  }

  void _drawKaabaIcon(Canvas canvas, Offset position, Color color) {
    final size = 10.0;
    final rect = Rect.fromCenter(
        center: Offset(position.dx, position.dy - size * 2),
        width: size * 1.4,
        height: size * 1.4);

    canvas.drawRect(
      rect,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
    canvas.drawRect(
      rect,
      Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset position, {
    double fontSize = 12,
    bool bold = false,
    Color color = Colors.white,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(
      canvas,
      Offset(position.dx - tp.width / 2, position.dy - tp.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CompassPainter old) =>
      old.heading != heading ||
      old.qiblaDirection != qiblaDirection ||
      old.isAligned != isAligned ||
      old.isDark != isDark;
}
