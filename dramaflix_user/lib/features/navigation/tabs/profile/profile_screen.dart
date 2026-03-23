import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dramaflix_shared/dramaflix_shared.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../shared/widgets/continue_watching_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.surface,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      authState.name ?? "User Name",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      authState.email ?? "user@example.com",
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Continue Watching section
              const Text(
                "Continue Watching",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  itemCount: 3,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ContinueWatchingCard(
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
              _buildProfileOption(
                icon: Icons.favorite_border,
                title: "My Watchlist",
                onTap: () {
                  context.push(AppRoutes.watchlist);
                },
              ),
              _buildProfileOption(
                icon: Icons.settings_outlined,
                title: "App Settings",
                onTap: () {},
              ),
              _buildProfileOption(
                icon: Icons.help_outline,
                title: "Help & Feedback",
                onTap: () {},
              ),
              _buildProfileOption(
                icon: Icons.info_outline,
                title: "About us",
                onTap: () {},
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.redAccent),
                ),
                onTap: () async {
                  final success = await ref
                      .read(authProvider.notifier)
                      .signOut();
                  if (context.mounted && success) {
                    context.go(AppRoutes.getStarted);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(title),
      trailing:
          trailing ??
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
