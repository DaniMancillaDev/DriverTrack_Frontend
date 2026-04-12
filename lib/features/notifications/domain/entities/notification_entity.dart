/// Entidad de dominio para notificaciones.
///
/// Representa una notificación interna de la aplicación
/// con soporte para tipos, estados de lectura y timestamps.

/// Tipos de notificación soportados por el sistema DriverTrack.
/// 
/// Cada tipo tiene una representación visual distinta (colores e iconos) en la UI.
enum NotificationType {
  /// Información general o actualizaciones menores.
  info,
  /// Advertencias que requieren atención del usuario.
  warning,
  /// Avisos de éxito (ej. mantenimiento registrado exitosamente).
  success,
  /// Errores críticos o fallos en procesos.
  error,
  /// Alertas meteorológicas específicas.
  weather;

  /// Traduce el campo 'type' proveniente del servidor al enum [NotificationType].
  /// Si el tipo es desconocido, por defecto retorna [info].
  static NotificationType fromString(String value) {
    return NotificationType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => NotificationType.info,
    );
  }
}

/// Entidad inmutable que representa una notificación individual.
/// 
/// Centraliza los datos de las alertas enviadas por el sistema de mantenimiento
/// o el servicio de clima.
class NotificationEntity {
  /// Identificador único de la notificación.
  final int id;

  /// ID del usuario destinatario.
  final int userId;

  /// Título breve de la notificación.
  final String title;

  /// Cuerpo del mensaje con el detalle del aviso.
  final String message;

  /// Categoría de la notificación para su gestión visual.
  final NotificationType type;

  /// Indica si el usuario ya ha visualizado esta notificación.
  final bool isRead;

  /// Fecha y hora de creación de la alerta.
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
  String toString() =>
      'NotificationEntity(id: $id, title: $title, isRead: $isRead)';
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
