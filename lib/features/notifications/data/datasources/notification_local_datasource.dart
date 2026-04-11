import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';

/// Fuente de datos local para la persistencia de alertas y avisos.
///
/// Almacena las notificaciones en un formato serializado dentro de [SharedPreferences].
/// Permite que la aplicación muestre alertas recientes incluso sin conexión a Internet,
/// mejorando la experiencia de usuario y la resiliencia del sistema.
class NotificationLocalDataSource {
  final SharedPreferences _prefs;

  /// Clave utilizada para guardar el listado de notificaciones en JSON.
  static const String _cacheKey = 'cached_notifications';

  /// Clave para guardar el timestamp (milisegundos) de la última sincronización exitosa.
  static const String _timestampKey = 'notifications_cache_timestamp';

  /// Periodo de validez del caché local antes de considerarse obsoleto.
  static const Duration _cacheDuration = Duration(minutes: 15);

  NotificationLocalDataSource(this._prefs);

  /// Persiste una lista de modelos [NotificationModel] en el almacenamiento local.
  /// 
  /// Sobrescribe cualquier dato previo y actualiza el timestamp de vigencia.
  Future<void> cacheNotifications(List<NotificationModel> notifications) async {
    final jsonList = notifications.map((n) => n.toJson()).toList();
    await _prefs.setString(_cacheKey, json.encode(jsonList));
    await _prefs.setInt(_timestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Recupera las notificaciones almacenadas localmente.
  /// 
  /// Retorna una lista vacía o null si no existe información previa o si
  /// los datos están malformados.
  List<NotificationModel>? getCachedNotifications() {
    final cachedJson = _prefs.getString(_cacheKey);
    if (cachedJson == null) return null;

    try {
      final List<dynamic> jsonList = json.decode(cachedJson);
      return jsonList
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Si el formato del caché es incompatible, se procede a su limpieza manual
      clearCache();
      return null;
    }
  }

  /// Determina si la información en caché aún se encuentra dentro de su ventana de validez ([_cacheDuration]).
  bool isCacheValid() {
    final timestamp = _prefs.getInt(_timestampKey);
    if (timestamp == null) return false;

    final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now().difference(cachedTime) < _cacheDuration;
  }

  /// Elimina los registros locales de notificaciones y su marca de tiempo.
  Future<void> clearCache() async {
    await _prefs.remove(_cacheKey);
    await _prefs.remove(_timestampKey);
  }
}
