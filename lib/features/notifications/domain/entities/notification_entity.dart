/// Entidad de dominio para notificaciones.
///
/// Representa una notificación interna de la aplicación
/// con soporte para tipos, estados de lectura y timestamps.

/// Tipos de notificación soportados por el sistema.
enum NotificationType {
  info,
  warning,
  success,
  error,
  weather;

  /// Convierte un string del backend al enum.
  static NotificationType fromString(String value) {
    return NotificationType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => NotificationType.info,
    );
  }
}

/// Entidad inmutable que representa una notificación.
class NotificationEntity {
  final int id;
  final int userId;
  final String title;
  final String message;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  /// Crea una copia con campos opcionales modificados.
  NotificationEntity copyWith({
    int? id,
    int? userId,
    String? title,
    String? message,
    NotificationType? type,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'NotificationEntity(id: $id, title: $title, isRead: $isRead)';
}

/// Respuesta paginada de notificaciones.
class PaginatedNotifications {
  final List<NotificationEntity> items;
  final int total;
  final bool hasMore;
  final int unreadCount;

  const PaginatedNotifications({
    required this.items,
    required this.total,
    required this.hasMore,
    required this.unreadCount,
  });
}
