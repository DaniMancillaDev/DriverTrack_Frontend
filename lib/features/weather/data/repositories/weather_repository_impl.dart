import '../../domain/entities/weather_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_local_datasource.dart';
import '../datasources/weather_remote_datasource.dart';

/// Implementación concreta del repositorio de clima.
///
/// Gestiona la orquestación entre fuentes de datos remotas y locales
/// siguiendo una estrategia de **Caché-Primero (Cache-First)**:
/// 1. Si los datos locales son "frescos" (dentro del TTL), se retornan de inmediato.
/// 2. Si no, se intenta una sincronización remota con el servidor.
/// 3. En caso de fallo de red, se intenta retornar el caché expirado como fallback (stale-while-revalidate).
/// 4. Si no hay datos en ninguna fuente, se propaga la excepción.
///
/// Esta capa actúa como mediador, asegurando que la lógica de negocio no necesite
/// conocer los detalles de la persistencia o la comunicación con el Proxy de Clima.
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<WeatherEntity> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    // 1. Intentar cache fresco
    if (localDataSource.isCacheFresh()) {
      final cached = localDataSource.getCachedWeather();
      if (cached != null) return cached;
    }

    // 2. Fetch remoto
    try {
      final weather = await remoteDataSource.fetchCurrentWeather(
        latitude: latitude,
        longitude: longitude,
      );

      // Cachear resultado
      await localDataSource.cacheWeather(weather);
      return weather;
    } catch (e) {
      // 3. Fallback: cache stale
      final staleCache = localDataSource.getCachedWeather();
      if (staleCache != null) return staleCache;

      // 4. Sin datos disponibles
      rethrow;
    }
  }

  @override
  Future<WeatherEntity> getWeatherByCity({required String cityName}) async {
    try {
      final weather = await remoteDataSource.fetchWeatherByCityName(
        cityName: cityName,
      );

      await localDataSource.cacheWeather(weather);
      return weather;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> clearCache() => localDataSource.clearCache();
}
