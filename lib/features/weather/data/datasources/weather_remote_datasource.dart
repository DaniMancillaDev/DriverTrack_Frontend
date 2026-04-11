/// Data source remoto para el clima.
///
/// Consume el proxy de clima del backend de DriveTrack
/// en lugar de llamar directamente a OpenWeatherMap.
/// La API key se mantiene segura en el servidor.

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

/// Proveedor del token JWT para autenticar peticiones.
typedef TokenProvider = String? Function();

class WeatherRemoteDataSource {
  final String baseUrl;
  final TokenProvider? getToken;
  final http.Client _client;

  WeatherRemoteDataSource({
    required this.baseUrl,
    this.getToken,
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// Headers con autenticación Bearer.
  Map<String, String> _buildHeaders() {
    final headers = <String, String>{'Content-Type': 'application/json'};
    final token = getToken?.call();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Obtiene el clima actual para las coordenadas dadas.
  ///
  /// La petición va al backend, que hace el proxy a OWM.
  /// El JSON retornado tiene el mismo formato que OWM,
  /// por lo que [WeatherModel.fromOwmJson] sigue funcionando.
  ///
  /// Lanza [WeatherApiException] en caso de error.
  Future<WeatherModel> fetchCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/weather/current?lat=$latitude&lon=$longitude',
    );

    try {
      final response = await _client
          .get(uri, headers: _buildHeaders())
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherModel.fromOwmJson(json);
      } else if (response.statusCode == 401) {
        throw WeatherApiException(
          'Sesión expirada — vuelve a iniciar sesión',
          statusCode: 401,
        );
      } else {
        throw WeatherApiException(
          'Error del servidor: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on WeatherApiException {
      rethrow;
    } catch (e) {
      throw WeatherApiException('Error de red: $e');
    }
  }

  /// Obtiene el clima actual por nombre de ciudad.
  Future<WeatherModel> fetchWeatherByCityName({
    required String cityName,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/weather/city/${Uri.encodeComponent(cityName)}',
    );

    try {
      final response = await _client
          .get(uri, headers: _buildHeaders())
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherModel.fromOwmJson(json);
      } else if (response.statusCode == 404) {
        throw WeatherApiException(
          'Ciudad no encontrada: $cityName',
          statusCode: 404,
        );
      } else {
        throw WeatherApiException(
          'Error del servidor: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on WeatherApiException {
      rethrow;
    } catch (e) {
      throw WeatherApiException('Error de red: $e');
    }
  }
}

/// Excepción específica para errores de la API de clima.
class WeatherApiException implements Exception {
  final String message;
  final int? statusCode;

  const WeatherApiException(this.message, {this.statusCode});

  @override
  String toString() => 'WeatherApiException: [$statusCode] $message';
}
