import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'pages/login_page.dart';
import 'pages/registration_page.dart';
import 'pages/notifications_page.dart';
import 'layouts/main_layout.dart';
import 'providers/auth_provider.dart';
import 'core/i18n/locale_provider.dart';
import 'core/i18n/translations.g.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/units/presentation/unit_system_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleProvider.initialize();
  
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authProvider, (previous, next) {
      if (previous != null && next == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigatorKey.currentState?.pushNamedAndRemoveUntil('/', (route) => false);
        });
      }
      if (previous == null && next != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigatorKey.currentState?.pushNamedAndRemoveUntil('/', (route) => false);
        });
      }
    });

    // TranslationProvider de slang maneja el locale internamente.
    // _AppWithLocale lee el flutterLocale directamente del provider, 
    // por eso el MaterialApp reacciona automáticamente al cambio.
    return TranslationProvider(child: const _AppWithLocale());
  }
}

class _AppWithLocale extends StatelessWidget {
  const _AppWithLocale();

  @override
  Widget build(BuildContext context) {
    // Leer el locale actual directamente desde TranslationProvider de slang.
    // Esto se reconstruye automáticamente cuando LocaleSettings.setLocale() es llamado.
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'DriveTrack',
      theme: AppTheme.darkTheme,
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocale.values.map((l) => l.flutterLocale),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      // Clamp text scaling for accessibility without breaking UI
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final clampedScale = mediaQuery.textScaler
            .scale(1.0)
            .clamp(0.8, 1.3);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: TextScaler.linear(clampedScale),
          ),
          child: child!,
        );
      },
      home: const AuthWrapper(),
      routes: {
        '/registration': (context) => const RegistrationPage(),
        '/notifications': (context) => const NotificationsPage(),
      },
    );
  }
}

/// Decide qué mostrar basándose en el estado de autenticación.
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    if (user != null) return const MainLayout();
    return const LoginPage();
  }
}
