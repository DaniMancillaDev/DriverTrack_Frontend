import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import '../models/map_location_model.dart';
import '../../domain/entities/map_location.dart';

/// Servicio especializado en realizar consultas geográficas a OpenStreetMap mediante el motor Overpass.
/// 
/// Permite obtener infraestructuras automotrices (talleres, gasolineras) mediante
/// lenguaje de consulta OQL, aplicando una optimización de "bounding box" estricta.
class GeocodingService {
  /// Ejecuta una búsqueda de lugares basada en una consulta textual y parámetros espaciales.
  /// 
  /// Soporta filtrado por [type] ('gasstation', 'workshop') y búsqueda reactiva
  /// según los [bounds] visibles del mapa o la ubicación actual del usuario.
  /// Retorna una lista de [MapLocation] inyectando metadatos de OSM (tags).
  Future<List<MapLocation>> searchAddress(
    String query, {
    LatLngBounds? bounds,
    LatLng? userLocation,
    String? type,
  }) async {
    // Determinar la caja de límites (Bounding Box) priorizando los límites del mapa (Bounds),
    // con un fallback de ~15km alrededor del usuario.
    String s = '', n = '', w = '', e = '';

    if (bounds != null) {
      s = bounds.south.toString();
      n = bounds.north.toString();
      w = bounds.west.toString();
      e = bounds.east.toString();
    } else if (userLocation != null) {
      s = (userLocation.latitude - 0.05).toString();
      n = (userLocation.latitude + 0.05).toString();
      w = (userLocation.longitude - 0.05).toString();
      e = (userLocation.longitude + 0.05).toString();
    } else {
      // Evitar búsquedas globales accidentales retornando lista vacía.
      return [];
    }

    String bBoxStr = '$s,$w,$n,$e'; // Formato Overpass: sur, oeste, norte, este

    // Determinar la consulta Overpass OQL (Overpass Query Language)
    String oqlQuery = '';
    String nameFilter = query.isNotEmpty ? '["name"~"$query",i]' : '';

    if (type == 'gasstation') {
      oqlQuery = 'nwr["amenity"="fuel"]$nameFilter($bBoxStr);';
      if (query.isNotEmpty) oqlQuery += 'nwr["brand"~"$query",i]["amenity"="fuel"]($bBoxStr);';
    } else if (type == 'workshop') {
      // Combina talleres mecánicos, de motos y pintura en una sola pasada al servidor.
      oqlQuery = 'nwr["shop"~"car_repair|motorcycle_repair"]$nameFilter($bBoxStr);';
      oqlQuery += 'nwr["craft"="car_painter"]$nameFilter($bBoxStr);';
    } else if (type == 'all' && query.isEmpty) {
      // Barrido exploratorio general de POIs automotrices.
      oqlQuery = 'nwr["amenity"="fuel"]($bBoxStr);';
      oqlQuery += 'nwr["shop"~"car_repair|motorcycle_repair"]($bBoxStr);';
      oqlQuery += 'nwr["craft"="car_painter"]($bBoxStr);';
    } else if (query.isNotEmpty) {
      // Búsqueda cruzada por nombre, marca o tipo de establecimiento.
      oqlQuery = 'nwr["amenity"="fuel"]$nameFilter($bBoxStr);';
      oqlQuery += 'nwr["shop"~"car_repair|motorcycle_repair"]$nameFilter($bBoxStr);';
      oqlQuery += 'nwr["craft"="car_painter"]$nameFilter($bBoxStr);';
      oqlQuery += 'nwr["name"~"$query",i]($bBoxStr);';
      oqlQuery += 'nwr["brand"~"$query",i]($bBoxStr);';
    } else {
      return [];
    }

    String overpassPayload =
        '''
    [out:json][timeout:15];
    (
      $oqlQuery
    );
    out center;
    ''';

    try {
      // Se utiliza el mirror de lz4 (aprovecha mayor cuota y velocidad).
      final response = await http
          .post(
            Uri.parse('https://lz4.overpass-api.de/api/interpreter'),
            body: {'data': overpassPayload},
          )
          .timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List elements = data['elements'] ?? [];

        return elements.take(25).map((json) {
          final tags = json['tags'] ?? {};

          // Mapeo inverso de etiquetas OSM al sistema DriverTrack
          String mappedType = type ?? 'all';
          if (tags['amenity'] == 'fuel')
            mappedType = 'gasstation';
          else if (tags['shop'] == 'car_repair' ||
              tags['shop'] == 'motorcycle_repair')
            mappedType = 'workshop';

          final nameRaw = tags['name']?.toString() ?? '';
          final displayNameRaw =
              tags['brand']?.toString() ?? 'Punto de Interés';

          // Manejo de nodos vs vías/relaciones (usan 'center' para posición única)
          double lat = (json['lat'] ?? json['center']?['lat'] ?? 0.0) * 1.0;
          double lon = (json['lon'] ?? json['center']?['lon'] ?? 0.0) * 1.0;

          return MapLocationModel(
            id: json['id'].toString(),
            name: nameRaw.isNotEmpty ? nameRaw : displayNameRaw,
            type: mappedType,
            address:
                tags['addr:street']?.toString() ??
                'Sin dirección exacta registrada',
            rating:
                4.0, // Calificación por defecto (OSM no incluye ratings de Google naturalmente)
            reviews: 1,
            distance: '',
            open: true,
            hours:
                tags['opening_hours']?.toString() ?? 'Horario no especificado',
            phone: tags['phone']?.toString() ?? '',
            latitude: lat,
            longitude: lon,
            priceLevel: '\$\$',
          );
        }).toList();
      } else {
        throw Exception('Error del servidor Overpass: ${response.statusCode}');
      }
    } catch (e) {
      // Se propaga el error para que Riverpod (AsyncValue) pueda manejarlo en la UI.
      rethrow; 
    }
  }
}
