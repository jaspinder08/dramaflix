import 'package:flutter/material.dart';
import 'package:dramaflix_shared/dramaflix_shared.dart';
import '../../widgets/app_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildStatCard(
                context,
                'Total Dramas',
                '24',
                Icons.movie_filter_outlined,
                AppColors.dramaPink,
              ),
              const SizedBox(width: 24),
              _buildStatCard(
                context,
                'Total Episodes',
                '288',
                Icons.video_library_outlined,
                AppColors.dramaPurple,
              ),
              const SizedBox(width: 24),
              _buildStatCard(
                context,
                'Total Views',
                '1.2M',
                Icons.bar_chart_outlined,
                AppColors.dramaOrange,
              ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              AppButton(
                text: 'Add New Drama',
                width: 180,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          AppCard(
             padding: EdgeInsets.zero,
             child: Column(
               children: List.generate(5, (index) => _buildActivityItem(index)),
             ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: AppCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: index == 4 ? Colors.transparent : AppColors.textSecondary.withOpacity(0.05),
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 4,
            backgroundColor: index == 0 ? AppColors.dramaPink : AppColors.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  index == 0 ? 'New Drama "Silent Echoes" added' : 'Episode 12 of "Night City" updated',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 4),
                const Text(
                  '2 hours ago',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
        ],
      ),
    );
  }
}
