/// Datasource WebSocket para notificaciones en tiempo real.
///
/// Mantiene conexión persistente con auto-reconexión,
/// heartbeat y stream de nuevas notificaciones.
///
/// Autenticación: el JWT se pasa como query parameter:
///   ws://host/ws/notifications?token=<JWT>
/// El servidor valida el token antes de aceptar la conexión.
/// Si el token es inválido, cierra con código 4001.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../models/notification_model.dart';

class NotificationWebSocketDataSource {
  final String _baseUrl;
  final String _token;

  WebSocket? _channel;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;

  /// Stream controller para nuevas notificaciones.
  final StreamController<NotificationModel> _notificationController =
      StreamController<NotificationModel>.broadcast();

  /// Stream controller para el estado de conexión.
  final StreamController<bool> _connectionStateController =
      StreamController<bool>.broadcast();

  /// Número de intentos de reconexión actual.
  int _reconnectAttempts = 0;

  /// Máximo de intentos antes de pausar la reconexión.
  static const int _maxReconnectAttempts = 10;

  /// Intervalo de heartbeat (segundos).
  static const int _heartbeatIntervalSecs = 25;

  /// Si la conexión está activa.
  bool _isConnected = false;

  /// Si fue desconectado intencionalmente.
  bool _isDisposed = false;

  /// Si el servidor rechazó el token (4001) — no reintentar.
  bool _isAuthRejected = false;

  NotificationWebSocketDataSource({
    required String baseUrl,
    required String token,
  })  : _baseUrl = baseUrl,
        _token = token;

  /// Stream de nuevas notificaciones recibidas en tiempo real.
  Stream<NotificationModel> get notificationStream =>
      _notificationController.stream;

  /// Stream del estado de conexión (true = conectado).
  Stream<bool> get connectionState => _connectionStateController.stream;

  /// Si la conexión WebSocket está activa.
  bool get isConnected => _isConnected;

  /// Establece la conexión WebSocket autenticada.
  Future<void> connect() async {
    if (_isDisposed || _isAuthRejected) return;

    try {
      // Construir la URL WebSocket con el token JWT como query param
      final wsUrl = _baseUrl
          .replaceFirst('http://', 'ws://')
          .replaceFirst('https://', 'wss://');

      // El backend valida el token antes de aceptar la conexión
      final uri = '$wsUrl/ws/notifications?token=${Uri.encodeComponent(_token)}';

      _channel = await WebSocket.connect(uri);
      _channel!.pingInterval = const Duration(seconds: 15);
      _isConnected = true;
      _reconnectAttempts = 0;
      _connectionStateController.add(true);

      _startHeartbeat();

      _channel!.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );
    } catch (e) {
      _isConnected = false;
      _connectionStateController.add(false);
      _scheduleReconnect();
    }
  }

  /// Procesa mensajes recibidos del WebSocket.
  void _onMessage(dynamic data) {
    try {
      final Map<String, dynamic> json = jsonDecode(data as String);

      // Ignorar mensajes de control del servidor
      final msgType = json['type'];
      if (msgType == 'connection_established' || msgType == 'pong') {
        return;
      }

      // Intentar parsear como notificación
      if (json.containsKey('id') && json.containsKey('title')) {
        final notification = NotificationModel.fromJson(json);
        _notificationController.add(notification);
      }
    } catch (e) {
      // Mensaje no reconocido, ignorar silenciosamente
    }
  }

  /// Maneja errores del WebSocket.
  void _onError(dynamic error) {
    _isConnected = false;
    if (!_connectionStateController.isClosed) {
      _connectionStateController.add(false);
    }
    _stopHeartbeat();
    _scheduleReconnect();
  }

  /// Maneja el cierre de la conexión.
  void _onDone() {
    _isConnected = false;

    // Verificar si el servidor cerró con código 4001 (token inválido)
    final closeCode = _channel?.closeCode;
    if (closeCode == 4001) {
      // Token rechazado — NO reconectar automáticamente
      // Flutter debe manejar el 401 y actualizar el token
      _isAuthRejected = true;
      if (!_connectionStateController.isClosed) {
        _connectionStateController.add(false);
      }
      return;
    }

    if (!_connectionStateController.isClosed) {
      _connectionStateController.add(false);
    }
    _stopHeartbeat();
    if (!_isDisposed) {
      _scheduleReconnect();
    }
  }

  /// Inicia el heartbeat periódico para mantener la conexión viva.
  void _startHeartbeat() {
    _stopHeartbeat();
    _heartbeatTimer = Timer.periodic(
      const Duration(seconds: _heartbeatIntervalSecs),
      (_) {
        if (_isConnected && _channel != null) {
          try {
            _channel!.add(jsonEncode({'type': 'ping'}));
          } catch (_) {
            _onDone();
          }
        }
      },
    );
  }

  /// Detiene el heartbeat.
  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  /// Programa una reconexión con backoff exponencial.
  void _scheduleReconnect() {
    if (_isDisposed || _isAuthRejected) return;
    if (_reconnectAttempts >= _maxReconnectAttempts) return;

    _reconnectTimer?.cancel();
    final delay = Duration(seconds: (1 << _reconnectAttempts).clamp(1, 60));
    _reconnectAttempts++;

    _reconnectTimer = Timer(delay, () {
      if (!_isDisposed && !_isAuthRejected) connect();
    });
  }

  /// Desconecta y libera recursos.
  Future<void> dispose() async {
    _isDisposed = true;
    _stopHeartbeat();
    _reconnectTimer?.cancel();
    await _channel?.close();
    await _notificationController.close();
    await _connectionStateController.close();
  }
}
