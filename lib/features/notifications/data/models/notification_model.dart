/// Modelo de datos para notificaciones.
///
/// Extiende la entidad de dominio con serialización JSON
/// para comunicación con la API REST.

import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.message,
    required super.type,
    required super.isRead,
    required super.createdAt,
  });

  /// Crea un modelo desde JSON del backend (snake_case → camelCase).
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      title: json['title'] as String,
      message: json['message'] as String,
      type: NotificationType.fromString(json['type'] as String),
      isRead: json['is_read'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Convierte a JSON para enviar al backend.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'message': message,
      'type': type.name,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Crea un modelo desde una entidad de dominio.
  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      message: entity.message,
      type: entity.type,
      isRead: entity.isRead,
      createdAt: entity.createdAt,
    );
  }
}

/// Modelo de respuesta paginada del backend.
class PaginatedNotificationsModel {
  final List<NotificationModel> items;
  final int total;
  final bool hasMore;
  final int unreadCount;

  const PaginatedNotificationsModel({
    required this.items,
    required this.total,
    required this.hasMore,
    required this.unreadCount,
  });

  factory PaginatedNotificationsModel.fromJson(Map<String, dynamic> json) {
    return PaginatedNotificationsModel(
      items: (json['items'] as List)
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      hasMore: json['has_more'] as bool,
      unreadCount: json['unread_count'] as int,
    );
  }

  /// Convierte a entidad de dominio.
  PaginatedNotifications toDomain() {
    return PaginatedNotifications(
      items: items,
      total: total,
      hasMore: hasMore,
      unreadCount: unreadCount,
    );
  }
}
