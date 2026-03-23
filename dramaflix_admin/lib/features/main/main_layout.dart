import 'package:flutter/material.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/topbar.dart';
import '../dashboard/dashboard_screen.dart';
import '../dramas/dramas_screen.dart';
import '../episodes/episodes_screen.dart';
import '../feed/feed_screen.dart';
import '../users/users_screen.dart';
import '../analytics/analytics_screen.dart';
import '../settings/settings_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<String> _titles = [
    'Dashboard',
    'Dramas',
    'Episodes',
    'Feed',
    'Users',
    'Analytics',
    'Settings',
  ];

  final List<Widget> _screens = [
    const DashboardScreen(),
    const DramasScreen(),
    const EpisodesScreen(),
    const FeedScreen(),
    const UsersScreen(),
    const AnalyticsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: Container(
              color: const Color(0xFF0D0D0F),
              child: Column(
                children: [
                  TopBar(title: _titles[_selectedIndex]),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      child: _screens[_selectedIndex],
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
}

