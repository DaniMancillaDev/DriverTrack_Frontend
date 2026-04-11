import 'package:flutter/material.dart';
import '../widgets/ui/custom_bottom_nav.dart';
import '../pages/garage_page.dart';

import '../pages/maintenance_page.dart';
import '../pages/service_map_page.dart';
import '../pages/profile_page.dart';
import '../core/responsive/responsive.dart';
import '../theme/app_theme.dart';

/// Orquestador principal de la interfaz de usuario.
/// 
/// Gestiona la estructura base de la aplicación, incluyendo:
/// * **Navegación**: Switch persistente entre Garage, Historial, Mapa y Perfil.
/// * **Persistencia de Estado**: Utiliza [IndexedStack] para mantener el estado 
///   de las páginas sin recargas innecesarias al navegar.
/// * **Layout Responsivo**: Se adapta a márgenes y áreas seguras globales.
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
