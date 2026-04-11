/// Data source remoto para el clima.
///
/// Consume el proxy de clima del backend de DriveTrack
/// en lugar de llamar directamente a OpenWeatherMap.
/// Usa [ApiClient] para manejar autenticación Bearer,
/// refresh automático de tokens y expiración de sesión.

import '../models/weather_model.dart';
import '../../../../core/network/api_client.dart';

class WeatherRemoteDataSource {
  final ApiClient _apiClient;

  const WeatherRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  /// Obtiene el clima actual basado en la geolocalización del dispositivo.
  ///
  /// Realiza un GET al endpoint `/weather/current`.
  /// Lanza [WeatherApiException] si el servidor no responde o hay errores de validación.
  Future<WeatherModel> fetchCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final json = await _apiClient.get(
        '/weather/current?lat=$latitude&lon=$longitude',
      ) as Map<String, dynamic>;
      return WeatherModel.fromOwmJson(json);
    } on SessionExpiredException {
      throw const WeatherApiException(
        'Sesión expirada — vuelve a iniciar sesión',
        statusCode: 401,
      );
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        throw WeatherApiException(
          'Ubicación no encontrada',
          statusCode: 404,
        );
      }
      throw WeatherApiException(
        'Error del servidor: ${e.statusCode}',
        statusCode: e.statusCode,
      );
    } catch (e) {
      throw WeatherApiException('Error de red: $e');
    }
  }

  /// Obtiene el clima buscando por el nombre de la ciudad.
  /// 
  /// Útil como fallback si el GPS no está disponible o para búsquedas manuales.
  Future<WeatherModel> fetchWeatherByCityName({
    required String cityName,
  }) async {
    try {
      final json = await _apiClient.get(
        '/weather/city/${Uri.encodeComponent(cityName)}',
      ) as Map<String, dynamic>;
      return WeatherModel.fromOwmJson(json);
    } on SessionExpiredException {
      throw const WeatherApiException(
        'Sesión expirada — vuelve a iniciar sesión',
        statusCode: 401,
      );
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        throw WeatherApiException(
          'Ciudad no encontrada: $cityName',
          statusCode: 404,
        );
      }
      throw WeatherApiException(
        'Error del servidor: ${e.statusCode}',
        statusCode: e.statusCode,
      );
    } catch (e) {
      throw WeatherApiException('Error de red: $e');
    }
  }
}

/// Excepción especializada para errores ocurridos en la feature de clima.
class WeatherApiException implements Exception {
  /// Mensaje descriptivo para el usuario o logs.
  final String message;

  /// Código de estado HTTP si el error provino del servidor.
  final int? statusCode;

  const WeatherApiException(this.message, {this.statusCode});

  @override
  String toString() => 'WeatherApiException: [$statusCode] $message';
}
