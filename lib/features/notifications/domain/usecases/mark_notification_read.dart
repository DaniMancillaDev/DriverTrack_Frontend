/// Caso de uso: Marcar una notificación como leída.

import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class MarkNotificationRead {
  final NotificationRepository repository;

  MarkNotificationRead(this.repository);

  Future<NotificationEntity> call(int notificationId) {
    return repository.markAsRead(notificationId);
  }
}
