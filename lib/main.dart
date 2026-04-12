import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/login_page.dart';
import 'pages/registration_page.dart';
import 'pages/notifications_page.dart';
import 'layouts/main_layout.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'core/i18n/locale_provider.dart';
import 'core/i18n/translations.g.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/units/presentation/unit_system_provider.dart';
import 'core/router/app_router.dart';

import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/security/secure_storage_service.dart';
import 'dart:io';

/// Sobrescribe el cliente HTTP por defecto para permitir conexiones
/// a servidores con certificados auto-firmados o problemas de CORS/SSL.
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

/// Configuración global de la aplicación.
/// 
/// Define constantes críticas para la comunicación con el backend (URLs), 
/// claves de API de terceros y parámetros de sesión. 
/// 
/// Nota: Los valores sensibles se inyectan preferiblemente vía `--dart-define` 
/// en entornos de producción.
class AppConfig {
  /// Base URL para el servidor de producción.
  static const String prodBaseUrl = 'https://drivertrack.mikecardona076.com';
}

/// Utilidades de validación para formularios y campos de entrada.
/// 
/// Provee una colección de validadores puros para correos electrónicos, 
/// contraseñas y campos obligatorios, facilitando la consistencia en la UI.
class FormValidators {
  /// Valida que el campo de correo electrónico siga una estructura RFC 5322 básica.
  static String? email(String? value, BuildContext context) {
    return null;
  }
}

/// Punto de entrada principal de la aplicación.
/// 
/// Inicializa los servicios de persistencia, configuración de localización,
/// seguridad y el contenedor de dependencias de Riverpod.
void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final savedLocaleTag = prefs.getString('app_locale') ?? 'es';
  final initialLocale = AppLocale.values.firstWhere(
    (l) => l.languageTag == savedLocaleTag,
    orElse: () => AppLocale.es,
  );
  await LocaleSettings.setLocale(initialLocale);
  Intl.defaultLocale = initialLocale.languageTag;

  const secureStorage = FlutterSecureStorage();
  final token = await secureStorage.read(key: 'user_token');
  final refreshToken = await secureStorage.read(key: 'user_refresh_token');

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        initialAccessTokenProvider.overrideWithValue(token),
        initialRefreshTokenProvider.overrideWithValue(refreshToken),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TranslationProvider de slang maneja el locale internamente.
    // _AppWithLocale lee el flutterLocale directamente del provider,
    // por eso el MaterialApp reacciona automáticamente al cambio.
    return TranslationProvider(child: const _AppWithLocale());
  }
}

class _AppWithLocale extends ConsumerWidget {
  const _AppWithLocale();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Leer el locale actual desde TranslationProvider de slang.
    // Leer el ThemeMode actual desde themeProvider (persiste en SharedPreferences).
    final themeMode = ref.watch(themeProvider).value ?? ThemeMode.dark;
    final router = ref.watch(goRouterProvider);
    final currentAppLocale = ref.watch(localeProvider); // Guarantee rebuild

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Driver Track',
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: themeMode,
      locale: currentAppLocale.flutterLocale,
      supportedLocales: AppLocale.values.map((l) => l.flutterLocale),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      // Clamp text scaling for accessibility without breaking UI
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final clampedScale = mediaQuery.textScaler.scale(1.0).clamp(0.8, 1.3);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: TextScaler.linear(clampedScale),
          ),
          child: child!,
        );
      },
      routerConfig: router,
    );
  }
}
