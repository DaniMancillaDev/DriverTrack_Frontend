/// Data source local para cache de clima.
///
/// Usa SharedPreferences para almacenar el último resultado
/// del clima con un TTL configurable (por defecto 15 min).

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class WeatherLocalDataSource {
  final SharedPreferences _prefs;

  /// Clave de almacenamiento para el cache de clima.
  static const _cacheKey = 'weather_cache';

  /// Clave de almacenamiento para el timestamp del cache.
  static const _cacheTimestampKey = 'weather_cache_ts';

  /// Tiempo de vida del cache.
  static const cacheTtl = Duration(minutes: 15);

  WeatherLocalDataSource(this._prefs);

  /// Obtiene el clima cacheado si existe y no ha expirado.
  ///
  /// Retorna `null` si no hay cache o si expiró.
  WeatherModel? getCachedWeather() {
    final jsonStr = _prefs.getString(_cacheKey);
    if (jsonStr == null) return null;

    try {
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      final model = WeatherModel.fromCacheJson(json);

      if (model.isFresh(ttl: cacheTtl)) {
        return model;
      }

      // Cache expirado pero aún puede servir como fallback
      return model;
    } catch (_) {
      return null;
    }
  }

  /// Indica si el cache actual es fresco (dentro del TTL).
  bool isCacheFresh() {
    final tsStr = _prefs.getString(_cacheTimestampKey);
    if (tsStr == null) return false;

    try {
      final ts = DateTime.parse(tsStr);
      return DateTime.now().difference(ts) < cacheTtl;
    } catch (_) {
      return false;
    }
  }

  /// Almacena el clima en el cache local.
  Future<void> cacheWeather(WeatherModel weather) async {
    final jsonStr = jsonEncode(weather.toJson());
    await _prefs.setString(_cacheKey, jsonStr);
    await _prefs.setString(
      _cacheTimestampKey,
      DateTime.now().toIso8601String(),
    );
  }

  /// Limpia el cache de clima.
  Future<void> clearCache() async {
    await _prefs.remove(_cacheKey);
    await _prefs.remove(_cacheTimestampKey);
  }
}
