import 'package:flutter/material.dart';
import 'package:dramaflix_shared/dramaflix_shared.dart';
import '../../widgets/app_card.dart';

class DramasScreen extends StatelessWidget {
  const DramasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Manage Dramas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              AppButton(
                text: 'Add New Drama',
                width: 180,
                onPressed: () => _showAddDramaDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.8,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: 8,
              itemBuilder: (context, index) {
                return _buildDramaCard(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDramaCard(BuildContext context, int index) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://picsum.photos/seed/${index + 10}/400/600',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.background.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.dramaPink,
                      size: 20,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.dramaPink.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'TRAILER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Drama Title ${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                const Text(
                  '12 Episodes',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Edit',
                        style: TextStyle(color: AppColors.dramaPink),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'View',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDramaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Add New Drama',
          style: TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: TextEditingController(),
                label: 'Drama Title',
                prefixIcon: Icons.title,
                hintText: 'Enter drama name',
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: TextEditingController(),
                label: 'Description',
                prefixIcon: Icons.description_outlined,
                hintText: 'Enter short description',
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                   Expanded(child: _buildUploadBox('Cover Image', Icons.image_outlined)),
                   const SizedBox(width: 16),
                   Expanded(child: _buildUploadBox('Trailer Video', Icons.movie_outlined)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          AppButton(
            text: 'Save Drama',
            width: 120,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadBox(String label, IconData icon) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.textSecondary.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(12),
        color: AppColors.background,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.textSecondary,
            size: 32,
          ),
          const SizedBox(height: 8),
          const Icon(
            Icons.cloud_upload_outlined,
            color: AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            'Upload $label',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
