import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';

/// Devuelve el access token actual o null.
typedef TokenProvider = String? Function();

/// Intenta refrescar el access token usando el refresh token guardado.
/// Devuelve el nuevo access token si lo logró, o null si falló.
typedef TokenRefresher = Future<String?> Function();

/// Invocado cuando el refresh también falla: sesión definitivamente expirada.
typedef SessionExpiredCallback = void Function();

class ApiClient {
  final AppConfig config;
  final http.Client _client;

  final TokenProvider? getToken;
  final TokenRefresher? tryRefreshToken;
  final SessionExpiredCallback? onSessionExpired;

  ApiClient(
    this.config, {
    http.Client? client,
    this.getToken,
    this.tryRefreshToken,
    this.onSessionExpired,
  }) : _client = client ?? http.Client();

  String get baseUrl => config.baseUrl;

  // ─── Headers helpers ──────────────────────────────────────

  Map<String, String> _buildHeaders({String? overrideToken}) {
    final headers = <String, String>{'Content-Type': 'application/json'};
    final token = overrideToken ?? getToken?.call();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // ─── Retry Handler with Exponential Backoff ──────────────────

  static const int _maxRetries = 3;

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

  // ─── Token Refresh Logic ──────────────────────────────────

  /// Intenta refrescar el token. Si lo logra, reintenta la request original.
  /// Si no, invoca [onSessionExpired] y lanza [SessionExpiredException].
  Future<dynamic> _handleUnauthorized(
    Future<http.Response> Function(String? token) retryFn,
  ) async {
    if (tryRefreshToken == null) {
      onSessionExpired?.call();
      throw const SessionExpiredException();
    }

    final newToken = await tryRefreshToken!();
    if (newToken == null || newToken.isEmpty) {
      onSessionExpired?.call();
      throw const SessionExpiredException();
    }

    // Reintentar con el nuevo token
    final retryResponse = await retryFn(newToken);
    return _processResponse(retryResponse, isRetry: true);
  }

  // ─── HTTP Methods ─────────────────────────────────────────

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

  // ─── Response handler ─────────────────────────────────────

  dynamic _processResponse(http.Response response, {bool isRetry = false}) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      if (response.statusCode == 401 && isRetry) {
        // El retry también falló → sesión definitivamente expirada
        onSessionExpired?.call();
        throw const SessionExpiredException();
      }
      throw ApiException(
        statusCode: response.statusCode,
        message: _extractErrorMessage(response),
      );
    }
  }

  /// Extrae el mensaje de error del body de forma amigable.
  /// Si el JSON tiene un campo 'detail', lo usa; si no, usa un mensaje genérico.
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

// ─── Exceptions ───────────────────────────────────────────────

class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException: [$statusCode] $message';
}

/// Lanzada cuando el token y el refresh token ambos fallaron.
/// La UI debe mostrar un mensaje amigable y redirigir al login.
class SessionExpiredException implements Exception {
  const SessionExpiredException();

  @override
  String toString() => 'SessionExpiredException: La sesión ha expirado.';
}
