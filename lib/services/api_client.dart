import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';

class ApiClient {
  final AppConfig config;
  final http.Client _client;

  ApiClient(this.config, {http.Client? client})
    : _client = client ?? http.Client();

  String get baseUrl => config.baseUrl;

  /// Realiza una petición GET genérica
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await _client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    return _processResponse(response);
  }

  /// Realiza una petición POST genérica
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    return _processResponse(response);
  }

  /// Realiza una petición PUT genérica
  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await _client.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    return _processResponse(response);
  }

  /// Realiza una petición PATCH genérica
  Future<dynamic> patch(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await _client.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    return _processResponse(response);
  }

  /// Realiza una petición DELETE genérica
  Future<void> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await _client.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    _processResponse(response);
  }

  /// Helper que procesa las respuestas HTTP y lanza excepciones
  /// encapsuladas para facilitar el manejo en la UI.
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
