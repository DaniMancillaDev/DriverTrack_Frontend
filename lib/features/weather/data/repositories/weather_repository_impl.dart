/// Implementación del repositorio de clima.
///
/// Estrategia cache-first:
/// 1. Si el cache es fresco → retorna cache
/// 2. Si no → intenta fetch remoto → cachea resultado
/// 3. Si falla el remoto → retorna cache stale si disponible
/// 4. Si no hay nada → lanza excepción

import '../../domain/entities/weather_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_local_datasource.dart';
import '../datasources/weather_remote_datasource.dart';
import '../models/weather_model.dart';

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
