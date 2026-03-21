import 'package:flutter/material.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/topbar.dart';
import '../dashboard/dashboard_screen.dart';
import '../dramas/dramas_screen.dart';
import '../episodes/episodes_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<String> _titles = ['Dashboard', 'Dramas', 'Episodes'];

  final List<Widget> _screens = [
    const DashboardScreen(),
    const DramasScreen(),
    const EpisodesScreen(),
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
            child: Column(
              children: [
                TopBar(title: _titles[_selectedIndex]),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _screens[_selectedIndex],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
