import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../domain/entities/map_location.dart';
import '../../../../providers/app_providers.dart';

import '../../../../core/location/presentation/location_provider.dart';

// Proveedor de ubicación GPS del usuario
class UserLocationNotifier extends AsyncNotifier<LatLng?> {
  @override
  FutureOr<LatLng?> build() async {
    // Esto asegura que el mapa reacciona a los cambios globales de ubicación (ej. desde el clima)
    final locationStateAsync = ref.watch(globalLocationProvider);
    
    return locationStateAsync.when(
      data: (state) {
        if (state.latitude != null && state.longitude != null) {
          return LatLng(state.latitude!, state.longitude!);
        }
        return null; // Si está en modo Manual puro por string, no sabemos la coords del mapa aún.
      },
      loading: () => null,
      error: (_, __) => null,
    );
  }

  /// Limpia forzosamente cualquier caché manual y exige lectura fresca del GPS
  Future<void> fetchCurrentLocation() async {
    state = const AsyncLoading();
    try {
      // Obligamos al estado global a restaurar modo GPS y leer nueva lat/lon
      await ref.read(globalLocationProvider.notifier).useGpsMode();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final userLocationProvider =
    AsyncNotifierProvider<UserLocationNotifier, LatLng?>(() {
      return UserLocationNotifier();
    });

// Filtros y búsqueda
class MapFilterNotifier extends Notifier<String> {
  @override
  String build() => 'all';

  void setFilter(String filter) => state = filter;
}

final mapFilterProvider = NotifierProvider<MapFilterNotifier, String>(
  MapFilterNotifier.new,
);

class MapSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setSearch(String search) => state = search;
}

final mapSearchProvider = NotifierProvider<MapSearchNotifier, String>(
  MapSearchNotifier.new,
);

class MapBoundsNotifier extends Notifier<LatLngBounds?> {
  @override
  LatLngBounds? build() => null;

  void setBounds(LatLngBounds? bounds) => state = bounds;
}

final mapBoundsProvider = NotifierProvider<MapBoundsNotifier, LatLngBounds?>(
  MapBoundsNotifier.new,
);

// Disparador manual de búsqueda para forzar refresco en el área actual
class MapSearchTriggerNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void trigger() => state++;
}

final mapSearchTriggerProvider =
    NotifierProvider<MapSearchTriggerNotifier, int>(
      MapSearchTriggerNotifier.new,
    );

// Ubicaciones cercanas
class NearbyLocationsNotifier extends AsyncNotifier<List<MapLocation>> {
  @override
  FutureOr<List<MapLocation>> build() async {
    final filter = ref.watch(mapFilterProvider);
    final search = ref.watch(mapSearchProvider);
    final repo = ref.watch(mapRepositoryProvider);

    // Se observa el trigger para permitir "Buscar en esta área"
    // sin cambiar el filtro ni el texto de búsqueda.
    final trigger = ref.watch(mapSearchTriggerProvider);

    // Se READ bounds y userLoc en vez de WATCH para evitar
    // rebuilds constantes y errores 429 al arrastrar el mapa.
    // Nota: bounds se lee de nuevo DESPUÉS del debounce para obtener la posición más fresca.
    final userLoc = ref.read(userLocationProvider).value;

    // Si no hay nada que buscar, mantener silencio inicialmente
    // A MENOS que el usuario haya disparado explícitamente una búsqueda vía "Buscar aquí"
    if (filter == 'all' && search.isEmpty && trigger == 0) {
      // Sin embargo, permitimos un pequeño delay por si bounds se vuelve disponible
      // pero si el usuario no disparó nada explícitamente, retornar vacío.
      // Se re-habilita el barrido 'all' en GeocodingService para que funcione SI se llama.
      return [];
    }

    bool didDispose = false;
    ref.onDispose(() {
      didDispose = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    // Si el provider fue disposed (el usuario arrastró el mapa de nuevo), descartar esta búsqueda
    if (didDispose) {
      return state.value ?? [];
    }

    // Re-leer bounds DESPUÉS del debounce para obtener la posición más fresca del mapa,
    // no la posición de hace 800ms cuando build() inició.
    final bounds = ref.read(mapBoundsProvider);

    print(
      'DEBUG: Requesting nearby locations with filter: $filter, search: $search, bounds: $bounds',
    );

    final results = await repo.getNearbyLocations(
      type: filter,
      search: search,
      userLocation: userLoc,
      bounds: bounds,
    );

    print('DEBUG: Repository returned ${results.length} results.');

    // Pase de deduplicación: OSM a menudo tiene la misma amenidad como nodo Y way/area
    // o entradas duplicadas con ligero desplazamiento.
    final List<MapLocation> uniqueResults = [];
    const distanceCalc = Distance();

    for (var loc in results) {
      bool isDuplicate = false;
      for (var existing in uniqueResults) {
        // Solo deduplicar dentro de la misma categoría principal
        if (loc.type != existing.type) continue;

        final distBetween = distanceCalc.as(
          LengthUnit.Meter,
          LatLng(loc.latitude, loc.longitude),
          LatLng(existing.latitude, existing.longitude),
        );

        final name1 = loc.name.toLowerCase();
        final name2 = existing.name.toLowerCase();
        final isDefaultName =
            name1.contains('punto de') || name2.contains('punto de');

        // 1. "Solapamiento físico" - Si están a menos de 20m, son el mismo lugar (nodo vs way)
        if (distBetween < 20) {
          isDuplicate = true;
          break;
        }

        // 2. "Duplicado lógico" - Mismo nombre/marca en radio de 60m
        if (distBetween < 60) {
          if (name1 == name2 ||
              name1.contains(name2) ||
              name2.contains(name1) ||
              isDefaultName) {
            isDuplicate = true;
            break;
          }
        }
      }

      if (!isDuplicate) {
        uniqueResults.add(loc);
      }
    }

    print(
      'DEBUG: After deduplication: ${uniqueResults.length} unique results.',
    );

    // Ordenar y calcular distancias reales si la ubicación del usuario está disponible
    if (userLoc != null && uniqueResults.isNotEmpty) {
      final processedResults = uniqueResults.map((loc) {
        final distMeters = distanceCalc.as(
          LengthUnit.Meter,
          userLoc,
          LatLng(loc.latitude, loc.longitude),
        );

        String distLabel;
        if (distMeters < 1000) {
          distLabel = '${distMeters.round()} m';
        } else {
          distLabel = '${(distMeters / 1000).toStringAsFixed(1)} km';
        }

        // Se hace cast para acceder a copyWith si es el model, o usar el copyWith de la entidad
        return loc.copyWith(distance: distLabel);
      }).toList();

      // Ordenar por distancia absoluta en metros
      processedResults.sort((a, b) {
        final d1 = distanceCalc.as(
          LengthUnit.Meter,
          userLoc,
          LatLng(a.latitude, a.longitude),
        );
        final d2 = distanceCalc.as(
          LengthUnit.Meter,
          userLoc,
          LatLng(b.latitude, b.longitude),
        );
        return d1.compareTo(d2);
      });

      return processedResults.take(20).toList();
    }

    return uniqueResults.take(20).toList();
  }
}

final nearbyLocationsProvider =
    AsyncNotifierProvider<NearbyLocationsNotifier, List<MapLocation>>(() {
      return NearbyLocationsNotifier();
    });

// Ubicación seleccionada
class SelectedLocationNotifier extends Notifier<MapLocation?> {
  @override
  MapLocation? build() => null;

  void setLocation(MapLocation? location) => state = location;
}

final selectedLocationProvider =
    NotifierProvider<SelectedLocationNotifier, MapLocation?>(
      SelectedLocationNotifier.new,
    );
