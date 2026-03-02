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
  double? _rawHeading;
  double? _qiblaDirection;
  bool _isLoading = true;
  bool _compassAvailable = true;
  bool _locationPermissionDenied = false;
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
    final stream = FlutterCompass.events;
    if (stream == null) {
      setState(() {
        _compassAvailable = false;
      });
      return;
    }

    _compassSub = stream.listen((event) {
      final newHeading = event.heading;
      if (!mounted) return;
      if (newHeading == null) {
        setState(() {
          _compassAvailable = false;
        });
        return;
      }

      _compassAvailable = true;

      // Low-pass filter to smooth sensor noise and rotation.
      const alpha = 0.15;
      if (_rawHeading == null) {
        _rawHeading = newHeading;
        _heading = newHeading;
      } else {
        // Shortest-path interpolation across 0/360 wrap.
        final diff =
            ((newHeading - _heading + 540) % 360) - 180; // range [-180, 180]
        _heading = (_heading + alpha * diff + 360) % 360;
        _rawHeading = newHeading;
      }

      setState(() {});
    });
  }

  Future<void> _calculateQibla() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _locationPermissionDenied = true;
          _isLoading = false;
        });
        return;
      }

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
                : _locationPermissionDenied
                    ? _LocationPermissionView(
                        isDark: isDark,
                        onRequestPermission: () async {
                          final result =
                              await Geolocator.requestPermission();
                          if (result == LocationPermission.always ||
                              result == LocationPermission.whileInUse) {
                            setState(() {
                              _locationPermissionDenied = false;
                              _isLoading = true;
                            });
                            await _calculateQibla();
                          }
                        },
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
                            if (_compassAvailable)
                              CompassWidget(
                                heading: _heading,
                                qiblaDirection: _qiblaDirection ?? 0,
                                isDark: isDark,
                                isAligned: _isAligned,
                                pulseAnimation: _pulseAnimation,
                              )
                            else
                              _CompassUnavailableView(isDark: isDark),
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

class _LocationPermissionView extends StatelessWidget {
  const _LocationPermissionView({
    required this.isDark,
    required this.onRequestPermission,
  });

  final bool isDark;
  final Future<void> Function() onRequestPermission;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_rounded,
              size: 64,
              color: isDark ? Colors.white54 : Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.translate('locationPermissionRequired'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.translate('enableLocationForQibla'),
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRequestPermission,
              icon: const Icon(Icons.my_location_rounded),
              label: Text(l10n.translate('enableLocation')),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompassUnavailableView extends StatelessWidget {
  const _CompassUnavailableView({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Icon(
          Icons.explore_off_rounded,
          size: 52,
          color: isDark ? Colors.white54 : Colors.grey[600],
        ),
        const SizedBox(height: 12),
        Text(
          l10n.translate('compassUnavailable'),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white70 : Colors.grey[700],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
