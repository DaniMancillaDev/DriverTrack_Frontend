/// Caso de uso: Obtener notificaciones paginadas.

import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotifications {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  Future<PaginatedNotifications> call({
    int skip = 0,
    int limit = 20,
  }) {
    return repository.getNotifications(
      skip: skip,
      limit: limit,
    );
  }
}
