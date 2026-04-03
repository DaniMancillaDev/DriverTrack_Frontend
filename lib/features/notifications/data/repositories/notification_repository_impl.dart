/// Implementación concreta del repositorio de notificaciones.
///
/// Orquesta remote + local datasources con estrategia
/// cache-first y refresh en background.

import 'dart:async';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_local_datasource.dart';
import '../datasources/notification_remote_datasource.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;
  final NotificationLocalDataSource _localDataSource;

  NotificationRepositoryImpl({
    required NotificationRemoteDataSource remoteDataSource,
    required NotificationLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<PaginatedNotifications> getNotifications({
    required int userId,
    int skip = 0,
    int limit = 20,
  }) async {
    try {
      // Intentar obtener del servidor
      final response = await _remoteDataSource.getNotifications(
        userId: userId,
        skip: skip,
        limit: limit,
      );

      // Cachear la primera página para soporte offline
      if (skip == 0) {
        await _localDataSource.cacheNotifications(response.items);
      }

      return response.toDomain();
    } catch (e) {
      // Si falla la red y tenemos caché, usar caché (solo primera página)
      if (skip == 0) {
        final cached = _localDataSource.getCachedNotifications();
        if (cached != null) {
          return PaginatedNotifications(
            items: cached,
            total: cached.length,
            hasMore: false,
            unreadCount: cached.where((n) => !n.isRead).length,
          );
        }
      }
      rethrow;
    }
  }

  @override
  Future<NotificationEntity> markAsRead(int notificationId) async {
    final result = await _remoteDataSource.markAsRead(notificationId);

    // Actualizar caché local
    _updateCachedNotification(result);

    return result;
  }

  @override
  Future<void> markAllAsRead(int userId) async {
    await _remoteDataSource.markAllAsRead(userId);

    // Marcar todas como leídas en el caché
    final cached = _localDataSource.getCachedNotifications();
    if (cached != null) {
      final updated = cached
          .map((n) => NotificationModel(
                id: n.id,
                userId: n.userId,
                title: n.title,
                message: n.message,
                type: n.type,
                isRead: true,
                createdAt: n.createdAt,
              ))
          .toList();
      await _localDataSource.cacheNotifications(updated);
    }
  }

  @override
  Future<int> getUnreadCount(int userId) async {
    try {
      return await _remoteDataSource.getUnreadCount(userId);
    } catch (_) {
      // Fallback al caché local
      final cached = _localDataSource.getCachedNotifications();
      if (cached != null) {
        return cached.where((n) => !n.isRead).length;
      }
      return 0;
    }
  }

  @override
  Future<void> deleteNotification(int notificationId) async {
    await _remoteDataSource.deleteNotification(notificationId);

    // Eliminar del caché
    final cached = _localDataSource.getCachedNotifications();
    if (cached != null) {
      final updated = cached.where((n) => n.id != notificationId).toList();
      await _localDataSource.cacheNotifications(updated);
    }
  }

  /// Actualiza una notificación específica en el caché.
  void _updateCachedNotification(NotificationModel updated) {
    final cached = _localDataSource.getCachedNotifications();
    if (cached != null) {
      final idx = cached.indexWhere((n) => n.id == updated.id);
      if (idx != -1) {
        cached[idx] = updated;
        _localDataSource.cacheNotifications(cached);
      }
    }
  }
}
