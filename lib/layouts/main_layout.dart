import 'package:flutter/material.dart';
import '../widgets/ui/custom_bottom_nav.dart';
import '../pages/garage_page.dart';

import '../pages/maintenance_page.dart';
import '../pages/service_map_page.dart';
import '../pages/profile_page.dart';
import '../core/responsive/responsive.dart';
import '../theme/app_theme.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const GaragePage(),
    const MaintenancePage(),
    const ServiceMapPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
