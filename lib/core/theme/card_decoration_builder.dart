import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

/// Card Decoration Helper
///
/// Helper class to build BoxDecoration for cards with consistent styling.
class CardDecorationBuilder {
  /// Builds a standard card decoration with surface color, border, and shadow.
  static BoxDecoration buildCardDecoration({
    required ColorScheme colorScheme,
    double? borderRadius,
    double? borderOpacity,
    double? shadowOpacity,
    double? blurRadius,
    Offset? shadowOffset,
  }) {
    return BoxDecoration(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(
        borderRadius ?? AppConstants.mediumRadius,
      ),
      border: Border.all(
        color: colorScheme.outline.withValues(alpha: borderOpacity ?? 0.2),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: colorScheme.shadow.withValues(alpha: shadowOpacity ?? 0.05),
          blurRadius: blurRadius ?? 8,
          offset: shadowOffset ?? const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration buildCardDecorationWithBorder({
    required ColorScheme colorScheme,
    double? borderRadius,
    double? borderOpacity,
    double? shadowOpacity,
    double? blurRadius,
    Offset? shadowOffset,
    Color? borderColor,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(
        borderRadius ?? AppConstants.mediumRadius,
      ),
      border: Border.all(
        color:
            borderColor ??
            colorScheme.outline.withValues(alpha: borderOpacity ?? 0.2),
        width: 1,
      ),
    );
  }

  /// Builds a liquid glass decoration with translucent surface color and soft shadow.
  static BoxDecoration buildLiquidGlassDecoration({
    required ColorScheme colorScheme,
    double? borderRadius,
    double? shadowOpacity,
    double? blurRadius,
    Offset? shadowOffset,
  }) {
    return BoxDecoration(
      color: colorScheme.surface.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(
        borderRadius ?? AppConstants.mediumRadius,
      ),
      boxShadow: [
        BoxShadow(
          color: colorScheme.shadow.withValues(alpha: shadowOpacity ?? 0.05),
          blurRadius: blurRadius ?? 8,
          offset: shadowOffset ?? const Offset(0, 2),
        ),
      ],
    );
  }

  /// Builds a solid liquid glass decoration with full opacity surface color and soft shadow.
  static BoxDecoration buildLiquidGlassDecorationSolid({
    required ColorScheme colorScheme,
    double? borderRadius,
    double? shadowOpacity,
    double? blurRadius,
    Offset? shadowOffset,
  }) {
    return BoxDecoration(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(
        borderRadius ?? AppConstants.mediumRadius,
      ),
      boxShadow: [
        BoxShadow(
          color: colorScheme.shadow.withValues(alpha: shadowOpacity ?? 0.05),
          blurRadius: blurRadius ?? 8,
          offset: shadowOffset ?? const Offset(0, 2),
        ),
      ],
    );
  }

  /// Builds a card decoration with prominent shadow.
  static BoxDecoration buildCardShadowDecoration({
    required ColorScheme colorScheme,
    double? borderRadius,
    double? shadowOpacity,
    double? blurRadius,
    Offset? shadowOffset,
    Color? surfaceColor,
    Border? border,
  }) {
    return BoxDecoration(
      color: surfaceColor ?? colorScheme.surface,
      borderRadius: BorderRadius.circular(
        borderRadius ?? AppConstants.mediumRadius,
      ),
      border: border,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: shadowOpacity ?? 0.06),
          blurRadius: blurRadius ?? 26,
          offset: shadowOffset ?? const Offset(0, 4),
        ),
      ],
    );
  }
}
