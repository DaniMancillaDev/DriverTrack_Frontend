/// Datasource local para caché de notificaciones.
///
/// Almacena la última respuesta paginada en SharedPreferences
/// para soporte offline básico.

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';

class NotificationLocalDataSource {
  final SharedPreferences _prefs;

  /// Clave de almacenamiento para las notificaciones cacheadas.
  static const String _cacheKey = 'cached_notifications';

  /// Clave para el timestamp de la última sincronización.
  static const String _timestampKey = 'notifications_cache_timestamp';

  /// Duración máxima de validez del caché (15 minutos).
  static const Duration _cacheDuration = Duration(minutes: 15);

  NotificationLocalDataSource(this._prefs);

  /// Guarda las notificaciones en caché.
  Future<void> cacheNotifications(List<NotificationModel> notifications) async {
    final jsonList = notifications.map((n) => n.toJson()).toList();
    await _prefs.setString(_cacheKey, json.encode(jsonList));
    await _prefs.setInt(_timestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Obtiene las notificaciones cacheadas, o null si no hay caché.
  List<NotificationModel>? getCachedNotifications() {
    final cachedJson = _prefs.getString(_cacheKey);
    if (cachedJson == null) return null;

    try {
      final List<dynamic> jsonList = json.decode(cachedJson);
      return jsonList
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Caché corrupto, limpiarlo
      clearCache();
      return null;
    }
  }

  /// Verifica si el caché aún es válido.
  bool isCacheValid() {
    final timestamp = _prefs.getInt(_timestampKey);
    if (timestamp == null) return false;

    final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now().difference(cachedTime) < _cacheDuration;
  }

  /// Limpia el caché de notificaciones.
  Future<void> clearCache() async {
    await _prefs.remove(_cacheKey);
    await _prefs.remove(_timestampKey);
  }
}
