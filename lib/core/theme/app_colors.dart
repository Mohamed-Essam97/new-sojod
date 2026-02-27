import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary - Teal Islamic theme
  static const Color teal = Color(0xFF00897B);
  static const Color tealLight = Color(0xFF4DB6AC);
  static const Color tealDark = Color(0xFF00695C);

  // Light mode
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightCard = Color(0xFFFFFFFF);

  // Dark mode
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkText = Color(0xFFE0E0E0);

  // Text & icons - theme-aware
  static const Color textPrimaryLight = Color(0xDD000000);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryLight = Color(0x8A000000);
  static const Color textSecondaryDark = Color(0xFF9E9E9E);

  // Greys (muted elements)
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFE0E0E0);
  static const Color greyDark = Color(0xFFBDBDBD);

  // On colored surfaces (e.g. teal card)
  static const Color onSurface = Color(0xFFFFFFFF);
  static const Color onSurfaceMuted = Color(0xB3FFFFFF);

  // Overlays & borders
  static const Color overlayLight = Color(0x33FFFFFF); // 20% white
  static const Color cardLightTranslucent = Color(0x1FFFFFFF); // ~12% white
  static const Color borderMuted = Color(0x1AFFFFFF); // ~10% white

  // Quran reading themes
  static const Color sepiaBackground = Color(0xFFF4E4C1);
  static const Color sepiaText = Color(0xFF5D4037);
  static const Color greenBackground = Color(0xFFE8F5E9);
  static const Color greenText = Color(0xFF2E7D32);
  static const Color blueBackground = Color(0xFFE3F2FD);
  static const Color blueText = Color(0xFF1565C0);
  static const Color pinkBackground = Color(0xFFFCE4EC);
  static const Color pinkText = Color(0xFFC2185B);
}
