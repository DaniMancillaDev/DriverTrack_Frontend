/// Orquestadores de datos y lógica para el sistema meteorológico (Weather).
///
/// Implementa un flujo reactivo utilizando [AsyncNotifier] para gestionar
/// estados de carga, errores y persistencia de datos ambientales, incluyendo
/// mecanismos de auto-actualización (polling).

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/units/presentation/unit_system_provider.dart'
    show sharedPreferencesProvider;
import '../../../../providers/app_providers.dart' show apiClientProvider;
import '../../data/datasources/weather_local_datasource.dart';
import '../../data/datasources/weather_remote_datasource.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../data/services/geo_location_service.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/entities/weather_recommendation.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../domain/services/recommendation_engine.dart';

// ─── Proveedores de Dependencias Inferiores ────────────────────────

/// Punto de acceso al servicio de geolocalización del dispositivo.
final geoLocationServiceProvider = Provider<GeoLocationService>((ref) {
  return const GeoLocationService();
});

/// Gestiona la comunicación con la API externa de clima.
final weatherRemoteDataSourceProvider = Provider<WeatherRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return WeatherRemoteDataSource(apiClient: apiClient);
});

/// Orquestador del almacenamiento persistente (caché) de datos climáticos.
final weatherLocalDataSourceProvider = Provider<WeatherLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return WeatherLocalDataSource(prefs);
});

/// Implementación del repositorio que unifica las fuentes de datos (Remota/Local).
final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepositoryImpl(
    remoteDataSource: ref.watch(weatherRemoteDataSourceProvider),
    localDataSource: ref.watch(weatherLocalDataSourceProvider),
  );
});

// ─── Definición del Estado del Dominio ─────────────────────────────

/// Representa el balance informativo del contexto ambiental en la UI.
/// 
/// Consolida el clima actual, las alertas de seguridad recomendadas y 
/// metadatos de sincronización.
class WeatherState {
  /// Entidad de dominio con los valores climáticos (temperatura, condición).
  final WeatherEntity weather;
  /// Lista de avisos generados basados en las condiciones (ej. "Piso resbaladizo").
  final List<WeatherRecommendation> recommendations;
  /// Indica si la ubicación utilizada es una de respaldo debido a falta de GPS.
  final bool isFallbackLocation;
  /// Marca temporal de la última sincronización exitosa.
  final DateTime lastUpdated;

  const WeatherState({
    required this.weather,
    required this.recommendations,
    this.isFallbackLocation = false,
    required this.lastUpdated,
  });

  /// Extrae la recomendación de mayor impacto para la conducción inmediata.
  /// 
  /// Filtra y prioriza las alertas por nivel de severidad (Crítico > Advertencia > Info).
  WeatherRecommendation? get primaryRecommendation {
    if (recommendations.isEmpty) return null;

    final sorted = [...recommendations]
      ..sort((a, b) {
        return b.severity.index.compareTo(a.severity.index);
      });
    return sorted.first;
  }
}

// ─── Notificador de Lógica de Negocio (Presentation Logic) ────────

/// Intervalo de refresco automático del clima (defensa ante cambios rápidos).
const Duration _refreshInterval = Duration(minutes: 15);

/// Orquestador reactivo de las condiciones ambientales para la flota.
/// 
/// Sus responsabilidades incluyen:
/// * **Ubicación Dinámica**: Coordina con el sensor GPS para obtener el clima local.
/// * **Evaluación de Riesgos**: Dispara el motor de recomendaciones según la meteorología.
/// * **Cache Cooperativo**: Mantiene datos visibles incluso sin conexión.
/// * **Auto-Sincronización**: Registra un temporizador para refrescar el estado periódicamente.
class WeatherNotifier extends AsyncNotifier<WeatherState> {
  Timer? _refreshTimer;

  @override
  Future<WeatherState> build() async {
    ref.onDispose(() {
      _refreshTimer?.cancel();
    });

    _startAutoRefresh();

    return _fetchWeather();
  }

  /// Recupera el clima consolidado, priorizando selecciones manuales sobre el GPS.
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
      // 1. Geolocalización
      final location = await geoService.getCurrentLocation();
      isFallback = location.isFallback;

      // 2. Transmisión de datos
      weather = await repo.getWeather(
        latitude: location.latitude,
        longitude: location.longitude,
      );
    }

    // 3. Post-procesamiento: Generar recomendaciones de conducción
    final recommendations = RecommendationEngine.evaluate(weather);

    return WeatherState(
      weather: weather,
      recommendations: recommendations,
      isFallbackLocation: isFallback,
      lastUpdated: DateTime.now(),
    );
  }

  /// Inicia la actualización periódica en segundo plano.
  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(_refreshInterval, (_) async {
      try {
        final newState = await _fetchWeather();
        state = AsyncData(newState);
      } catch (_) {
        // Fallo silencioso: Mantenemos el último estado válido por seguridad.
      }
    });
  }

  /// Fuerza una recarga completa del estado desde la interfaz.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchWeather());
  }

  /// Establece una ciudad fija para el clima, anulando la geolocalización.
  /// 
  /// Persiste la elección en preferencias para mantenerla entre sesiones.
  /// Si [city] es vacío, se restaura el seguimiento por GPS.
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

// ─── Declaración de Proveedores Globales (Puntos de Acceso) ────────

/// Proveedor principal del estado meteorológico reactivo.
final weatherProvider = AsyncNotifierProvider<WeatherNotifier, WeatherState>(
  () => WeatherNotifier(),
);

/// Proveedor simplificado para acceder exclusivamente a las recomendaciones activas.
final weatherRecommendationsProvider = Provider<List<WeatherRecommendation>>((
  ref,
) {
  final weatherState = ref.watch(weatherProvider);
  return weatherState.value?.recommendations ?? [];
});
