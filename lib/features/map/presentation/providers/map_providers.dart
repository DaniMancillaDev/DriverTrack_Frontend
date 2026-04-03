import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/map_location.dart';
import '../../../../providers/app_providers.dart';

// User GPS Location Provider
class UserLocationNotifier extends AsyncNotifier<LatLng?> {
  @override
  FutureOr<LatLng?> build() async {
    return null;
  }

  Future<void> fetchCurrentLocation() async {
    state = const AsyncLoading();
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = AsyncValue.error('Location services disabled.', StackTrace.current);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = AsyncValue.error('Location permissions denied.', StackTrace.current);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        state = AsyncValue.error('Location permissions are permanently denied.', StackTrace.current);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );
      state = AsyncData(LatLng(position.latitude, position.longitude));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final userLocationProvider = AsyncNotifierProvider<UserLocationNotifier, LatLng?>(() {
  return UserLocationNotifier();
});

// Filter & Search
class MapFilterNotifier extends Notifier<String> {
  @override
  String build() => 'all';

  void setFilter(String filter) => state = filter;
}
final mapFilterProvider = NotifierProvider<MapFilterNotifier, String>(MapFilterNotifier.new);

class MapSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setSearch(String search) => state = search;
}
final mapSearchProvider = NotifierProvider<MapSearchNotifier, String>(MapSearchNotifier.new);

class MapBoundsNotifier extends Notifier<LatLngBounds?> {
  @override
  LatLngBounds? build() => null;

  void setBounds(LatLngBounds? bounds) => state = bounds;
}
final mapBoundsProvider = NotifierProvider<MapBoundsNotifier, LatLngBounds?>(MapBoundsNotifier.new);

// Manual search trigger to force refresh in current area
class MapSearchTriggerNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void trigger() => state++;
}
final mapSearchTriggerProvider = NotifierProvider<MapSearchTriggerNotifier, int>(MapSearchTriggerNotifier.new);

// Nearby Locations
class NearbyLocationsNotifier extends AsyncNotifier<List<MapLocation>> {
  @override
  FutureOr<List<MapLocation>> build() async {
    final filter = ref.watch(mapFilterProvider);
    final search = ref.watch(mapSearchProvider);
    final repo = ref.watch(mapRepositoryProvider);
    
    // We watch the trigger to allow "Redo search in this area" 
    // without changing the filter or search text.
    final trigger = ref.watch(mapSearchTriggerProvider);
    
    // We READ bounds and userLoc instead of WATCHing them to prevent 
    // constant rebuilds/429 errors while dragging.
    final bounds = ref.read(mapBoundsProvider);
    final userLoc = ref.read(userLocationProvider).value;
    
    // If we have nothing to search for, stay quiet initially
    // UNLESS the user has explicitly triggered a search via the "Search here" button
    if (filter == 'all' && search.isEmpty && trigger == 0) {
      // However, we allow a small delay to see if bounds become available
      // but if the user hasn't explicitly triggered anything, return empty.
      // We will re-enable the 'all' sweep in GeocodingService so it works IF called.
      return [];
    }

    bool didDispose = false;
    ref.onDispose(() {
      didDispose = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));
    
    // If provider was disposed (user dragged map again), discard this lookup completely
    if (didDispose) {
      return state.value ?? [];
    }

    print('DEBUG: Requesting nearby locations with filter: $filter, search: $search, bounds: $bounds');
    
    final results = await repo.getNearbyLocations(
      type: filter, 
      search: search, 
      userLocation: userLoc, 
      bounds: bounds
    );
    
    print('DEBUG: Repository returned ${results.length} results.');
    
    // Deduplication pass: OSM often has the same amenity as node AND way/area
    // or slightly offset duplicate entries.
    final List<MapLocation> uniqueResults = [];
    const distanceCalc = Distance();
    
    for (var loc in results) {
      bool isDuplicate = false;
      for (var existing in uniqueResults) {
        // Only deduplicate within the same major category
        if (loc.type != existing.type) continue;

        final distBetween = distanceCalc.as(
          LengthUnit.Meter,
          LatLng(loc.latitude, loc.longitude),
          LatLng(existing.latitude, existing.longitude),
        );
        
        final name1 = loc.name.toLowerCase();
        final name2 = existing.name.toLowerCase();
        final isDefaultName = name1.contains('punto de') || name2.contains('punto de');

        // 1. "Physical Overlap" - If they are within 20m, they are the same place (node vs way)
        if (distBetween < 20) {
          isDuplicate = true;
          break;
        }

        // 2. "Logical Duplicate" - Same name/brand within 60m radius
        if (distBetween < 60) {
          if (name1 == name2 || name1.contains(name2) || name2.contains(name1) || isDefaultName) {
            isDuplicate = true;
            break;
          }
        }
      }
      
      if (!isDuplicate) {
        uniqueResults.add(loc);
      }
    }
    
    print('DEBUG: After deduplication: ${uniqueResults.length} unique results.');
    
    // Sort and calculate real distances if user location is available
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
        
        // We cast to access copyWith if it's the model, or use the entity copyWith
        return loc.copyWith(distance: distLabel);
      }).toList();
      
      // Sort by absolute distance in meters
      processedResults.sort((a, b) {
        final d1 = distanceCalc.as(LengthUnit.Meter, userLoc, LatLng(a.latitude, a.longitude));
        final d2 = distanceCalc.as(LengthUnit.Meter, userLoc, LatLng(b.latitude, b.longitude));
        return d1.compareTo(d2);
      });
      
      return processedResults.take(20).toList();
    }
    
    return uniqueResults.take(20).toList();
  }
}

final nearbyLocationsProvider = AsyncNotifierProvider<NearbyLocationsNotifier, List<MapLocation>>(() {
  return NearbyLocationsNotifier();
});

// Selected Location
class SelectedLocationNotifier extends Notifier<MapLocation?> {
  @override
  MapLocation? build() => null;

  void setLocation(MapLocation? location) => state = location;
}
final selectedLocationProvider = NotifierProvider<SelectedLocationNotifier, MapLocation?>(SelectedLocationNotifier.new);
