import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dramaflix_shared/dramaflix_shared.dart';
import '../../../core/constants/app_icons.dart';
import '../../../providers/main_provider.dart';

import 'home/home.dart';
import 'search/explore_screen.dart';
import 'feed/feed_screen.dart';
import 'profile/profile_screen.dart';

class Navigation extends ConsumerWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);

    final List<Widget> screens = [
      const HomeScreen(),
      FeedScreen(isTabActive: selectedIndex == 1),
      const ExploreScreen(),
      const ProfileScreen(),
    ];

    final List<_NavItem> navItems = [
      _NavItem(
        label: "Home",
        unselected: AppIcons.homeUnselected,
        selected: AppIcons.homeSelected,
      ),
      _NavItem(
        label: "Feed",
        unselected: AppIcons
            .playUnSelected, // Using history icon as placeholder for Feed
        selected: AppIcons.playSelected,
      ),
      _NavItem(
        label: "Explore",
        unselected: AppIcons.searchUnselected,
        selected: AppIcons.searchSelected,
      ),
      _NavItem(
        label: "Profile",
        unselected: AppIcons.profileUnselected,
        selected: AppIcons.profileSelected,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: selectedIndex, children: screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border(
            top: BorderSide(
              color: AppColors.textSecondary.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) {
              ref.read(navigationIndexProvider.notifier).state = index;
            },
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: AppColors.background,
            selectedItemColor: const Color(0xFFE93B6F),
            unselectedItemColor: const Color(0xFFA0A0A5),
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 10),
            items: navItems.map((item) {
              return BottomNavigationBarItem(
                icon: NavIcon(
                  asset: item.unselected,
                  color: const Color(0xFFA0A0A5),
                ),
                activeIcon: NavIcon(
                  asset: item.selected,
                  color: const Color(0xFFE93B6F),
                ),
                label: item.label,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class NavIcon extends StatelessWidget {
  final String asset;
  final Color color;

  const NavIcon({super.key, required this.asset, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: SvgPicture.asset(
        asset,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String unselected;
  final String selected;

  _NavItem({
    required this.label,
    required this.unselected,
    required this.selected,
  });
}
