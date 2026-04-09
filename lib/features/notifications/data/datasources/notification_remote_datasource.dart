/// Datasource remoto para notificaciones.
///
/// Usa el ApiClient existente para realizar todas las llamadas
/// REST al backend con retry automático y manejo de errores.
///
/// NOTA: user_id ya no se pasa como query param — el backend
/// lo extrae automáticamente del JWT Bearer token.

import 'dart:async';
import '../../../../services/api_client.dart';
import '../models/notification_model.dart';

class NotificationRemoteDataSource {
  final ApiClient _apiClient;

  /// Máximo número de reintentos automáticos.
  static const int _maxRetries = 3;

  /// Delay base para backoff exponencial (ms).
  static const int _baseDelayMs = 500;

  NotificationRemoteDataSource(this._apiClient);

  /// Obtiene la lista paginada de notificaciones del usuario autenticado.
  ///
  /// El backend filtra automáticamente por el usuario del JWT.
  Future<PaginatedNotificationsModel> getNotifications({
    int skip = 0,
    int limit = 20,
  }) async {
    return _withRetry(() async {
      final response = await _apiClient.get(
        '/notifications?skip=$skip&limit=$limit',
      );
      return PaginatedNotificationsModel.fromJson(
        response as Map<String, dynamic>,
      );
    });
  }

  /// Marca una notificación como leída.
  Future<NotificationModel> markAsRead(int notificationId) async {
    return _withRetry(() async {
      final response = await _apiClient.patch(
        '/notifications/$notificationId/read',
        {},
      );
      return NotificationModel.fromJson(response as Map<String, dynamic>);
    });
  }

  /// Marca todas las notificaciones del usuario autenticado como leídas.
  ///
  /// El backend identifica el usuario a través del JWT.
  Future<void> markAllAsRead() async {
    return _withRetry(() async {
      await _apiClient.patch('/notifications/read-all', {});
    });
  }

  /// Obtiene el conteo de notificaciones no leídas del usuario autenticado.
  Future<int> getUnreadCount() async {
    return _withRetry(() async {
      final response = await _apiClient.get('/notifications/unread-count');
      return (response as Map<String, dynamic>)['unread_count'] as int;
    });
  }

  /// Elimina una notificación.
  Future<void> deleteNotification(int notificationId) async {
    return _withRetry(() async {
      await _apiClient.delete('/notifications/$notificationId');
    });
  }

  /// Ejecuta una operación con retry automático y backoff exponencial.
  Future<T> _withRetry<T>(Future<T> Function() operation) async {
    int attempt = 0;
    while (true) {
      try {
        return await operation();
      } catch (e) {
        attempt++;
        if (attempt >= _maxRetries) rethrow;

        // No retry para errores 4xx (errores del cliente)
        if (e is ApiException && e.statusCode >= 400 && e.statusCode < 500) {
          rethrow;
        }

        final delay = Duration(
          milliseconds: _baseDelayMs * (1 << (attempt - 1)),
        );
        await Future.delayed(delay);
      }
    }
  }
}
