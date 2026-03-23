import 'package:flutter/material.dart';
import 'package:dramaflix_shared/dramaflix_shared.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../widgets/glass_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String selectedFilter = 'Most liked';

  final List<Map<String, dynamic>> _feedItems = [
    {
      'title': 'The Silent Echo',
      'views': '1.2M',
      'likes': '450k',
      'shares': '12k',
      'engagement': '8.5%',
      'status': 'featured',
    },
    {
      'title': 'Night City Lights',
      'views': '850k',
      'likes': '320k',
      'shares': '8k',
      'engagement': '7.2%',
      'status': 'active',
    },
    {
      'title': 'Shadow Box',
      'views': '2.1M',
      'likes': '980k',
      'shares': '45k',
      'engagement': '12.4%',
      'status': 'pinned',
    },
    {
      'title': 'Summer Breeze',
      'views': '1.5M',
      'likes': '600k',
      'shares': '18k',
      'engagement': '9.1%',
      'status': 'active',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          _buildFilters(),
          const SizedBox(height: 32),
          Expanded(child: _buildFeedGrid()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Feed Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 4),
            Text('Manage trailers and high-engagement short vertical videos', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showAddFeedDialog(),
          icon: const Icon(LucideIcons.plus, size: 18),
          label: const Text('Add to Feed'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.dramaPink,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    final filters = ['All', 'Most liked', 'Most viewed', 'Newest'];
    return Row(
      children: filters.map((filter) {
        final isSelected = selectedFilter == filter;
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: ChoiceChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (v) => setState(() => selectedFilter = filter),
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            selectedColor: AppColors.dramaPink.withValues(alpha: 0.2),
            labelStyle: TextStyle(color: isSelected ? AppColors.dramaPink : AppColors.textSecondary),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFeedGrid() {
    return AnimationLimiter(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 0.7,
        ),
        itemCount: _feedItems.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            columnCount: 4,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildFeedCard(_feedItems[index]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeedCard(Map<String, dynamic> item) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Preview Placeholder
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: const Center(child: Icon(LucideIcons.playCircle, size: 48, color: AppColors.textSecondary)),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: _buildStatusBadge(item['status']),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                const SizedBox(height: 16),
                _buildStat(LucideIcons.eye, '${item['views']} views'),
                const SizedBox(height: 8),
                _buildStat(LucideIcons.heart, '${item['likes']} likes'),
                const SizedBox(height: 8),
                _buildStat(LucideIcons.share2, '${item['shares']} shares'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('Engagement: ${item['engagement']}', style: const TextStyle(color: AppColors.dramaPink, fontSize: 12, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(icon: const Icon(LucideIcons.edit3, size: 16), onPressed: () {}, color: AppColors.textSecondary),
                    IconButton(icon: const Icon(LucideIcons.trash2, size: 16), onPressed: () {}, color: Colors.redAccent),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(value, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = AppColors.dramaPink;
    if (status == 'pinned') color = Colors.orange;
    if (status == 'featured') color = Colors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status.toUpperCase(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  void _showAddFeedDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add to Feed', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 24),
              _buildUploadBox('Upload Trailer Video', LucideIcons.uploadCloud),
              const SizedBox(height: 20),
              _buildTextField('Select Drama', LucideIcons.clapperboard),
              const SizedBox(height: 16),
              _buildTextField('Caption', LucideIcons.text),
              const SizedBox(height: 16),
              _buildTextField('Tags (comma separated)', LucideIcons.tag),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dramaPink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Add to Feed'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildUploadBox(String label, IconData icon) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 24),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}
