import 'dart:async';
import 'dart:math' as math;
import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  double? _heading;
  double? _qiblaDirection;
  StreamSubscription<CompassEvent>? _compassSubscription;

  @override
  void initState() {
    super.initState();
    _initCompass();
    _calculateQibla();
  }

  Future<void> _initCompass() async {
    _compassSubscription = FlutterCompass.events?.listen((event) {
      if (event.heading != null) {
        setState(() => _heading = event.heading);
      }
    });
  }

  Future<void> _calculateQibla() async {
    try {
      final pos = await Geolocator.getCurrentPosition();
      final coordinates = Coordinates(pos.latitude, pos.longitude);
      final qibla = Qibla(coordinates);
      setState(() => _qiblaDirection = qibla.direction);
    } catch (_) {
      setState(() => _qiblaDirection = 0);
    }
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('qibla')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              height: 250,
              child: CustomPaint(
                painter: _CompassPainter(
                  heading: _heading ?? 0,
                  qiblaDirection: _qiblaDirection ?? 0,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              _qiblaDirection != null
                  ? 'Qibla: ${_qiblaDirection!.toStringAsFixed(1)}°'
                  : 'Calculating...',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _CompassPainter extends CustomPainter {
  final double heading;
  final double qiblaDirection;

  _CompassPainter({required this.heading, required this.qiblaDirection});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Background circle
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.teal.withOpacity(0.2)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.teal
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Qibla indicator (arrow to Kaaba)
    final qiblaAngle = (qiblaDirection - heading) * math.pi / 180;
    final qiblaEnd = Offset(
      center.dx + radius * math.sin(qiblaAngle),
      center.dy - radius * math.cos(qiblaAngle),
    );
    canvas.drawLine(
      center,
      qiblaEnd,
      Paint()
        ..color = AppColors.teal
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );

    // Center dot
    canvas.drawCircle(center, 8, Paint()..color = AppColors.teal);
  }

  @override
  bool shouldRepaint(covariant _CompassPainter old) =>
      old.heading != heading || old.qiblaDirection != qiblaDirection;
}
