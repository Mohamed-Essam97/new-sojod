import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/compass_widget.dart';
import '../widgets/direction_hint.dart';
import '../widgets/info_row.dart';
import '../widgets/kaaba_card.dart';
import '../widgets/qibla_header.dart';

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage>
    with SingleTickerProviderStateMixin {
  double _heading = 0;
  double? _qiblaDirection;
  bool _isLoading = true;
  String? _locationName;
  StreamSubscription<CompassEvent>? _compassSub;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _initCompass();
    _calculateQibla();
  }

  void _initCompass() {
    _compassSub = FlutterCompass.events?.listen((event) {
      if (event.heading != null && mounted) {
        setState(() => _heading = (event.heading! + 180) % 360);
      }
    });
  }

  Future<void> _calculateQibla() async {
    try {
      final pos = await Geolocator.getCurrentPosition();
      final coords = Coordinates(pos.latitude, pos.longitude);
      final qibla = Qibla(coords);
      if (mounted) {
        setState(() {
          _qiblaDirection = qibla.direction;
          _isLoading = false;
          _locationName =
              '${pos.latitude.toStringAsFixed(3)}°, ${pos.longitude.toStringAsFixed(3)}°';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _qiblaDirection = 0;
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _compassSub?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  double get _angleDiff {
    if (_qiblaDirection == null) return 180;
    double diff = (_qiblaDirection! - _heading) % 360;
    if (diff > 180) diff -= 360;
    return diff;
  }

  bool get _isAligned => _angleDiff.abs() < 5;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final directionHint = DirectionHint.buildHint(l10n, _angleDiff);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          QiblaHeader(isDark: isDark, locationName: _locationName),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.teal),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        InfoRow(
                          heading: _heading,
                          qibla: _qiblaDirection ?? 0,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 32),
                        CompassWidget(
                          heading: _heading,
                          qiblaDirection: _qiblaDirection ?? 0,
                          isDark: isDark,
                          isAligned: _isAligned,
                          pulseAnimation: _pulseAnimation,
                        ),
                        const SizedBox(height: 32),
                        DirectionHint(
                          hint: directionHint,
                          isAligned: _isAligned,
                          angleDiff: _angleDiff,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 24),
                        KaabaCard(isDark: isDark),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
