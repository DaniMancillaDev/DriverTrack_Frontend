/// Datasource remoto para notificaciones.
///
/// Usa el ApiClient existente para realizar todas las llamadas
/// REST al backend con retry automático y manejo de errores.

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

  /// Obtiene la lista paginada de notificaciones.
  Future<PaginatedNotificationsModel> getNotifications({
    required int userId,
    int skip = 0,
    int limit = 20,
  }) async {
    return _withRetry(() async {
      final response = await _apiClient.get(
        '/notifications?user_id=$userId&skip=$skip&limit=$limit',
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

  /// Marca todas las notificaciones de un usuario como leídas.
  Future<void> markAllAsRead(int userId) async {
    return _withRetry(() async {
      await _apiClient.patch(
        '/notifications/read-all?user_id=$userId',
        {},
      );
    });
  }

  /// Obtiene el conteo de no leídas.
  Future<int> getUnreadCount(int userId) async {
    return _withRetry(() async {
      final response = await _apiClient.get(
        '/notifications/unread-count?user_id=$userId',
      );
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
