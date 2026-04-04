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
import 'core/units/presentation/unit_system_provider.dart';
import 'core/units/presentation/unit_system_provider.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleProvider.initialize();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
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

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'DriveTrack',
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: themeMode,
      locale: TranslationProvider.of(context).flutterLocale,
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
