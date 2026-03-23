import 'package:flutter/material.dart';
import 'package:dramaflix_shared/dramaflix_shared.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../widgets/glass_card.dart';

class DramasScreen extends StatefulWidget {
  const DramasScreen({super.key});

  @override
  State<DramasScreen> createState() => _DramasScreenState();
}

class _DramasScreenState extends State<DramasScreen> {
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildFilters(),
        Expanded(child: _buildDramaGrid()),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Drama Management',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 4),
              Text(
                'Total 124 dramas in the library',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () => _showAddDramaDialog(context),
            icon: const Icon(LucideIcons.plus, size: 18),
            label: const Text('Add New Drama'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.dramaPink,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final filters = ['All', 'Published', 'Draft', 'Trending'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (val) => setState(() => selectedFilter = filter),
              backgroundColor: Colors.white.withOpacity(0.05),
              selectedColor: AppColors.dramaPink.withOpacity(0.2),
              checkmarkColor: AppColors.dramaPink,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.dramaPink : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? AppColors.dramaPink.withOpacity(0.5) : Colors.transparent,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDramaGrid() {
    return AnimationLimiter(
      child: GridView.builder(
        padding: const EdgeInsets.all(32),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: 0.7,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
        ),
        itemCount: 15,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: 5,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: _buildDramaCard(index),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDramaCard(int index) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    child: Image.network(
                      'https://picsum.photos/seed/${index + 100}/400/600',
                      fit: BoxFit.cover,
                    ),
                  ),
                  _buildStatusBadge(index),
                  _buildActionsOverlay(),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Drama Title ${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Romance • 24 Episodes',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCardStat(LucideIcons.eye, '1.2M'),
                        _buildCardStat(LucideIcons.heart, '45k Feed Likes'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(int index) {
    bool isPublished = index % 3 != 0;
    return Positioned(
      top: 12,
      left: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: (isPublished ? Colors.green : Colors.orange).withOpacity(0.9),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          isPublished ? 'PUBLISHED' : 'DRAFT',
          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCardStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(value, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }

  Widget _buildActionsOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIconButton(LucideIcons.edit3, () {}),
            const SizedBox(width: 12),
            _buildIconButton(LucideIcons.trash2, () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 18),
        onPressed: onPressed,
      ),
    );
  }

  void _showAddDramaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          width: 600,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Drama',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 24),
              _buildField('Title', LucideIcons.type),
              const SizedBox(height: 16),
              _buildField('Description', LucideIcons.alignLeft, maxLines: 3),
              const SizedBox(height: 16),
              _buildField('Tags (comma separated)', LucideIcons.tag),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildUploadBox('Thumbnail', LucideIcons.image)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildUploadBox('Trailer', LucideIcons.film)),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text('Published', style: TextStyle(color: Colors.white)),
                  const Spacer(),
                  Switch(value: true, onChanged: (v) {}, activeColor: AppColors.dramaPink),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dramaPink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Publish'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, IconData icon, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildUploadBox(String label, IconData icon) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 24),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 4),
          const Text('Upload File', style: TextStyle(color: AppColors.dramaPink, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

