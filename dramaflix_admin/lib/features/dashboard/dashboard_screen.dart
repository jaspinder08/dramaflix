import 'package:flutter/material.dart';
import 'package:dramaflix_shared/dramaflix_shared.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../widgets/glass_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(),
          const SizedBox(height: 32),
          _buildStatsSection(),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildActivityCharts()),
              const SizedBox(width: 32),
              Expanded(child: _buildCategoryDistribution()),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildTopPerformers()),
              const SizedBox(width: 32),
              Expanded(child: _buildRecentActivities()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back, Admin',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Here is what is happening with DramaFlix today.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(LucideIcons.plus, size: 18),
          label: const Text('Add New Drama'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.dramaPink,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 8,
            shadowColor: AppColors.dramaPink.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return AnimationLimiter(
      child: GridView.count(
        crossAxisCount: 5,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 24,
        childAspectRatio: 2.2,
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 375),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(child: widget),
          ),
          children: [
            _buildStatCard('Total Dramas', '124', LucideIcons.clapperboard, AppColors.dramaPink),
            _buildStatCard('Total Episodes', '1,428', LucideIcons.playCircle, AppColors.dramaPurple),
            _buildStatCard('Total Views', '12.4M', LucideIcons.eye, Colors.blueAccent),
            _buildStatCard('Total Users', '245k', LucideIcons.users, Colors.greenAccent),
            _buildStatCard('Total Feed Likes', '842k', LucideIcons.heart, Colors.orangeAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.1)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCharts() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Video Engagement',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Row(
                children: [
                  _buildChartLegend('Feed Likes', AppColors.dramaPink),
                  const SizedBox(width: 16),
                  _buildChartLegend('Total Views', AppColors.dramaPurple),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.white.withOpacity(0.05),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        if (value >= 0 && value < days.length) {
                          return Text(days[value.toInt()],
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 12));
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}k',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 12));
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 30),
                      FlSpot(1, 48),
                      FlSpot(2, 35),
                      FlSpot(3, 85),
                      FlSpot(4, 55),
                      FlSpot(5, 75),
                      FlSpot(6, 65),
                    ],
                    isCurved: true,
                    color: AppColors.dramaPink,
                    barWidth: 4,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [AppColors.dramaPink.withOpacity(0.2), Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 15),
                      FlSpot(1, 28),
                      FlSpot(2, 25),
                      FlSpot(3, 45),
                      FlSpot(4, 35),
                      FlSpot(5, 55),
                      FlSpot(6, 45),
                    ],
                    isCurved: true,
                    color: AppColors.dramaPurple,
                    barWidth: 4,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [AppColors.dramaPurple.withOpacity(0.2), Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }

  Widget _buildCategoryDistribution() {
    return GlassCard(
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Content Categories',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 60,
                sections: [
                  PieChartSectionData(
                    value: 40,
                    color: AppColors.dramaPink,
                    title: 'Romance',
                    radius: 50,
                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  PieChartSectionData(
                    value: 30,
                    color: AppColors.dramaPurple,
                    title: 'Action',
                    radius: 50,
                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  PieChartSectionData(
                    value: 20,
                    color: Colors.blueAccent,
                    title: 'Thriller',
                    radius: 50,
                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  PieChartSectionData(
                    value: 10,
                    color: Colors.orangeAccent,
                    title: 'Comedy',
                    radius: 50,
                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPerformers() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Performing Dramas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All', style: TextStyle(color: AppColors.dramaPink)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPerformerItem('Silent Echoes', 'Romance', '1.2M', '45k', 'https://placeholder.com/100'),
          _buildPerformerItem('Night City', 'Action', '980k', '32k', 'https://placeholder.com/100'),
          _buildPerformerItem('Hidden Truth', 'Thriller', '850k', '28k', 'https://placeholder.com/100'),
          _buildPerformerItem('Summer Love', 'Romance', '740k', '22k', 'https://placeholder.com/100'),
          _buildPerformerItem('Neon Streets', 'Sci-Fi', '620k', '18k', 'https://placeholder.com/100', isLast: true),
        ],
      ),
    );
  }

  Widget _buildPerformerItem(String name, String tag, String views, String likes, String imageUrl, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white10,
              image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                Text(tag, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          _buildPerformerStat(LucideIcons.eye, views),
          const SizedBox(width: 24),
          _buildPerformerStat(LucideIcons.heart, likes),
        ],
      ),
    );
  }

  Widget _buildPerformerStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildRecentActivities() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activities',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 24),
          _buildActivityItem('John Doe joined', '2 mins ago', LucideIcons.userPlus, Colors.blue),
          _buildActivityItem('New Drama "Ocean Depth" published', '15 mins ago', LucideIcons.checkCircle2, Colors.green),
          _buildActivityItem('System Backup complete', '1 hour ago', LucideIcons.hardDrive, Colors.orange),
          _buildActivityItem('Alert: High traffic surge detected', '3 hours ago', LucideIcons.alertTriangle, Colors.red),
          _buildActivityItem('Episode 5 of "Silent" updated', '5 hours ago', LucideIcons.edit3, AppColors.dramaPurple),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String message, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(height: 4),
                Text(time, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

