import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.dramaPink,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.dramaPink,
        secondary: AppColors.dramaPurple,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: AppTypography.textTheme,
      useMaterial3: true,
    );
  }
}
