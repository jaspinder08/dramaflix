import 'package:flutter/material.dart';
import 'package:dramaflix_shared/dramaflix_shared.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        border: Border(
          right: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 48),
          const AppLogo(),
          const SizedBox(height: 48),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _SidebarItem(
                  icon: LucideIcons.layoutDashboard,
                  label: 'Dashboard',
                  isSelected: selectedIndex == 0,
                  onTap: () => onItemSelected(0),
                ),
                _SidebarItem(
                  icon: LucideIcons.clapperboard,
                  label: 'Dramas',
                  isSelected: selectedIndex == 1,
                  onTap: () => onItemSelected(1),
                ),
                _SidebarItem(
                  icon: LucideIcons.playCircle,
                  label: 'Episodes',
                  isSelected: selectedIndex == 2,
                  onTap: () => onItemSelected(2),
                ),
                _SidebarItem(
                  icon: LucideIcons.flame,
                  label: 'Feed',
                  isSelected: selectedIndex == 3,
                  onTap: () => onItemSelected(3),
                ),
                _SidebarItem(
                  icon: LucideIcons.users,
                  label: 'Users',
                  isSelected: selectedIndex == 4,
                  onTap: () => onItemSelected(4),
                ),
                _SidebarItem(
                  icon: LucideIcons.barChart3,
                  label: 'Analytics',
                  isSelected: selectedIndex == 5,
                  onTap: () => onItemSelected(5),
                ),
                _SidebarItem(
                  icon: LucideIcons.settings,
                  label: 'Settings',
                  isSelected: selectedIndex == 6,
                  onTap: () => onItemSelected(6),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10),
          _SidebarItem(
            icon: LucideIcons.logOut,
            label: 'Logout',
            isSelected: false,
            onTap: () {
              // Handle logout
            },
            isDestructive: true,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        AppColors.dramaPink.withValues(alpha: 0.15),
                        AppColors.dramaPurple.withValues(alpha: 0.15),
                      ],
                    )
                  : null,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: AppColors.dramaPink.withValues(alpha: 0.2))
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? AppColors.dramaPink
                      : (isDestructive
                          ? Colors.redAccent.withValues(alpha: 0.8)
                          : AppColors.textSecondary),
                  size: 20,
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.textPrimary
                        : (isDestructive
                            ? Colors.redAccent.withOpacity(0.8)
                            : AppColors.textSecondary),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                    letterSpacing: 0.3,
                  ),
                ),
                if (isSelected) ...[
                  const Spacer(),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: AppColors.dramaPink,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}


