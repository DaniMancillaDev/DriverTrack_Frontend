import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/map_location.dart';
import '../../domain/repositories/map_repository.dart';
import '../models/map_location_model.dart';
import '../../../../core/network/api_client.dart';
import '../services/geocoding_service.dart';

/// Implementación del repositorio de mapas.
/// 
/// Encapsula el acceso al [GeocodingService] para proporcionar una interfaz
/// limpia al dominio, manejando la transformación de términos de búsqueda
/// genéricos en consultas geográficas específicas.
/// 
/// Esta clase actúa como orquestador entre la capa de datos y el dominio,
/// aplicando estrategias de filtrado espacial mediante el uso de [LatLngBounds]
/// para limitar las consultas a la vista actual del mapa, reduciendo la carga
/// de red y mejorando la relevancia de los resultados.
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
    // La lógica de búsqueda utiliza el bounding box (bounds) para restringir los resultados
    // a la región visible, optimizando el rendimiento de las consultas Overpass OQL.
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
