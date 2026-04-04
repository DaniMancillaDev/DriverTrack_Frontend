import '../entities/map_location.dart';
import '../repositories/map_repository.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class GetNearbyLocations {
  final MapRepository repository;

  GetNearbyLocations(this.repository);

  Future<List<MapLocation>> execute({
    String? type,
    String? search,
    LatLng? userLocation,
    LatLngBounds? bounds,
  }) {
    return repository.getNearbyLocations(
      type: type,
      search: search,
      userLocation: userLocation,
      bounds: bounds,
    );
  }
}
