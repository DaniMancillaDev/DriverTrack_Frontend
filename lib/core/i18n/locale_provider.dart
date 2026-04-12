// lib/core/i18n/locale_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'translations.g.dart';

final localeProvider = NotifierProvider<LocaleNotifier, AppLocale>(() {
  return LocaleNotifier();
});

class LocaleNotifier extends Notifier<AppLocale> {
  static const _kLocaleKey = 'app_locale';

  @override
  AppLocale build() {
    // Initial sync is done in main.dart
    // Just return the already synchronized Slang current Locale
    return LocaleSettings.currentLocale;
  }

  Future<void> setLocale(AppLocale locale) async {
    if (state == locale) return;

    debugPrint('[i18n] Changing locale to: ${locale.languageTag}');
    await LocaleSettings.setLocale(locale);
    
    state = locale;
    Intl.defaultLocale = locale.languageTag;

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(_kLocaleKey, locale.languageTag);
    });
  }

  static AppLocale? fromTag(String tag) {
    final lower = tag.toLowerCase();
    try {
      return AppLocale.values.firstWhere((l) => l.languageTag == lower);
    } catch (_) {
      return null;
    }
  }
}
