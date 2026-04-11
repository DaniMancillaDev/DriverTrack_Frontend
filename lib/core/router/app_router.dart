import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../pages/login_page.dart';
import '../../pages/registration_page.dart';
import '../../pages/auth/forgot_password_page.dart';
import '../../pages/notifications_page.dart';
import '../../layouts/main_layout.dart';
import '../../providers/auth_provider.dart';

/// Provider que emite el estado binario de autenticación.
/// 
/// Se separa de [authProvider] para evitar que actualizaciones parciales del 
/// perfil de usuario (como el cambio de foto) provoquen un reinicio del 
/// [GoRouter] y la pérdida de la pila de navegación actual.
final _isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(authProvider);
  return user != null;
});

/// Orquestador de navegación basado en [GoRouter].
/// 
/// Gestiona la jerarquía de rutas de la aplicación y las reglas de acceso:
/// * **Redirección Proactiva**: Envía al usuario al login si se detecta pérdida de sesión.
/// * **Protección de Auth**: Evita que usuarios ya logueados accedan de nuevo a Login/Registro.
/// * **Navegación Anidada**: Permite sub-rutas dentro del layout principal.
final goRouterProvider = Provider<GoRouter>((ref) {
  final isAuth = ref.watch(_isAuthenticatedProvider);

  return GoRouter(
    initialLocation: '/',
    // Lógica de redirección centralizada
    redirect: (context, state) {
      final isGoingToLogin = state.matchedLocation == '/login';
      final isGoingToRegister = state.matchedLocation == '/registration';
      final isGoingToForgot = state.matchedLocation == '/forgot-password';

      // Si no está autenticado y no va a una ruta pública, forzar login
      if (!isAuth && !isGoingToLogin && !isGoingToRegister && !isGoingToForgot) {
        return '/login';
      }
      
      // Si ya está autenticado e intenta ir a auth pages, redirigir al inicio
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
          // Rutas hijas que comparten el layout principal (BottomNav)
          GoRoute(
            path: 'notifications',
            builder: (context, state) => const NotificationsPage(),
          ),
        ],
      ),
    ],
  );
});
