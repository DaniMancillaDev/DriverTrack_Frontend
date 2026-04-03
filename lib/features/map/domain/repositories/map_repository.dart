import '../entities/map_location.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

abstract class MapRepository {
  Future<List<MapLocation>> getNearbyLocations({String? type, String? search, LatLng? userLocation, LatLngBounds? bounds});
}
