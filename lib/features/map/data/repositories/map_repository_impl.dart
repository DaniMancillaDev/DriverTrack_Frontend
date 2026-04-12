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

    // Término de búsqueda solo desde la barra — NO inyectar queries falsas para los filtros.
    // El parámetro type por sí solo es suficiente para que GeocodingService construya
    // las consultas Overpass OQL correctas. Antes, inyectar 'taller mecanico'/'gasolinera'
    // agregaba un filtro de nombre restrictivo que excluía la mayoría de lugares reales
    // (raramente tienen ese texto exacto en su nombre OSM).
    String query = search?.trim() ?? '';

    // Solo buscar cuando hay un disparador explícito (filtro, texto de búsqueda, o barrido 'all')
    if (query.isNotEmpty || type == 'all' || type == 'workshop' || type == 'gasstation') {
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
