/// Providers para el sistema de clima.
///
/// Usa AsyncNotifier de Riverpod para manejar estados de
/// carga, error y datos con cache automático y auto-refresh.

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/units/presentation/unit_system_provider.dart'
    show sharedPreferencesProvider;
import '../../../../providers/app_providers.dart' show appConfigProvider;
import '../../../../providers/auth_provider.dart';
import '../../data/datasources/weather_local_datasource.dart';
import '../../data/datasources/weather_remote_datasource.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../data/services/geo_location_service.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/entities/weather_recommendation.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../domain/services/recommendation_engine.dart';

// ─── Dependency Providers ────────────────────────────────────

final geoLocationServiceProvider = Provider<GeoLocationService>((ref) {
  return const GeoLocationService();
});

final weatherRemoteDataSourceProvider = Provider<WeatherRemoteDataSource>((
  ref,
) {
  final config = ref.watch(appConfigProvider);
  return WeatherRemoteDataSource(
    baseUrl: config.baseUrl,
    getToken: () => ref.read(authProvider)?.token,
  );
});

final weatherLocalDataSourceProvider = Provider<WeatherLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return WeatherLocalDataSource(prefs);
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepositoryImpl(
    remoteDataSource: ref.watch(weatherRemoteDataSourceProvider),
    localDataSource: ref.watch(weatherLocalDataSourceProvider),
  );
});

// ─── State Class ─────────────────────────────────────────────

/// Estado del sistema de clima.
class WeatherState {
  final WeatherEntity weather;
  final List<WeatherRecommendation> recommendations;
  final bool isFallbackLocation;
  final DateTime lastUpdated;

  const WeatherState({
    required this.weather,
    required this.recommendations,
    this.isFallbackLocation = false,
    required this.lastUpdated,
  });

  /// Retorna la recomendación más importante (mayor severidad).
  WeatherRecommendation? get primaryRecommendation {
    if (recommendations.isEmpty) return null;

    // Priorizar: critical > warning > info
    final sorted = [...recommendations]
      ..sort((a, b) {
        return b.severity.index.compareTo(a.severity.index);
      });
    return sorted.first;
  }
}

// ─── Main Notifier ───────────────────────────────────────────

/// Intervalo de auto-refresh para el clima.
const Duration _refreshInterval = Duration(minutes: 15);

class WeatherNotifier extends AsyncNotifier<WeatherState> {
  Timer? _refreshTimer;

  @override
  Future<WeatherState> build() async {
    ref.onDispose(() {
      _refreshTimer?.cancel();
    });

    // Iniciar auto-refresh
    _startAutoRefresh();

    return _fetchWeather();
  }

  /// Obtiene el clima actual, dando prioridad a una ciudad manual.
  Future<WeatherState> _fetchWeather({String? overrideCity}) async {
    final geoService = ref.read(geoLocationServiceProvider);
    final repo = ref.read(weatherRepositoryProvider);
    final prefs = ref.read(sharedPreferencesProvider);

    final city = overrideCity ?? prefs.getString('manual_weather_city');

    WeatherEntity weather;
    bool isFallback = false;

    if (city != null && city.isNotEmpty) {
      weather = await repo.getWeatherByCity(cityName: city);
    } else {
      // 1. Obtener ubicación
      final location = await geoService.getCurrentLocation();
      isFallback = location.isFallback;

      // 2. Obtener clima
      weather = await repo.getWeather(
        latitude: location.latitude,
        longitude: location.longitude,
      );
    }

    // 3. Generar recomendaciones
    final recommendations = RecommendationEngine.evaluate(weather);

    return WeatherState(
      weather: weather,
      recommendations: recommendations,
      isFallbackLocation: isFallback,
      lastUpdated: DateTime.now(),
    );
  }

  /// Auto-refresh periódico.
  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(_refreshInterval, (_) async {
      try {
        final newState = await _fetchWeather();
        state = AsyncData(newState);
      } catch (_) {
        // Refresh silencioso — no interrumpir la UI
      }
    });
  }

  /// Refresca manualmente.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchWeather());
  }

  /// Cambia a una ciudad manual, guardándola en caché si es válida.
  /// Para volver al GPS, pasar un string vacío.
  Future<void> setManualCity(String city) async {
    final prefs = ref.read(sharedPreferencesProvider);
    state = const AsyncLoading();

    if (city.trim().isEmpty) {
      await prefs.remove('manual_weather_city');
      state = await AsyncValue.guard(() => _fetchWeather());
      return;
    }

    state = await AsyncValue.guard(() async {
      final newState = await _fetchWeather(overrideCity: city);
      await prefs.setString('manual_weather_city', city);
      return newState;
    });
  }
}

// ─── Provider Declarations ──────────────────────────────────

final weatherProvider = AsyncNotifierProvider<WeatherNotifier, WeatherState>(
  () => WeatherNotifier(),
);

/// Provider derivado para las recomendaciones (conveniencia para la UI).
final weatherRecommendationsProvider = Provider<List<WeatherRecommendation>>((
  ref,
) {
  final weatherState = ref.watch(weatherProvider);
  return weatherState.value?.recommendations ?? [];
});
