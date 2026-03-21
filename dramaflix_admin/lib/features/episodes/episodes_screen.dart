import 'package:flutter/material.dart';
import 'package:dramaflix_shared/dramaflix_shared.dart';
import '../../widgets/app_card.dart';

class EpisodesScreen extends StatelessWidget {
  const EpisodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Manage Episodes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              AppButton(
                text: 'Add New Episode',
                width: 180,
                onPressed: () => _showAddEpisodeDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: AppCard(
              padding: EdgeInsets.zero,
              width: double.infinity,
              child: Column(
                children: [
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: const Row(
                      children: [
                        Expanded(flex: 3, child: Text('Episode Title', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        Expanded(flex: 2, child: Text('Drama Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        Expanded(flex: 1, child: Text('No.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        Expanded(flex: 1, child: Text('Duration', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        Expanded(flex: 1, child: Text('Actions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                  // Table Body
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: 10,
                      separatorBuilder: (context, index) => Divider(
                        color: AppColors.textSecondary.withOpacity(0.05),
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Episode ${index + 1}: The Beginning',
                                  style: const TextStyle(color: Colors.white, fontSize: 13),
                                ),
                              ),
                              const Expanded(
                                flex: 2,
                                child: Text(
                                  'Silent Echoes',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '#${index + 1}',
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                ),
                              ),
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  '0:45',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        color: AppColors.dramaPink,
                                        size: 18,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.redAccent,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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

  void _showAddEpisodeDialog(BuildContext context) {
     showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Add New Episode', style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               const Align(
                alignment: Alignment.centerLeft,
                child: Text('Select Drama', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.textSecondary.withOpacity(0.2)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: 'Silent Echoes',
                    dropdownColor: AppColors.surface,
                    style: const TextStyle(color: Colors.white),
                    items: ['Silent Echoes', 'Night City', 'Shadow Box'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (_) {},
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: TextEditingController(),
                label: 'Episode Title',
                prefixIcon: Icons.title,
                hintText: 'Enter episode title',
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: TextEditingController(),
                label: 'Episode Number',
                prefixIcon: Icons.tag,
                hintText: 'e.g. 1',
              ),
              const SizedBox(height: 24),
               Row(
                 children: [
                   Expanded(child: _buildUploadBox('Video File', Icons.video_file_outlined)),
                   const SizedBox(width: 16),
                   Expanded(child: _buildUploadBox('Thumbnail', Icons.image_outlined)),
                 ],
               ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          AppButton(
            text: 'Save Episode',
            width: 130,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadBox(String label, IconData icon) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textSecondary.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
        color: AppColors.background,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 24),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
        ],
      ),
    );
  }
}
