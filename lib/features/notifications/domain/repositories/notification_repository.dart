/// Interfaz abstracta del repositorio de notificaciones.
///
/// Define el contrato que cualquier implementación debe cumplir,
/// desacoplando el dominio de la capa de datos.

import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  /// Obtiene la lista paginada de notificaciones de un usuario.
  Future<PaginatedNotifications> getNotifications({
    required int userId,
    int skip = 0,
    int limit = 20,
  });

  /// Marca una notificación específica como leída.
  Future<NotificationEntity> markAsRead(int notificationId);

  /// Marca todas las notificaciones de un usuario como leídas.
  Future<void> markAllAsRead(int userId);

  /// Obtiene el conteo de notificaciones no leídas.
  Future<int> getUnreadCount(int userId);

  /// Elimina una notificación.
  Future<void> deleteNotification(int notificationId);
}
