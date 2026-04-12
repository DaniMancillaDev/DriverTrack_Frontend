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

import '../../domain/entities/weather_entity.dart';
import '../../domain/entities/weather_recommendation.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../domain/services/recommendation_engine.dart';
import '../../../../core/location/domain/location_state.dart';
import '../../../../core/location/presentation/location_provider.dart';

// ─── Proveedores de Dependencias Inferiores ────────────────────────

// Eliminado geoLocationServiceProvider local ya que ahora es central

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
    // Al observar el provider global, si cambia (ej. GPS a Manual), el clima se recargará automáticamente
    ref.watch(globalLocationProvider);

    ref.onDispose(() {
      _refreshTimer?.cancel();
    });

    _startAutoRefresh();

    return _fetchWeather();
  }

  Future<WeatherState> _fetchWeather() async {
    final repo = ref.read(weatherRepositoryProvider);
    final locationStateAsync = ref.read(globalLocationProvider);
    
    // Si la ubicación aún está cargando o en error, esperamos que resuelva
    if (locationStateAsync.isLoading || locationStateAsync.hasError) {
      throw Exception("Esperando ubicación...");
    }
    
    final locationState = locationStateAsync.value!;

    WeatherEntity weather;
    bool isFallback = locationState.isFallback;

    // ALERTA DE ARQUITECTURA: Mantiene integración nativa FastAPI
    // FastAPI se encarga de resolver la ciudad mediante query params manuales
    if (locationState.mode == LocationMode.manual && 
        locationState.manualCityName != null && 
        locationState.manualCityName!.isNotEmpty) {
      weather = await repo.getWeatherByCity(cityName: locationState.manualCityName!);
    } else {
      // 1. Coordenadas GPS (Fallback o Reales)
      weather = await repo.getWeather(
        latitude: locationState.latitude ?? 19.4326, // default safe lat
        longitude: locationState.longitude ?? -99.1332, // default safe lon
      );
    }

    // 2. Post-procesamiento: Generar recomendaciones de conducción
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

  /// Fuerza una recarga completa del estado desde la interfaz (Bypass caché).
  Future<void> refresh() async {
    state = const AsyncLoading();
    // Invalidamos explícitamente la memoria caché para forzar red
    await ref.read(weatherRepositoryProvider).clearCache();
    state = await AsyncValue.guard(() => _fetchWeather());
  }

  /// Establece una ciudad fija para el clima utilizando el LocationProvider global
  Future<void> setManualCity(String city) async {
    // 1. INVALIDACIÓN DE CACHÉ: 
    // Es crítico limpiar el repositorio al cambiar de modo, de lo contrario 
    // getWeather(lat, lon) retornaría la instancia 'fresh' de la ciudad manual consultada.
    await ref.read(weatherRepositoryProvider).clearCache();

    // 2. Transición de Estado Core
    if (city.trim().isEmpty) {
      await ref.read(globalLocationProvider.notifier).useGpsMode();
    } else {
      await ref.read(globalLocationProvider.notifier).useManualCity(city);
    }
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
