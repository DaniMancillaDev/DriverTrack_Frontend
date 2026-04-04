import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/map_location.dart';
import '../../domain/repositories/map_repository.dart';
import '../models/map_location_model.dart';
import '../../../../services/api_client.dart';
import '../services/geocoding_service.dart';

class MapRepositoryImpl implements MapRepository {
  final ApiClient apiClient;
  final GeocodingService _geocodingService = GeocodingService();

  MapRepositoryImpl(this.apiClient);

  @override
  Future<List<MapLocation>> getNearbyLocations({
    String? type,
    String? search,
    LatLng? userLocation,
    LatLngBounds? bounds,
  }) async {
    List<MapLocation> geoResults = [];

    // Determine the exact query term to send to the real Nominatim OSM search
    String query = search?.trim() ?? '';

    // If no search text is written, but they tapped a filter pill, auto-generate real places for that category
    if (query.isEmpty) {
      if (type == 'workshop')
        query = 'taller mecanico';
      else if (type == 'gasstation')
        query = 'gasolinera';
    }

    // Fetch dynamically based on what the user searched, passing Map Bounds to enforce Geospatial strictness!
    if (query.isNotEmpty ||
        type == 'all' ||
        type == 'workshop' ||
        type == 'gasstation') {
      geoResults = await _geocodingService.searchAddress(
        query,
        bounds: bounds,
        userLocation: userLocation,
        type: type,
      );
    }

    return geoResults;
  }
}
