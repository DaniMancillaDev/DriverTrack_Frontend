import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import '../../config/app_config.dart';

/// Definición de contrato para proveer el token de acceso actual (JWT).
typedef TokenProvider = String? Function();

/// Definición de contrato para la lógica asíncrona de renovación de credenciales.
/// Retorna un nuevo access token o null en caso de fallo crítico.
typedef TokenRefresher = Future<String?> Function();

/// Definición de contrato para notificar el cese definitivo de la sesión.
typedef SessionExpiredCallback = void Function();

/// Cliente HTTP centralizado para la comunicación con el backend de DriveTrack.
///
/// Maneja automáticamente:
/// * Inyección de tokens de autenticación Bearer.
/// * Reintentos automáticos con backoff exponencial ante errores 5xx.
/// * Refresco de tokens (JWT) de forma serializada para evitar condiciones de carrera.
/// * Manejo global de errores y mapeo de respuestas JSON.
class ApiClient {
  /// Configuración global de la aplicación que incluye la URL base.
  final AppConfig config;

  /// Cliente HTTP interno.
  final http.Client _client;

  /// Proveedor de token de acceso. Debe retornar el JWT actual.
  final TokenProvider? getToken;

  /// Lógica para intentar refrescar el token de acceso usando un refresh token.
  /// Debe retornar el nuevo access token si es exitoso o null en caso contrario.
  final TokenRefresher? tryRefreshToken;

  /// Callback invocado cuando la sesión ha expirado definitivamente
  /// (el refresh token también falló o es inválido).
  final SessionExpiredCallback? onSessionExpired;

  /// Mutex interno para el proceso de refresco de tokens.
  ///
  /// Evita que múltiples peticiones concurrentes disparen llamadas paralelas
  /// al endpoint de refresh al mismo tiempo.
  Completer<String?>? _refreshCompleter;

  /// Crea una nueva instancia de [ApiClient].
  ApiClient(
    this.config, {
    http.Client? client,
    this.getToken,
    this.tryRefreshToken,
    this.onSessionExpired,
  }) : _client = client ?? http.Client();

  /// URL base para todas las peticiones.
  String get baseUrl => config.baseUrl;

  // ─── Map de headers ──────────────────────────────────────

  /// Construye los headers HTTP necesarios para una petición JSON.
  ///
  /// Si hay un token disponible (ya sea el actual o el [overrideToken]),
  /// se incluye en el header 'Authorization' como Bearer.
  Map<String, String> _buildHeaders({String? overrideToken}) {
    final headers = <String, String>{'Content-Type': 'application/json'};
    final token = overrideToken ?? getToken?.call();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // ─── Manejo de Reintentos ──────────────────

  /// Número máximo de reintentos para errores transitorios (5xx).
  static const int _maxRetries = 3;

  /// Envoltorio para peticiones que implementa reintentos con backoff exponencial.
  ///
  /// Si el servidor responde con un error >= 500 o hay una excepción de red,
  /// la petición se reintenta hasta [_maxRetries] veces con esperas crecientes.
  Future<http.Response> _withRetry(Future<http.Response> Function() requestFn) async {
    int attempt = 0;
    while (true) {
      try {
        final response = await requestFn();
        if (response.statusCode >= 500 && attempt < _maxRetries) {
          attempt++;
          final backoff = pow(2, attempt) * 500;
          await Future.delayed(Duration(milliseconds: backoff.toInt()));
          continue;
        }
        return response;
      } catch (e) {
        attempt++;
        if (attempt > _maxRetries) rethrow;
        final backoff = pow(2, attempt) * 500;
        await Future.delayed(Duration(milliseconds: backoff.toInt()));
      }
    }
  }

  // ─── Lógica de Refresh de Token ──────────────────────────────────

  /// Serializa el proceso de refresco del token de acceso.
  ///
  /// Utiliza un [Completer] para asegurar que si múltiples peticiones reciben
  /// un error 401 simultáneamente, solo la primera ejecute la lógica de refresh.
  /// Las demás esperarán el resultado de la primera y reutilizarán el nuevo token.
  Future<String?> _serializedRefresh() async {
    // Si ya hay un refresh en curso, todas las peticiones paralelas se
    // suscriben al mismo Future para recibir el resultado una sola vez.
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<String?>();
    try {
      final newToken = await tryRefreshToken!();
      _refreshCompleter!.complete(newToken);
      return newToken;
    } catch (e) {
      _refreshCompleter!.complete(null);
      return null;
    } finally {
      // Liberar el completer para permitir futuros refrescos una vez
      // que este ciclo ha terminado (exitoso o no).
      _refreshCompleter = null;
    }
  }

  /// Gestiona respuestas 401 (No autorizado) intentando refrescar la sesión.
  ///
  /// Implementa el diagrama de flujo:
  /// 1. Recibe 401.
  /// 2. Llama a [_serializedRefresh].
  /// 3. Si obtiene un nuevo token, reintenta la petición original con [retryFn].
  /// 4. Si el refresh falla, invoca [onSessionExpired] y lanza [SessionExpiredException].
  Future<dynamic> _handleUnauthorized(
    Future<http.Response> Function(String? token) retryFn,
  ) async {
    if (tryRefreshToken == null) {
      onSessionExpired?.call();
      throw const SessionExpiredException();
    }

    final newToken = await _serializedRefresh();
    if (newToken == null || newToken.isEmpty) {
      onSessionExpired?.call();
      throw const SessionExpiredException();
    }

    // Reintentar la petición original con el nuevo token obtenido.
    final retryResponse = await retryFn(newToken);
    return _processResponse(retryResponse, isRetry: true);
  }

  // ─── Métodos HTTP Públicos ─────────────────────────────────────

  /// Realiza una petición GET. Retorna el body parseado o lanza [ApiException].
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await _withRetry(() => _client.get(url, headers: _buildHeaders()));
    if (response.statusCode == 401) {
      return _handleUnauthorized(
        (token) => _client.get(url, headers: _buildHeaders(overrideToken: token)),
      );
    }
    return _processResponse(response);
  }

  /// Realiza una petición POST enviando un mapa JSON como body.
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final encoded = json.encode(body);
    final response = await _withRetry(
      () => _client.post(url, headers: _buildHeaders(), body: encoded),
    );
    if (response.statusCode == 401) {
      return _handleUnauthorized(
        (token) => _client.post(url, headers: _buildHeaders(overrideToken: token), body: encoded),
      );
    }
    return _processResponse(response);
  }

  /// Realiza una petición PUT enviando un mapa JSON como body.
  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final encoded = json.encode(body);
    final response = await _withRetry(
      () => _client.put(url, headers: _buildHeaders(), body: encoded),
    );
    if (response.statusCode == 401) {
      return _handleUnauthorized(
        (token) => _client.put(url, headers: _buildHeaders(overrideToken: token), body: encoded),
      );
    }
    return _processResponse(response);
  }

  /// Realiza una petición PATCH enviando un mapa JSON como body.
  Future<dynamic> patch(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final encoded = json.encode(body);
    final response = await _withRetry(
      () => _client.patch(url, headers: _buildHeaders(), body: encoded),
    );
    if (response.statusCode == 401) {
      return _handleUnauthorized(
        (token) => _client.patch(url, headers: _buildHeaders(overrideToken: token), body: encoded),
      );
    }
    return _processResponse(response);
  }

  /// Realiza una petición DELETE.
  Future<void> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await _withRetry(() => _client.delete(url, headers: _buildHeaders()));
    if (response.statusCode == 401) {
      await _handleUnauthorized(
        (token) => _client.delete(url, headers: _buildHeaders(overrideToken: token)),
      );
      return;
    }
    _processResponse(response);
  }

  // ─── Procesamiento de Respuestas ────────────────────────────────

  /// Procesa la respuesta HTTP, maneja errores y decodifica JSON.
  ///
  /// Si el status es 2xx, decodifica el body usando UTF-8.
  /// Si el status es 401 y ya es un reintento, lanza [SessionExpiredException].
  /// Para otros errores, lanza [ApiException] con el detalle del body.
  dynamic _processResponse(http.Response response, {bool isRetry = false}) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      if (response.statusCode == 401 && isRetry) {
        // Si incluso con el nuevo token tras el refresh recibimos 401,
        // la sesión ha expirado definitivamente.
        onSessionExpired?.call();
        throw const SessionExpiredException();
      }
      throw ApiException(
        statusCode: response.statusCode,
        message: _extractErrorMessage(response),
      );
    }
  }

  /// Extrae el mensaje de error del body de la respuesta.
  ///
  /// Busca preferentemente el campo 'detail' de FastAPI. Si no está disponible
  /// o hay un error de parseo, retorna un mensaje genérico con el código HTTP.
  String _extractErrorMessage(http.Response response) {
    try {
      final body = json.decode(utf8.decode(response.bodyBytes));
      if (body is Map && body['detail'] != null) {
        return body['detail'].toString();
      }
    } catch (_) {}
    return 'Error ${response.statusCode}';
  }
}

// ─── Excepciones ───────────────────────────────────────────────

/// Excepción para errores genéricos de la API (status codes != 2xx, 401).
class ApiException implements Exception {
  /// Código de estado HTTP retornado por el servidor.
  final int statusCode;

  /// Mensaje de error extraído del servidor o generado localmente.
  final String message;

  /// Crea una nueva [ApiException].
  const ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException: [$statusCode] $message';
}

/// Excepción lanzada cuando la sesión del usuario ha expirado definitivamente.
///
/// Ocurre cuando tanto el token de acceso como el de refresco fallan.
/// La UI debería reaccionar a esta excepción redirigiendo al usuario al login.
class SessionExpiredException implements Exception {
  /// Crea una nueva [SessionExpiredException].
  const SessionExpiredException();

  @override
  String toString() => 'SessionExpiredException: La sesión ha expirado.';
}

