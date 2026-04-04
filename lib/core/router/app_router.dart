import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../pages/login_page.dart';
import '../../pages/registration_page.dart';
import '../../pages/notifications_page.dart';
import '../../layouts/main_layout.dart';
import '../../providers/auth_provider.dart';

/// Define the global router relying on the authProvider to redirect users
/// proactively when authentication state changes.
final goRouterProvider = Provider<GoRouter>((ref) {
  final user = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    // Redirect logic: evaluate where to redirect based on auth status
    redirect: (context, state) {
      final isAuth = user != null;
      final isGoingToLogin = state.matchedLocation == '/login';
      final isGoingToRegister = state.matchedLocation == '/registration';

      if (!isAuth && !isGoingToLogin && !isGoingToRegister) {
        return '/login';
      }
      if (isAuth && (isGoingToLogin || isGoingToRegister)) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/registration',
        builder: (context, state) => const RegistrationPage(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const MainLayout(),
        routes: [
          // Nested routes under main authenticated layer
          GoRoute(
            path: 'notifications',
            builder: (context, state) => const NotificationsPage(),
          ),
        ],
      ),
    ],
  );
});
