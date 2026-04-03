/// Contrato del repositorio de clima.
///
/// Define la interfaz que la capa de datos debe implementar.
/// Sigue el principio de inversión de dependencias (DIP).

import '../entities/weather_entity.dart';

abstract class WeatherRepository {
  /// Obtiene el clima actual para las coordenadas dadas.
  ///
  /// Implementaciones deben manejar cache internamente.
  /// Lanza [Exception] en caso de error de red sin cache disponible.
  Future<WeatherEntity> getWeather({
    required double latitude,
    required double longitude,
  });

  /// Obtiene el clima actual por nombre de ciudad.
  Future<WeatherEntity> getWeatherByCity({
    required String cityName,
  });

  /// Limpia el cache local.
  Future<void> clearCache();
}
