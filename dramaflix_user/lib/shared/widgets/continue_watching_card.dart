import 'package:flutter/material.dart';
import 'package:dramaflix_shared/dramaflix_shared.dart';

class ContinueWatchingCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final double progress;
  final VoidCallback? onTap;

  const ContinueWatchingCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260, // Wider for banner style
        margin: const EdgeInsets.only(right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9, // Horizontal aspect ratio
                    child: Image.network(imageUrl, fit: BoxFit.cover),
                  ),
                  // Play button overlay
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  // Progress bar
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 4,
                      color: Colors.white.withOpacity(0.2),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.dramaPink,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.dramaPink.withOpacity(0.5),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
