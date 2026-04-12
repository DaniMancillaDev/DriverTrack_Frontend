import 'dart:async';
import '../../../../core/network/api_client.dart';
import '../models/notification_model.dart';

/// Fuente de datos remota para la gestión de notificaciones mediante API REST.
///
/// Provee métodos para listar, marcar como leídas y eliminar notificaciones,
/// implementando una lógica robusta de reintentos automáticos para mitigar 
/// fallos temporales de red.
class NotificationRemoteDataSource {
  final ApiClient _apiClient;

  /// Máximo número de reintentos automáticos para peticiones fallidas.
  static const int _maxRetries = 3;

  /// Retraso base inicial para el algoritmo de retroceso exponencial (ms).
  static const int _baseDelayMs = 500;

  NotificationRemoteDataSource(this._apiClient);

  /// Obtiene la lista paginada de notificaciones del usuario autenticado.
  ///
  /// El backend filtra automáticamente por el usuario extraído del JWT Bearer token.
  /// [skip] define cuántos elementos omitir y [limit] el tamaño de la página.
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

  /// Marca una notificación específica como leída en el servidor.
  Future<NotificationModel> markAsRead(int notificationId) async {
    return _withRetry(() async {
      final response = await _apiClient.patch(
        '/notifications/$notificationId/read',
        {},
      );
      return NotificationModel.fromJson(response as Map<String, dynamic>);
    });
  }

  /// Envía una señal al backend para marcar todas las notificaciones del usuario como leídas.
  Future<void> markAllAsRead() async {
    return _withRetry(() async {
      await _apiClient.patch('/notifications/read-all', {});
    });
  }

  /// Recupera el número total de notificaciones no leídas pendientes por el usuario.
  Future<int> getUnreadCount() async {
    return _withRetry(() async {
      final response = await _apiClient.get('/notifications/unread-count');
      return (response as Map<String, dynamic>)['unread_count'] as int;
    });
  }

  /// Elimina permanentemente una notificación del historial.
  Future<void> deleteNotification(int notificationId) async {
    return _withRetry(() async {
      await _apiClient.delete('/notifications/$notificationId');
    });
  }

  /// Envoltura lógica que añade resilencia a las operaciones de red.
  /// 
  /// Implementa **Backoff Exponencial**:
  /// El tiempo de espera entre intentos crece en potencia de 2 (0.5s, 1s, 2s).
  /// Excluye errores de la serie 4xx del proceso de reintento.
  Future<T> _withRetry<T>(Future<T> Function() operation) async {
    int attempt = 0;
    while (true) {
      try {
        return await operation();
      } catch (e) {
        attempt++;
        if (attempt >= _maxRetries) rethrow;

        // No reintentar ante errores de autorregulación del cliente (4xx)
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
