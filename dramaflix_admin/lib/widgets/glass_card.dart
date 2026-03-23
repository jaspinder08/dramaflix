import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';


class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;
  final double borderRadius;
  final double blur;
  final double opacity;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.width,
    this.height,
    this.borderRadius = 24.0,
    this.blur = 15.0,
    this.opacity = 0.05,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      width: width,
      height: height,
      blur: blur,
      opacity: opacity,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.fromBorderSide(
        BorderSide(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.1),
          Colors.white.withValues(alpha: 0.02),
        ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
