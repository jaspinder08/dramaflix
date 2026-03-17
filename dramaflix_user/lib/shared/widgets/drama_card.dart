import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class DramaCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double? progress;
  final bool isPremium;
  final VoidCallback? onTap;

  const DramaCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.progress,
    this.isPremium = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 2 / 3,
                    child: Image.network(imageUrl, fit: BoxFit.cover),
                  ),

                  if (isPremium)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.dramaPink,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "PRO",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  if (progress != null)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 4,
                        color: Colors.white.withOpacity(0.2),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progress!,
                          child: Container(color: AppColors.dramaPink),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
