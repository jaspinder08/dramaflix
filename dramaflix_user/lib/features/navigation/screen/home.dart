import 'package:dramaflix/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/drama_card.dart';
import '../../../shared/widgets/genre_chip.dart';
import '../../../shared/widgets/banner_section.dart';
import '../../../shared/widgets/continue_watching_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // New Banner Section
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: BannerSection(),
              ),

              // Continue Watching
              _buildSection(
                "Continue Watching",
                SizedBox(
                  height: 200, // Reduced height for banner style
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: 4,
                    itemBuilder: (context, index) => ContinueWatchingCard(
                      imageUrl:
                          "https://picsum.photos/seed/${index + 10}/400/225",
                      title: "The Legend of Drama S1",
                      subtitle: "Episode ${index + 1} - 15:20",
                      progress: 0.6,
                      onTap: () {
                        context.push(AppRoutes.episode);
                      },
                    ),
                  ),
                ),
              ),

              // Categories
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const GenreChip(label: "Romance", isSelected: true),
                      const SizedBox(width: 8),
                      const GenreChip(label: "Thriller"),
                      const SizedBox(width: 8),
                      const GenreChip(label: "Comedy"),
                      const SizedBox(width: 8),
                      const GenreChip(label: "Drama"),
                      const SizedBox(width: 8),
                      const GenreChip(label: "Action"),
                    ],
                  ),
                ),
              ),

              // Trending Now
              _buildSection(
                "Trending Now",
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: 6,
                    itemBuilder: (context, index) => DramaCard(
                      imageUrl:
                          "https://picsum.photos/seed/${index + 40}/200/300",
                      title: "Trending Show ${index + 1}",
                      onTap: () {
                        context.push(AppRoutes.story);
                      },
                    ),
                  ),
                ),
              ),

              // Originals
              _buildSection(
                "DramaFlix Originals",
                SizedBox(
                  height: 270,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: 4,
                    itemBuilder: (context, index) => DramaCard(
                      imageUrl:
                          "https://picsum.photos/seed/${index + 70}/200/300",
                      title: "Original Content",
                      isPremium: true,
                    ),
                  ),
                ),
              ),

              // const SizedBox(height: 8), // Spacing for bottom bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content,
      ],
    );
  }
}
