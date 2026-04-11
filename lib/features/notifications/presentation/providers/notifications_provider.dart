/// Proveedores y componentes de lógica para el sistema de notificaciones.
///
/// Implementa un flujo de comunicación bidireccional y reactivo utilizando 
/// [AsyncNotifier]. Gestiona la sincronización en tiempo real vía WebSocket, 
/// la paginación de datos históricos y la persistencia de estados de lectura.

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

// ─── Proveedores de Infraestructura ───────────────────────────────

/// Gestiona la comunicación REST para operaciones históricas de notificaciones.
final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      return NotificationRemoteDataSource(apiClient);
    });

/// Orquestador del almacenamiento persistente de estados de notificación locales.
final notificationLocalDataSourceProvider =
    Provider<NotificationLocalDataSource>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return NotificationLocalDataSource(prefs);
    });

/// Implementación del repositorio de notificaciones que cohesiona fuentes locales y remotas.
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(
    remoteDataSource: ref.watch(notificationRemoteDataSourceProvider),
    localDataSource: ref.watch(notificationLocalDataSourceProvider),
  );
});

/// Orquestador de la conexión en tiempo real ([WebSocket]).
/// 
/// Se reinicia automáticamente ante cambios en [authProvider], garantizando 
/// que el canal de comunicación use siempre un token JWT válido.
final notificationWsProvider = Provider<NotificationWebSocketDataSource?>((
  ref,
) {
  final user = ref.watch(authProvider);

  if (user == null || user.token == null || user.token!.isEmpty) return null;

  final config = ref.watch(appConfigProvider);
  final ws = NotificationWebSocketDataSource(
    baseUrl: config.baseUrl,
    token: user.token!,
  );
  ws.connect();

  ref.onDispose(() {
    ws.dispose();
  });

  return ws;
});

// ─── Definición del Estado de la UI ─────────────────────────────

/// Representa el estado consolidado del buzón de notificaciones.
class NotificationsState {
  /// Lista de alertas cargadas actualmente en memoria.
  final List<NotificationEntity> notifications;
  /// Cantidad de alertas sin leer para el badge de navegación.
  final int unreadCount;
  /// Conteo total de alertas disponibles en el servidor.
  final int totalCount;
  /// Indica si existen más páginas de datos para cargar (infinit scroll).
  final bool hasMore;
  /// Estado dinámico de carga para operaciones de paginación.
  final bool isLoadingMore;

  const NotificationsState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.totalCount = 0,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  /// Permite actualizaciones granulares manteniendo la inmutabilidad.
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

// ─── Notificador de Lógica de Presentación ─────────────────────

/// Cantidad de registro solicitados por lote (paginación).
const int _pageSize = 20;

/// Intervalo de seguridad para sincronización pasiva ante fallos del WebSocket.
const Duration _pollingInterval = Duration(seconds: 30);

/// Orquestador central de las alertas del sistema.
/// 
/// Sus responsabilidades incluyen:
/// * **Streaming**: Escucha eventos en tiempo real e inserta alertas instantáneamente.
/// * **Ciclo de Vida**: Gestiona la transición entre estados de autenticación.
/// * **Paginación**: Coordina la carga "perezosa" de datos históricos.
/// * **Acciones de Usuario**: Sincroniza estados de "leído" y eliminaciones con el backend.
class NotificationsNotifier extends AsyncNotifier<NotificationsState> {
  StreamSubscription? _wsSubscription;
  Timer? _pollingTimer;

  @override
  Future<NotificationsState> build() async {
    final user = ref.watch(authProvider);

    ref.onDispose(() {
      _wsSubscription?.cancel();
      _pollingTimer?.cancel();
    });

    if (user == null) {
      return const NotificationsState();
    }

    _listenToWebSocket();
    _startPolling();

    return _fetchPage(skip: 0);
  }

  /// ID del usuario activo para contextualizar las peticiones.
  int? get _userId => ref.read(authProvider)?.id;

  /// Recupera una página específica del historial de notificaciones.
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

  /// Conecta la lógica de negocio con el flujo de datos del WebSocket.
  void _listenToWebSocket() {
    _wsSubscription?.cancel();

    final ws = ref.read(notificationWsProvider);
    if (ws == null) return;

    _wsSubscription = ws.notificationStream.listen((notification) {
      final currentState = state.value;
      if (currentState == null) return;

      // Inserción en la cabeza de la lista para visibilidad inmediata
      state = AsyncData(
        currentState.copyWith(
          notifications: [notification, ...currentState.notifications],
          unreadCount: currentState.unreadCount + 1,
          totalCount: currentState.totalCount + 1,
        ),
      );
    });
  }

  /// Mantiene la consistencia del contador de notificaciones mediante sondeo periódico.
  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(_pollingInterval, (_) async {
      try {
        final repo = ref.read(notificationRepositoryProvider);
        final serverCount = await repo.getUnreadCount();
        final currentState = state.value;
        if (currentState != null && serverCount != currentState.unreadCount) {
          // Si hay discrepancia, forzamos un refresco total de la bandeja
          final freshState = await _fetchPage(skip: 0);
          state = AsyncData(freshState);
        }
      } catch (_) {
        // Sondeo silencioso: priorizamos la estabilidad de la UI.
      }
    });
  }

  /// Dispara la carga de la siguiente página de resultados.
  Future<void> fetchMore() async {
    final currentState = state.value;
    if (currentState == null ||
        !currentState.hasMore ||
        currentState.isLoadingMore) {
      return;
    }

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

  /// Actualiza el estado de lectura de una notificación específica.
  /// 
  /// Implementa una **Actualización Optimista** para respuesta inmediata en UI.
  Future<void> markAsRead(int notificationId) async {
    final currentState = state.value;
    if (currentState == null) return;

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
      // Reversión de estado en caso de fallo de red
      state = AsyncData(currentState);
    }
  }

  /// Marca todas las alertas activas como leídas en una sola transacción.
  Future<void> markAllAsRead() async {
    final currentState = state.value;
    if (currentState == null) return;

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

  /// Fuerza la recarga completa del historial de notificaciones.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPage(skip: 0));
  }

  /// Elimina permanentemente una notificación.
  /// 
  /// Utiliza actualización optimista para asegurar fluidez en el gesto de borrado.
  Future<void> deleteNotification(int notificationId) async {
    final currentState = state.value;
    if (currentState == null) return;

    final removedNotification = currentState.notifications
        .where((n) => n.id == notificationId)
        .firstOrNull;

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

// ─── Puntos de Acceso Globales (Providers) ─────────────────────

/// Proveedor del estado reactivo de las notificaciones.
final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, NotificationsState>(
      () => NotificationsNotifier(),
    );

/// Proveedor derivado optimizado para el badge de alertas no leídas.
final unreadCountProvider = Provider<int>((ref) {
  final notificationsState = ref.watch(notificationsProvider);
  return notificationsState.value?.unreadCount ?? 0;
});
