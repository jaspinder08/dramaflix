import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dramaflix_shared/dramaflix_shared.dart';
import '../../../core/router/app_routes.dart';
import '../../../providers/auth_provider.dart';

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
            children: [
              const SizedBox(height: 20),
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
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                authState.email ?? "user@example.com",
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 40),
              _buildProfileOption(
                icon: Icons.favorite_border,
                title: "My Watchlist",
                onTap: () {},
              ),
              _buildProfileOption(
                icon: Icons.settings_outlined,
                title: "App Settings",
                onTap: () {},
              ),
              _buildProfileOption(
                icon: Icons.dark_mode_outlined,
                title: "Help & Feedback",
                onTap: () {},
              ),
              _buildProfileOption(
                icon: Icons.dark_mode_outlined,
                title: "About us",
                onTap: () {},
              ),
              // const SizedBox(height: 16),
              ListTile(
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
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(title),
      trailing:
          trailing ??
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
