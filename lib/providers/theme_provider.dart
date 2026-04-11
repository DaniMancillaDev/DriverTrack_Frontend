import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

/// Notifier encargado de persistir y exponer el modo visual de la aplicación.
/// 
/// Utiliza [SharedPreferences] para recordar la elección del usuario (claro/oscuro)
/// entre sesiones. Por defecto, la aplicación inicia en modo **oscuro**.
/// 
/// El estado se gestiona mediante [AsyncNotifier], permitiendo una carga asíncrona
/// inicial desde el almacenamiento local y actualizaciones reactivas mediante [_save].
class ThemeNotifier extends AsyncNotifier<ThemeMode> {
  static const _key = 'app_theme_mode';

  @override
  Future<ThemeMode> build() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);
    return stored == 'light' ? ThemeMode.light : ThemeMode.dark;
  }

  /// Cambia el tema a modo oscuro y persiste la preferencia.
  Future<void> setDark() => _save(ThemeMode.dark);

  /// Cambia el tema a modo claro y persiste la preferencia.
  Future<void> setLight() => _save(ThemeMode.light);

  /// Alterna entre modo claro y oscuro, guardando el nuevo estado.
  Future<void> toggle() async {
    final current = state.value ?? ThemeMode.dark;
    await _save(current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }

  /// Persiste el [mode] en [SharedPreferences] y actualiza el estado del notifier.
  Future<void> _save(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode == ThemeMode.light ? 'light' : 'dark');
    state = AsyncData(mode);
  }

  /// Retorna un slug de texto representativo del tema actual para uso en APIs o logs.
  String get currentSlug =>
      (state.value ?? ThemeMode.dark) == ThemeMode.dark ? 'dark' : 'light';
}

/// Provider global para el control del tema visual.
/// 
/// Expone [ThemeNotifier] para que la UI pueda observar el [ThemeMode] actual
/// y disparar cambios de tema.
final themeProvider = AsyncNotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);

// ─────────────────────────────────────────────────────────────
// ThemeData — Apuntan a AppTheme para centralizar la definición
// ─────────────────────────────────────────────────────────────

class AppThemes {
  static ThemeData get dark => AppTheme.darkTheme;
  static ThemeData get light => AppTheme.lightTheme;
}
