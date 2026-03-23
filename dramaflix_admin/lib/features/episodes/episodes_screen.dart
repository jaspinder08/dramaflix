import 'package:flutter/material.dart';
import 'package:dramaflix_shared/dramaflix_shared.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../widgets/glass_card.dart';

class EpisodesScreen extends StatefulWidget {
  const EpisodesScreen({super.key});

  @override
  State<EpisodesScreen> createState() => _EpisodesScreenState();
}

class _EpisodesScreenState extends State<EpisodesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildControls(),
        Expanded(child: _buildEpisodeTable()),
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
                'Episode Management',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 4),
              Text(
                'Control and schedule your content releases',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () => _showAddEpisodeDialog(context),
            icon: const Icon(LucideIcons.plus, size: 18),
            label: const Text('Add New Episode'),
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

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search episodes or dramas...',
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                prefixIcon: const Icon(LucideIcons.search, color: AppColors.textSecondary, size: 20),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(width: 16),
          _buildFilterButton('Drama: All', LucideIcons.filter),
          const SizedBox(width: 16),
          _buildFilterButton('Status: All', LucideIcons.checkCircle),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
          const SizedBox(width: 8),
          const Icon(LucideIcons.chevronDown, size: 14, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildEpisodeTable() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _buildTableHeader(),
            Expanded(
              child: AnimationLimiter(
                child: ListView.separated(
                  itemCount: 12,
                  separatorBuilder: (context, index) => Divider(color: Colors.white.withOpacity(0.05), height: 1),
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _buildTableRow(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          _headerCell('#', 1),
          _headerCell('Episode Info', 4),
          _headerCell('Drama', 3),
          _headerCell('Views', 2),
          _headerCell('Completion %', 2),
          _headerCell('Status', 2),
          _headerCell('Actions', 2),
        ],
      ),
    );
  }

  Widget _headerCell(String label, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildTableRow(int index) {
    bool isLocked = index % 4 == 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text('${index + 1}', style: const TextStyle(color: AppColors.textSecondary))),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('The Beginning of End', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('Duration: 01:24', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          const Expanded(flex: 3, child: Text('Silent Echoes', style: TextStyle(color: Colors.white))),
          const Expanded(flex: 2, child: Text('45.2k', style: TextStyle(color: Colors.white))),
          const Expanded(flex: 2, child: Text('68%', style: TextStyle(color: Colors.greenAccent))),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (isLocked ? Colors.redAccent : Colors.greenAccent).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                isLocked ? 'LOCKED' : 'FREE',
                style: TextStyle(
                  color: isLocked ? Colors.redAccent : Colors.greenAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                _tableAction(LucideIcons.edit3, Colors.blue, () {}),
                const SizedBox(width: 8),
                _tableAction(LucideIcons.trash2, Colors.red, () {}),
                const SizedBox(width: 8),
                _tableAction(isLocked ? LucideIcons.unlock : LucideIcons.lock, Colors.orange, () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableAction(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Icon(icon, size: 18, color: color.withOpacity(0.7)),
    );
  }

  void _showAddEpisodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          width: 500,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Episode',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 24),
              _buildDropdown('Select Drama', ['Silent Echoes', 'Night City', 'Shadow Box']),
              const SizedBox(height: 16),
              _buildField('Episode Number', LucideIcons.hash),
              const SizedBox(height: 16),
              _buildField('Title', LucideIcons.type),
              const SizedBox(height: 24),
              _buildUploadBox('Video File', LucideIcons.video),
              const SizedBox(height: 24),
              Row(
                children: [
                  _buildToggle('Lock Episode', true),
                  const Spacer(),
                  _buildToggle('Schedule', false),
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
                    child: const Text('Add Episode'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: items.first,
              dropdownColor: AppColors.surface,
              icon: const Icon(LucideIcons.chevronDown, size: 18),
              style: const TextStyle(color: Colors.white),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField(String label, IconData icon) {
    return TextField(
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

  Widget _buildToggle(String label, bool value) {
    return Row(
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
        const SizedBox(width: 8),
        Switch(value: value, onChanged: (v) {}, activeColor: AppColors.dramaPink),
      ],
    );
  }

  Widget _buildUploadBox(String label, IconData icon) {
    return Container(
      width: double.infinity,
      height: 100,
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
          const Text('Select Video File', style: TextStyle(color: AppColors.dramaPink, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

