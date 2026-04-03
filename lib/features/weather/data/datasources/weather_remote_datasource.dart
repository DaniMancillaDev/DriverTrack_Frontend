/// Data source remoto para el clima.
///
/// Consume la API de OpenWeatherMap Current Weather.
/// Siempre solicita datos en unidades métricas (°C, m/s).

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherRemoteDataSource {
  final String apiKey;
  final http.Client _client;

  /// URL base de la API de OpenWeatherMap.
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5';

  WeatherRemoteDataSource({
    required this.apiKey,
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// Obtiene el clima actual para las coordenadas dadas.
  ///
  /// Siempre usa `units=metric` para recibir °C y m/s.
  /// Lanza [WeatherApiException] en caso de error.
  Future<WeatherModel> fetchCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric',
    );

    try {
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherModel.fromOwmJson(json);
      } else if (response.statusCode == 401) {
        throw WeatherApiException(
          'API key inválida o expirada',
          statusCode: 401,
        );
      } else {
        throw WeatherApiException(
          'Error del servidor OWM: ${response.statusCode}',
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
      '$_baseUrl/weather?q=$cityName&appid=$apiKey&units=metric',
    );

    try {
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherModel.fromOwmJson(json);
      } else if (response.statusCode == 404) {
        throw WeatherApiException('Ciudad no encontrada: $cityName', statusCode: 404);
      } else {
        throw WeatherApiException(
          'Error del servidor OWM: ${response.statusCode}',
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
