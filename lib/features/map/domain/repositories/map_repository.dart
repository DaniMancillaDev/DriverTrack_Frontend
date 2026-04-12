import '../entities/map_location.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

/// Contrato para la gestión de datos geográficos y puntos de interés.
/// 
/// Define las operaciones necesarias para localizar servicios automotrices 
/// cercanos al usuario basándose en coordenadas y límites del mapa.
abstract class MapRepository {
  /// Obtiene una lista de puntos de interés filtrados por tipo o búsqueda.
  /// 
  /// Permite especificar la ubicación del usuario ([userLocation]) y los 
  /// límites visuales del mapa ([bounds]) para optimizar la relevancia.
  Future<List<MapLocation>> getNearbyLocations({
    String? type,
    String? search,
    LatLng? userLocation,
    LatLngBounds? bounds,
  });
}
