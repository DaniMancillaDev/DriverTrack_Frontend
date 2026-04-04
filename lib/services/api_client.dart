import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';

/// Tipo de función que devuelve el token de autenticación actual o null.
/// Se usa para desacoplar ApiClient del AuthProvider (evita dependencias circulares).
typedef TokenProvider = String? Function();

class ApiClient {
  final AppConfig config;
  final http.Client _client;

  /// Función que devuelve el token de sesión actual (inyectado desde AuthNotifier).
  /// Si el backend usa cookies en vez de Bearer, esta función puede devolver null
  /// y los headers de autenticación simplemente no se agregarán.
  final TokenProvider? getToken;

  ApiClient(this.config, {http.Client? client, this.getToken})
    : _client = client ?? http.Client();

  String get baseUrl => config.baseUrl;

  // ─── Headers helpers ──────────────────────────────────────

  /// Construye los headers HTTP incluyendo el Bearer token si existe.
  Map<String, String> _buildHeaders() {
    final headers = <String, String>{'Content-Type': 'application/json'};
    final token = getToken?.call();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // ─── Retry Handler with Exponential Backoff ──────────────────

  static const int _maxRetries = 3;

  /// Wrapper around HTTP calls to implement retry with exponential backoff
  /// on network failures or 5xx server errors.
  Future<http.Response> _withRetry(Future<http.Response> Function() requestFn) async {
    int attempt = 0;
    while (true) {
      try {
        final response = await requestFn();
        // Retry on 5xx Internal Server Errors
        if (response.statusCode >= 500 && attempt < _maxRetries) {
          attempt++;
          final backoff = pow(2, attempt) * 500; // 1s, 2s, 4s...
          await Future.delayed(Duration(milliseconds: backoff.toInt()));
          continue;
        }
        return response;
      } catch (e) {
        // Retry on SocketExceptions or other network interruptions
        attempt++;
        if (attempt > _maxRetries) rethrow;
        final backoff = pow(2, attempt) * 500;
        await Future.delayed(Duration(milliseconds: backoff.toInt()));
      }
    }
  }

  // ─── HTTP Methods ─────────────────────────────────────────

  /// Realiza una petición GET genérica
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await _withRetry(() => _client.get(url, headers: _buildHeaders()));
    return _processResponse(response);
  }

  /// Realiza una petición POST genérica
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await _withRetry(() => _client.post(
          url,
          headers: _buildHeaders(),
          body: json.encode(body),
        ));
    return _processResponse(response);
  }

  /// Realiza una petición PUT genérica
  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await _withRetry(() => _client.put(
          url,
          headers: _buildHeaders(),
          body: json.encode(body),
        ));
    return _processResponse(response);
  }

  /// Realiza una petición PATCH genérica
  Future<dynamic> patch(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await _withRetry(() => _client.patch(
          url,
          headers: _buildHeaders(),
          body: json.encode(body),
        ));
    return _processResponse(response);
  }

  /// Realiza una petición DELETE genérica
  Future<void> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await _withRetry(() => _client.delete(url, headers: _buildHeaders()));
    _processResponse(response);
  }

  // ─── Response handler ─────────────────────────────────────

  /// Procesa la respuesta HTTP y lanza ApiException en caso de error.
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message:
            'Request failed with status: ${response.statusCode}. Body: ${response.body}',
      );
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException: [$statusCode] $message';
}
