/// Providers para el sistema de notificaciones.
///
/// Usa AsyncNotifier de Riverpod para manejar estados de
/// carga, error y datos con soporte para paginación,
/// WebSocket y operaciones de lectura.

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/app_config.dart';
import '../../../../core/units/presentation/unit_system_provider.dart'
    show sharedPreferencesProvider;
import '../../../../providers/app_providers.dart';
import '../../../../providers/auth_provider.dart';
import '../../data/datasources/notification_local_datasource.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../data/datasources/notification_ws_datasource.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';

// ─── Dependency Providers ────────────────────────────────────

final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      return NotificationRemoteDataSource(apiClient);
    });

final notificationLocalDataSourceProvider =
    Provider<NotificationLocalDataSource>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return NotificationLocalDataSource(prefs);
    });

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(
    remoteDataSource: ref.watch(notificationRemoteDataSourceProvider),
    localDataSource: ref.watch(notificationLocalDataSourceProvider),
  );
});

/// WebSocket provider — se recrea automáticamente cuando cambia authProvider.
///
/// Pasa el JWT como token de autenticación. El servidor valida el token
/// antes de aceptar la conexión WebSocket (código 4001 si es inválido).
final notificationWsProvider = Provider<NotificationWebSocketDataSource?>((
  ref,
) {
  final user = ref.watch(authProvider);

  // Si no hay usuario autenticado o no tiene token, no conectar
  if (user == null || user.token == null || user.token!.isEmpty) return null;

  final config = ref.watch(appConfigProvider);
  final ws = NotificationWebSocketDataSource(
    baseUrl: config.baseUrl,
    token: user.token!,   // ← JWT para auth, no userId
  );
  ws.connect();

  ref.onDispose(() {
    ws.dispose();
  });

  return ws;
});

// ─── State Class ─────────────────────────────────────────────

/// Estado del sistema de notificaciones.
class NotificationsState {
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final int totalCount;
  final bool hasMore;
  final bool isLoadingMore;

  const NotificationsState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.totalCount = 0,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  NotificationsState copyWith({
    List<NotificationEntity>? notifications,
    int? unreadCount,
    int? totalCount,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

// ─── Main Notifier ───────────────────────────────────────────

/// Tamaño de página para paginación.
const int _pageSize = 20;

/// Polling interval como fallback del WebSocket (30 segundos).
const Duration _pollingInterval = Duration(seconds: 30);

class NotificationsNotifier extends AsyncNotifier<NotificationsState> {
  StreamSubscription? _wsSubscription;
  Timer? _pollingTimer;

  @override
  Future<NotificationsState> build() async {
    // ref.watch() aquí hace que build() se re-ejecute cuando
    // authProvider cambia (null → user, user → null).
    final user = ref.watch(authProvider);

    ref.onDispose(() {
      _wsSubscription?.cancel();
      _pollingTimer?.cancel();
    });

    if (user == null) {
      return const NotificationsState();
    }

    // Configurar escucha WebSocket para tiempo real
    _listenToWebSocket();

    // Configurar polling como fallback
    _startPolling();

    // Fetch inicial
    return _fetchPage(skip: 0);
  }

  /// Obtiene el user_id del usuario autenticado.
  int? get _userId => ref.read(authProvider)?.id;

  /// Obtiene una página de notificaciones del servidor.
  Future<NotificationsState> _fetchPage({int skip = 0}) async {
    final repo = ref.read(notificationRepositoryProvider);
    final result = await repo.getNotifications(
      skip: skip,
      limit: _pageSize,
    );

    return NotificationsState(
      notifications: result.items,
      unreadCount: result.unreadCount,
      totalCount: result.total,
      hasMore: result.hasMore,
    );
  }

  /// Escucha el WebSocket para nuevas notificaciones en tiempo real.
  void _listenToWebSocket() {
    _wsSubscription?.cancel();

    final ws = ref.read(notificationWsProvider);
    if (ws == null) return;

    _wsSubscription = ws.notificationStream.listen((notification) {
      final currentState = state.value;
      if (currentState == null) return;

      // Agregar la notificación al inicio de la lista
      state = AsyncData(
        currentState.copyWith(
          notifications: [notification, ...currentState.notifications],
          unreadCount: currentState.unreadCount + 1,
          totalCount: currentState.totalCount + 1,
        ),
      );
    });
  }

  /// Polling como fallback: refresca el conteo de no leídas periódicamente.
  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(_pollingInterval, (_) async {
      try {
        final repo = ref.read(notificationRepositoryProvider);
        final serverCount = await repo.getUnreadCount();
        final currentState = state.value;
        if (currentState != null && serverCount != currentState.unreadCount) {
          // El conteo cambió => refrescar toda la lista
          final freshState = await _fetchPage(skip: 0);
          state = AsyncData(freshState);
        }
      } catch (_) {
        // Polling silencioso — no interrumpir la UI por un fallo de red
      }
    });
  }

  /// Carga más notificaciones (infinite scroll).
  Future<void> fetchMore() async {
    final currentState = state.value;
    if (currentState == null ||
        !currentState.hasMore ||
        currentState.isLoadingMore) {
      return;
    }

    // Marcar como cargando más
    state = AsyncData(currentState.copyWith(isLoadingMore: true));

    try {
      final repo = ref.read(notificationRepositoryProvider);
      final result = await repo.getNotifications(
        skip: currentState.notifications.length,
        limit: _pageSize,
      );

      state = AsyncData(
        currentState.copyWith(
          notifications: [...currentState.notifications, ...result.items],
          hasMore: result.hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      state = AsyncData(currentState.copyWith(isLoadingMore: false));
    }
  }

  /// Marca una notificación como leída.
  Future<void> markAsRead(int notificationId) async {
    final currentState = state.value;
    if (currentState == null) return;

    // Optimistic update
    final updatedList = currentState.notifications.map((n) {
      if (n.id == notificationId && !n.isRead) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();

    final wasUnread = currentState.notifications.any(
      (n) => n.id == notificationId && !n.isRead,
    );

    state = AsyncData(
      currentState.copyWith(
        notifications: updatedList,
        unreadCount: wasUnread
            ? (currentState.unreadCount - 1).clamp(0, currentState.totalCount)
            : currentState.unreadCount,
      ),
    );

    try {
      final repo = ref.read(notificationRepositoryProvider);
      await repo.markAsRead(notificationId);
    } catch (e) {
      // Rollback en caso de error
      state = AsyncData(currentState);
    }
  }

  /// Marca todas las notificaciones como leídas.
  Future<void> markAllAsRead() async {
    final currentState = state.value;
    if (currentState == null) return;

    // Optimistic update
    final updatedList = currentState.notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();

    state = AsyncData(
      currentState.copyWith(notifications: updatedList, unreadCount: 0),
    );

    try {
      final repo = ref.read(notificationRepositoryProvider);
      await repo.markAllAsRead();
    } catch (e) {
      state = AsyncData(currentState);
    }
  }

  /// Refresca la lista completa.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPage(skip: 0));
  }

  /// Elimina una notificación.
  Future<void> deleteNotification(int notificationId) async {
    final currentState = state.value;
    if (currentState == null) return;

    final removedNotification = currentState.notifications
        .where((n) => n.id == notificationId)
        .firstOrNull;

    // Optimistic update
    state = AsyncData(
      currentState.copyWith(
        notifications: currentState.notifications
            .where((n) => n.id != notificationId)
            .toList(),
        totalCount: currentState.totalCount - 1,
        unreadCount:
            (removedNotification != null && !removedNotification.isRead)
            ? (currentState.unreadCount - 1).clamp(0, currentState.totalCount)
            : currentState.unreadCount,
      ),
    );

    try {
      final repo = ref.read(notificationRepositoryProvider);
      await repo.deleteNotification(notificationId);
    } catch (e) {
      state = AsyncData(currentState);
    }
  }
}

// ─── Provider Declarations ──────────────────────────────────

final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, NotificationsState>(
      () => NotificationsNotifier(),
    );

/// Provider derivado para el badge de no leídas.
final unreadCountProvider = Provider<int>((ref) {
  final notificationsState = ref.watch(notificationsProvider);
  return notificationsState.value?.unreadCount ?? 0;
});
