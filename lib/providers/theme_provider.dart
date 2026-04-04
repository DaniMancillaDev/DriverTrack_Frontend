import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────
// Notifier — Persiste y expone el ThemeMode actual
// ─────────────────────────────────────────────────────────────

class ThemeNotifier extends AsyncNotifier<ThemeMode> {
  static const _key = 'app_theme_mode';

  @override
  Future<ThemeMode> build() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);
    return stored == 'light' ? ThemeMode.light : ThemeMode.dark;
  }

  Future<void> setDark() => _save(ThemeMode.dark);
  Future<void> setLight() => _save(ThemeMode.light);

  Future<void> toggle() async {
    final current = state.value ?? ThemeMode.dark;
    await _save(current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }

  Future<void> _save(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode == ThemeMode.light ? 'light' : 'dark');
    state = AsyncData(mode);
  }

  String get currentSlug =>
      (state.value ?? ThemeMode.dark) == ThemeMode.dark ? 'dark' : 'light';
}

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
