import 'package:flutter/material.dart';
import 'package:dramaflix_shared/dramaflix_shared.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../widgets/glass_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Analytics & Engagement', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 32),
          _buildTopMetrics(),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildEngagementChart()),
              const SizedBox(width: 32),
              Expanded(child: _buildCompletionRate()),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildFeedPerformance()),
              const SizedBox(width: 32),
              Expanded(child: _buildHookRateChart()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopMetrics() {
    return Row(
      children: [
        Expanded(child: _buildMetricCard('Avg Feed Engagement', '14.2%', LucideIcons.flame, AppColors.dramaPink)),
        const SizedBox(width: 24),
        Expanded(child: _buildMetricCard('Episode Completion', '68%', LucideIcons.playCircle, Colors.green)),
        const SizedBox(width: 24),
        Expanded(child: _buildMetricCard('Feed Hook Rate', '42%', LucideIcons.anchor, Colors.blue)),
        const SizedBox(width: 24),
        Expanded(child: _buildMetricCard('New Subscribers', '+1,240', LucideIcons.userPlus, AppColors.dramaPurple)),
      ],
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return GlassCard(
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementChart() {
    return GlassCard(
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Feed Engagement (Likes vs Views)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 32),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        return Text(days[value.toInt()], style: const TextStyle(color: AppColors.textSecondary, fontSize: 12));
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _createBarGroup(0, 40, 25),
                  _createBarGroup(1, 60, 45),
                  _createBarGroup(2, 50, 35),
                  _createBarGroup(3, 85, 65),
                  _createBarGroup(4, 70, 50),
                  _createBarGroup(5, 90, 75),
                  _createBarGroup(6, 80, 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _createBarGroup(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: y1, color: AppColors.dramaPink, width: 8, borderRadius: BorderRadius.circular(4)),
        BarChartRodData(toY: y2, color: AppColors.dramaPurple.withValues(alpha: 0.5), width: 8, borderRadius: BorderRadius.circular(4)),
      ],
    );
  }

  Widget _buildCompletionRate() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Episode Completion Rate', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 24),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: 0.68,
                    strokeWidth: 12,
                    color: AppColors.dramaPink,
                    backgroundColor: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                const Column(
                  children: [
                    Text('68%', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('completed', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildCompletionStat('Started Episode', '1.2M', Colors.blue),
          _buildCompletionStat('Midpoint Reach', '840k', AppColors.dramaPurple),
          _buildCompletionStat('Fully Watched', '682k', AppColors.dramaPink),
        ],
      ),
    );
  }

  Widget _buildCompletionStat(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ],
          ),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFeedPerformance() {
    return GlassCard(
      height: 380,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Feed Content Performance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 24),
          _buildFeedPerfItem('Silent Echoes Trailer', 0.92, '9.2% engagement'),
          _buildFeedPerfItem('Night City Highlight', 0.75, '7.5% engagement'),
          _buildFeedPerfItem('Shadow Box Hook', 0.88, '8.8% engagement'),
          _buildFeedPerfItem('Summer Breeze Teaser', 0.45, '4.5% engagement'),
        ],
      ),
    );
  }

  Widget _buildFeedPerfItem(String name, double progress, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(color: Colors.white, fontSize: 14)),
              Text(label, style: TextStyle(color: AppColors.dramaPink.withValues(alpha: 0.8), fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            color: AppColors.dramaPink,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }

  Widget _buildHookRateChart() {
    return GlassCard(
      height: 380,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hook Rate (First 3s Retention)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 24),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 100),
                      FlSpot(1, 98),
                      FlSpot(2, 95),
                      FlSpot(3, 42), // Significant drop
                      FlSpot(4, 38),
                      FlSpot(5, 35),
                      FlSpot(6, 32),
                    ],
                    isCurved: true,
                    color: Colors.blueAccent,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blueAccent.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Users dropout sharply after 3 seconds of Feed content.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}
