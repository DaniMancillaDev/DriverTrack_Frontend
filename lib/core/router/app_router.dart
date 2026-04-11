import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../pages/login_page.dart';
import '../../pages/registration_page.dart';
import '../../pages/auth/forgot_password_page.dart';
import '../../pages/notifications_page.dart';
import '../../layouts/main_layout.dart';
import '../../providers/auth_provider.dart';

/// Provider que solo emite `true`/`false` según si hay sesión activa.
/// Esto evita que cambios en datos del perfil (nombre, foto)
/// recreen el GoRouter y reseteen la navegación.
final _isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(authProvider);
  return user != null;
});

/// Define the global router relying on the authProvider to redirect users
/// proactively when authentication state changes.
final goRouterProvider = Provider<GoRouter>((ref) {
  final isAuth = ref.watch(_isAuthenticatedProvider);

  return GoRouter(
    initialLocation: '/',
    // Redirect logic: evaluate where to redirect based on auth status
    redirect: (context, state) {
      final isGoingToLogin = state.matchedLocation == '/login';
      final isGoingToRegister = state.matchedLocation == '/registration';
      final isGoingToForgot = state.matchedLocation == '/forgot-password';

      if (!isAuth && !isGoingToLogin && !isGoingToRegister && !isGoingToForgot) {
        return '/login';
      }
      if (isAuth && (isGoingToLogin || isGoingToRegister || isGoingToForgot)) {
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
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
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
