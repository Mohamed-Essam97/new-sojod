import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Centralized Wird logo widget. Use this everywhere for consistent branding.
class WirdLogo extends StatelessWidget {
  const WirdLogo({
    super.key,
    this.size = 48,
    this.color,
  });

  final double size;
  final Color? color;

  static const String _assetPath = 'assets/logo/wird_logo.svg';

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;
    return SvgPicture.asset(
      _assetPath,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(effectiveColor, BlendMode.srcIn),
    );
  }
}
