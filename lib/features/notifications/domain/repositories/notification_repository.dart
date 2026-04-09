/// Interfaz abstracta del repositorio de notificaciones.
///
/// Define el contrato que cualquier implementación debe cumplir,
/// desacoplando el dominio de la capa de datos.

import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  /// Obtiene la lista paginada de notificaciones del usuario autenticado.
  /// El usuario se identifica por el JWT — no requiere userId explícito.
  Future<PaginatedNotifications> getNotifications({
    int skip = 0,
    int limit = 20,
  });

  /// Marca una notificación específica como leída.
  Future<NotificationEntity> markAsRead(int notificationId);

  /// Marca todas las notificaciones del usuario autenticado como leídas.
  Future<void> markAllAsRead();

  /// Obtiene el conteo de notificaciones no leídas del usuario autenticado.
  Future<int> getUnreadCount();

  /// Elimina una notificación.
  Future<void> deleteNotification(int notificationId);
}
