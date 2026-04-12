/// Data source local para cache de clima.
///
/// Usa SharedPreferences para almacenar el último resultado
/// del clima con un TTL configurable (por defecto 15 min).

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class WeatherLocalDataSource {
  final SharedPreferences _prefs;

  /// Tiempo de vida del cache.
  static const cacheTtl = Duration(minutes: 15);

  WeatherLocalDataSource(this._prefs);

  /// Clave genérica delegada según modo.
  String _getCacheKey(bool isManual) => isManual ? 'weather_cache_manual' : 'weather_cache_gps';
  String _getCacheTimestampKey(bool isManual) => isManual ? 'weather_cache_ts_manual' : 'weather_cache_ts_gps';

  /// Obtiene el clima cacheado si existe y no ha expirado.
  WeatherModel? getCachedWeather({bool isManual = false}) {
    final jsonStr = _prefs.getString(_getCacheKey(isManual));
    if (jsonStr == null) return null;

    try {
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      final model = WeatherModel.fromCacheJson(json);

      if (model.isFresh(ttl: cacheTtl)) return model;

      return model; // Respaldo obsoleto
    } catch (_) {
      return null;
    }
  }

  /// Indica si el cache actual es fresco.
  bool isCacheFresh({bool isManual = false}) {
    final tsStr = _prefs.getString(_getCacheTimestampKey(isManual));
    if (tsStr == null) return false;

    try {
      final ts = DateTime.parse(tsStr);
      return DateTime.now().difference(ts) < cacheTtl;
    } catch (_) {
      return false;
    }
  }

  /// Almacena el clima en el cache local.
  Future<void> cacheWeather(WeatherModel weather, {bool isManual = false}) async {
    final jsonStr = jsonEncode(weather.toJson());
    await _prefs.setString(_getCacheKey(isManual), jsonStr);
    await _prefs.setString(
      _getCacheTimestampKey(isManual),
      DateTime.now().toIso8601String(),
    );
  }

  /// Limpia TODOS los caches
  Future<void> clearCache() async {
    await _prefs.remove(_getCacheKey(false));
    await _prefs.remove(_getCacheTimestampKey(false));
    await _prefs.remove(_getCacheKey(true));
    await _prefs.remove(_getCacheTimestampKey(true));
  }
}
