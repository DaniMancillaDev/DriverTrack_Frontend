import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import '../models/map_location_model.dart';
import '../../domain/entities/map_location.dart';

class GeocodingService {
  Future<List<MapLocation>> searchAddress(
    String query, {
    LatLngBounds? bounds,
    LatLng? userLocation,
    String? type,
  }) async {
    // Determine the boundary box prioritizing Map Bounds, falling back to an approximate 15km bounding box around user location
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
      // Very strict fallback if neither are ready, won't search the whole planet.
      return [];
    }

    String bBoxStr = '$s,$w,$n,$e'; // Overpass bBox is south,west,north,east

    // Determine the Overpass query
    String oqlQuery = '';
    String nameFilter = query.isNotEmpty ? '["name"~"$query",i]' : '';

    if (type == 'gasstation') {
      oqlQuery = 'nwr["amenity"="fuel"]$nameFilter($bBoxStr);';
      if (query.isNotEmpty) oqlQuery += 'nwr["brand"~"$query",i]["amenity"="fuel"]($bBoxStr);';
    } else if (type == 'workshop') {
      // Use regex in the key value to combine multiple lookups into one server pass
      oqlQuery = 'nwr["shop"~"car_repair|motorcycle_repair"]$nameFilter($bBoxStr);';
      oqlQuery += 'nwr["craft"="car_painter"]$nameFilter($bBoxStr);';
    } else if (type == 'all' && query.isEmpty) {
      // General map exploratory sweep - combined for efficiency
      oqlQuery = 'nwr["amenity"="fuel"]($bBoxStr);';
      oqlQuery += 'nwr["shop"~"car_repair|motorcycle_repair"]($bBoxStr);';
      oqlQuery += 'nwr["craft"="car_painter"]($bBoxStr);';
    } else if (query.isNotEmpty) {
      // Search across name, brand, or amenity types for automotive-related entities
      oqlQuery = 'nwr["amenity"="fuel"]$nameFilter($bBoxStr);';
      oqlQuery += 'nwr["shop"~"car_repair|motorcycle_repair"]$nameFilter($bBoxStr);';
      oqlQuery += 'nwr["craft"="car_painter"]$nameFilter($bBoxStr);';
      // Also allow pure name/brand matches if they didn't fall into the strict tags
      oqlQuery += 'nwr["name"~"$query",i]($bBoxStr);';
      oqlQuery += 'nwr["brand"~"$query",i]($bBoxStr);';
    } else {
      // Nothing selected and no query? Avoid server load.
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

    print('DEBUG: Sending Overpass OQL (lz4 mirror): \n$overpassPayload');

    try {
      // Switching to lz4 mirror which is typically faster/higher quota than the main .de one
      final response = await http
          .post(
            Uri.parse('https://lz4.overpass-api.de/api/interpreter'),
            body: {'data': overpassPayload},
          )
          .timeout(const Duration(seconds: 12));

      print('DEBUG: Overpass Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List elements = data['elements'] ?? [];

        print('DEBUG: Overpass returned ${elements.length} elements.');

        return elements.take(25).map((json) {
          final tags = json['tags'] ?? {};

          // Map correctly back to app filters
          String mappedType = type ?? 'all';
          if (tags['amenity'] == 'fuel')
            mappedType = 'gasstation';
          else if (tags['shop'] == 'car_repair' ||
              tags['shop'] == 'motorcycle_repair')
            mappedType = 'workshop';

          final nameRaw = tags['name']?.toString() ?? '';
          final displayNameRaw =
              tags['brand']?.toString() ?? 'Punto de Interés';

          // For node types, coordinates are flat. For ways/relations, they are in 'center'
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
                4.0, // Default mock rating since OSM doesn't hold Google Ratings naturally
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
        print('DEBUG: Overpass Error Body: ${response.body}');
        throw Exception('Overpass Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Overpass query error: $e');
      rethrow; // Ensure AsyncValue is notified
    }
    return [];
  }
}
