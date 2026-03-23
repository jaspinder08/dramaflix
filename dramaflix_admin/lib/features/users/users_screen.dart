import 'package:flutter/material.dart';
import 'package:dramaflix_shared/dramaflix_shared.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../widgets/glass_card.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  bool _showDetails = false;
  Map<String, dynamic>? _selectedUser;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: _showDetails ? _buildUserDetail() : _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(child: _buildDataTable()),
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
                'User Management',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 4),
              Text(
                'Total 245,102 registered users',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
          const Spacer(),
          _buildSearchField(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
      width: 300,
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search by name or email...',
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          prefixIcon: const Icon(LucideIcons.search, color: AppColors.textSecondary, size: 18),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildDataTable() {
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
                  itemCount: 15,
                  separatorBuilder: (context, index) => Divider(color: Colors.white.withOpacity(0.05), height: 1),
                  itemBuilder: (context, index) {
                    final user = {
                      'name': 'User ${index + 1}',
                      'email': 'user${index + 1}@example.com',
                      'watchTime': '${index * 2 + 10}h 15m',
                      'likes': '${index * 5 + 12}',
                      'joined': 'Jan 12, 2024',
                    };
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _buildUserRow(user),
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
      child: const Row(
        children: [
          Expanded(flex: 3, child: Text('User', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12))),
          Expanded(flex: 2, child: Text('Watch Time', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12))),
          Expanded(flex: 2, child: Text('Liked Feed Videos', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12))),
          Expanded(flex: 2, child: Text('Member Since', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12))),
          Expanded(flex: 1, child: Text('Action', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildUserRow(Map<String, dynamic> user) {
    return InkWell(
      onTap: () => setState(() {
        _selectedUser = user;
        _showDetails = true;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.dramaPink.withOpacity(0.1),
                    child: Text(user['name'][0], style: const TextStyle(color: AppColors.dramaPink)),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text(user['email'], style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(flex: 2, child: Text(user['watchTime'], style: const TextStyle(color: Colors.white))),
            Expanded(flex: 2, child: Text(user['likes'], style: const TextStyle(color: Colors.white))),
            Expanded(flex: 2, child: Text(user['joined'], style: const TextStyle(color: Colors.white))),
            const Expanded(
              flex: 1,
              child: Icon(LucideIcons.chevronRight, size: 18, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetail() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: () => setState(() => _showDetails = false),
            icon: const Icon(LucideIcons.arrowLeft, size: 18),
            label: const Text('Back to Users'),
            style: TextButton.styleFrom(foregroundColor: AppColors.dramaPink),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildUserProfileCard()),
              const SizedBox(width: 32),
              Expanded(flex: 2, child: _buildWatchHistory()),
            ],
          ),
          const SizedBox(height: 32),
          _buildLikedDramas(),
        ],
      ),
    );
  }

  Widget _buildUserProfileCard() {
    return GlassCard(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.dramaPink.withOpacity(0.1),
            child: Text(_selectedUser?['name'][0] ?? 'U', style: const TextStyle(fontSize: 32, color: AppColors.dramaPink)),
          ),
          const SizedBox(height: 24),
          Text(_selectedUser?['name'] ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(_selectedUser?['email'] ?? '', style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 32),
          const Divider(color: Colors.white10),
          const SizedBox(height: 24),
          _buildProfileStat('Account Status', 'Active', Colors.green),
          _buildProfileStat('Last Active', '2 hours ago', Colors.white),
          _buildProfileStat('Total Spend', '\$42.50', Colors.white),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildWatchHistory() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Watch History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 24),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(color: AppColors.dramaPink, borderRadius: BorderRadius.circular(2)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Silent Echoes - Episode 4', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        Text('Watched 24 mins • Today, 2:45 PM', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ),
                  const Icon(LucideIcons.play, size: 14, color: AppColors.textSecondary),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLikedDramas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Liked Feed Videos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      child: Image.network('https://picsum.photos/seed/${index + 50}/200/300', fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Drama ${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

