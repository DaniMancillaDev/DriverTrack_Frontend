import '../entities/map_location.dart';
import '../repositories/map_repository.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Caso de Uso: Recupera puntos de interés cercanos a la posición del usuario.
/// 
/// Orquesta la llamada al repositorio de mapas aplicando lógica de filtrado 
/// opcional por tipo de servicio (ej: 'taller', 'gasolinera').
class GetNearbyLocations {
  final MapRepository repository;

  GetNearbyLocations(this.repository);

  /// Ejecuta la búsqueda de ubicaciones.
  /// 
  /// Retorna una lista de [MapLocation] que cumplen con los criterios de 
  /// categoría ([type]) y proximidad geográfica.
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
