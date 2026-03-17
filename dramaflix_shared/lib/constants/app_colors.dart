import 'package:flutter/material.dart';

class AppColors {
  /// Brand Colors (Logo Inspired)
  static const Color dramaPink = Color(0xFFE93B6F);
  static const Color dramaOrange = Color(0xFFFF8A3D);
  static const Color dramaPurple = Color(0xFF7B3FE4);
  static const Color dramaViolet = Color(0xFF4A2DBF);

  /// Background Colors
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF1A1A1D);
  static const Color black = Colors.black;
  static const Color transperant = Colors.transparent;

  /// Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A0A5);

  /// Accent Color
  static const Color accent = dramaPink;

  /// Main Brand Gradient (Used for buttons / highlights)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [dramaPink, dramaPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Logo Gradient (For logo masks or decorative UI)
  static const LinearGradient logoGradient = LinearGradient(
    colors: [dramaOrange, dramaPink, dramaPurple],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
