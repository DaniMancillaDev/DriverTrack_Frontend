// lib/core/i18n/locale_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'translations.g.dart';

/// Gestiona el idioma activo de la app.
/// Persiste la preferencia del usuario en SharedPreferences
/// y delega el cambio de locale a slang (LocaleSettings).
class LocaleProvider extends ChangeNotifier {
  LocaleProvider._();
  static final instance = LocaleProvider._();

  static const _kLocaleKey = 'app_locale';

  AppLocale _locale = AppLocale.es;
  Locale get currentLocale => _locale.flutterLocale;
  AppLocale get currentAppLocale => _locale;

  /// Llama en main() antes de runApp().
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kLocaleKey);
    if (saved != null) {
      final locale = AppLocale.values.firstWhere(
        (l) => l.languageTag == saved,
        orElse: () => AppLocale.es,
      );
      instance._locale = locale;
    }
    // Sync porque lazy: false (no hay deferred loading).
    LocaleSettings.setLocaleSync(instance._locale);
  }

  /// Cambia el idioma y persiste la preferencia del usuario.
  /// Usa setLocaleSync para que el TranslationProvider se
  /// reconstruya inmediatamente en el mismo frame.
  void setLocale(AppLocale locale) {
    if (_locale == locale) return;
    _locale = locale;

    debugPrint('[i18n] Changing locale to: ${locale.languageTag}');

    // setLocaleSync actualiza slang y notifica al TranslationProvider
    // en el mismo frame, sin esperar un Future.
    LocaleSettings.setLocaleSync(locale);

    debugPrint('[i18n] LocaleSettings updated, current: ${LocaleSettings.currentLocale.languageTag}');

    // Persistir preferencia (fire-and-forget)
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(_kLocaleKey, locale.languageTag);
    });

    notifyListeners();
  }

  /// Convierte un tag de string (ej: 'en', 'es') al AppLocale correspondiente.
  static AppLocale? fromTag(String tag) {
    final lower = tag.toLowerCase();
    try {
      return AppLocale.values.firstWhere((l) => l.languageTag == lower);
    } catch (_) {
      return null;
    }
  }
}
