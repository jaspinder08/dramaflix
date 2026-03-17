import 'package:dramaflix/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomLogoDecor extends StatelessWidget {
  const CustomLogoDecor({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "DramaFlix",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
        foreground: Paint()
          ..shader = LinearGradient(
            colors: [
              AppColors.dramaOrange,
              AppColors.dramaPink,
              AppColors.dramaPurple,
            ],
          ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
      ),
    );
  }
}
