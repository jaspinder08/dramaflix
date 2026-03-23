import 'package:flutter/material.dart';
import 'package:dramaflix_shared/dramaflix_shared.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../widgets/glass_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 32),
          _buildSettingsSection('General', [
            _buildSettingsItem('App Name', 'DramaFlix Admin', LucideIcons.appWindow),
            _buildSettingsItem('Support Email', 'support@dramaflix.com', LucideIcons.mail),
            _buildSettingsItem('Timezone', '(GMT+05:30) Mumbai, India', LucideIcons.globe),
          ]),
          const SizedBox(height: 32),
          _buildSettingsSection('Platform Configuration', [
            _buildToggleItem('Enable New User Registration', true, LucideIcons.userPlus),
            _buildToggleItem('Maintenance Mode', false, LucideIcons.alertTriangle),
            _buildToggleItem('Auto-publish Episodes', true, LucideIcons.uploadCloud),
          ]),
          const SizedBox(height: 32),
          _buildSettingsSection('Security', [
            _buildSettingsItem('Two-Factor Authentication', 'Disabled', LucideIcons.shieldCheck),
            _buildSettingsItem('Admin Passcode', '••••••', LucideIcons.lock),
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        const SizedBox(height: 16),
        GlassCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(color: Colors.white)),
          const Spacer(),
          Text(value, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(width: 16),
          const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildToggleItem(String label, bool value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(color: Colors.white)),
          const Spacer(),
          Switch(value: value, onChanged: (v) {}, activeColor: AppColors.dramaPink),
        ],
      ),
    );
  }
}

