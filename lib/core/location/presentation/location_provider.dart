import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/location_state.dart';
import '../data/geo_location_service.dart';
import '../../../core/units/presentation/unit_system_provider.dart' show sharedPreferencesProvider;

/// Punto de acceso al servicio de geolocalización.
final geoLocationServiceProvider = Provider<GeoLocationService>((ref) {
  return const GeoLocationService();
});

class LocationNotifier extends AsyncNotifier<AppLocationState> {
  @override
  Future<AppLocationState> build() async {
    return _fetchState();
  }

  Future<AppLocationState> _fetchState() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final geoService = ref.read(geoLocationServiceProvider);
    
    // Validar si existe ciudad manual en caché global
    final manualCity = prefs.getString('global_manual_city');
    if (manualCity != null && manualCity.trim().isNotEmpty) {
      return AppLocationState.manual(cityName: manualCity);
    }

    // Por defecto modo GPS con estrategia rápida
    final loc = await geoService.getCurrentLocation(highAccuracy: false);
    
    // Disparamos una mejora silenciosa en background
    _fetchPreciseGpsBackground(geoService);

    return AppLocationState.gps(
      latitude: loc.latitude,
      longitude: loc.longitude,
      isFallback: loc.isFallback,
    );
  }

  /// Refresca forzosamente la ubicación actual según el modo actual.
  /// Soluciona el bug de caché forzando al hardware a buscar de nuevo.
  Future<void> refreshLocation() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchState());
  }

  /// Obliga a regresar al modo GPS e invoca directamente una lectura fresca.
  /// Limpia cualquier caché de ciudad manual e implementa respuesta híbrida.
  Future<void> useGpsMode() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove('global_manual_city');
    
    final geoService = ref.read(geoLocationServiceProvider);

    // Intentamos obtener una ubicación aproxima o la última conocida en hardware.
    // Esto previene que la UI se bloquee 15 segundos esperando un fix preciso.
    final quickResult = await geoService.getQuickLocation();
    
    if (quickResult != null) {
      state = AsyncData(AppLocationState.gps(
        latitude: quickResult.latitude,
        longitude: quickResult.longitude,
        isFallback: quickResult.isFallback,
      ));
      
      // Disparamos background update con alta precisión para ajustar el mapa segundos después
      _fetchPreciseGpsBackground(geoService);
      return; 
    }

    // Fallback si no hubo respuesta rápida (bloqueante, espera a la precisa)
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final loc = await geoService.getCurrentLocation(highAccuracy: true);
      return AppLocationState.gps(
        latitude: loc.latitude,
        longitude: loc.longitude,
        isFallback: loc.isFallback,
      );
    });
  }

  /// Pide una ubicación de alta precisión en background y si sigue en modo GPS
  /// actualiza el estado sin interrumpir la experiencia.
  Future<void> _fetchPreciseGpsBackground(GeoLocationService geoService) async {
    try {
      final loc = await geoService.getCurrentLocation(highAccuracy: true);
      
      // Solo actualizamos el estado si seguimos en modo GPS (el usuario no cambió a manual)
      final currentState = state.value;
      if (currentState != null && currentState.mode == LocationMode.gps) {
        state = AsyncData(AppLocationState.gps(
          latitude: loc.latitude,
          longitude: loc.longitude,
          isFallback: loc.isFallback,
        ));
      }
    } catch (_) {
      // Ignorar silenciosamente si la precisa falla, la rápida ya sirvió.
    }
  }

  /// Establece el modo manual por string para integraciones externas (FastAPI).
  Future<void> useManualCity(String city) async {
    final prefs = ref.read(sharedPreferencesProvider);
    if (city.trim().isEmpty) {
      await useGpsMode();
      return;
    }
    
    state = const AsyncLoading();
    await prefs.setString('global_manual_city', city);
    state = AsyncData(AppLocationState.manual(cityName: city));
  }
}

final globalLocationProvider = AsyncNotifierProvider<LocationNotifier, AppLocationState>(
  () => LocationNotifier(),
);
