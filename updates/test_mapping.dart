import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  String type = 'gasstation';
  String query = '';
  
  // Simulated bounding box around Mexico
  String s = '19.4', n = '19.5', w = '-99.2', e = '-99.1';
  String bBoxStr = '$s,$w,$n,$e';

  String oqlQuery = '';
  if (type == 'gasstation') {
    oqlQuery = 'node["amenity"="fuel"]($bBoxStr);';
  } else if (type == 'workshop') {
    oqlQuery = '''
    node["shop"="car_repair"]($bBoxStr);
    node["shop"="motorcycle_repair"]($bBoxStr);
    node["craft"="car_painter"]($bBoxStr);
    ''';
  } else if (query.isNotEmpty) {
    oqlQuery = '''
    node["name"~"${query}",i]($bBoxStr);
    ''';
  } else {
    print('Empty returning early');
    return;
  }

  String overpassPayload = '''
  [out:json][timeout:15];
  (
    $oqlQuery
  );
  out center;
  ''';

  print('Payload:\\n$overpassPayload');

  try {
    final response = await http.post(
      Uri.parse('https://overpass-api.de/api/interpreter'), 
      body: {'data': overpassPayload},
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List elements = data['elements'] ?? [];
      print('Elements returned: ${elements.length}');
      
      var models = elements.map((json) {
        final tags = json['tags'] ?? {};
        String mappedType = type;
        if (tags['amenity'] == 'fuel') mappedType = 'gasstation';
        else if (tags['shop'] == 'car_repair' || tags['shop'] == 'motorcycle_repair') mappedType = 'workshop';

        final nameRaw = tags['name']?.toString() ?? '';
        final displayNameRaw = tags['brand']?.toString() ?? 'Punto de Interés';
        
        return {
          'id': json['id'].toString(),
          'name': nameRaw.isNotEmpty ? nameRaw : displayNameRaw,
          'type': mappedType,
          'lat': (json['lat'] ?? 0.0) * 1.0,
          'lon': (json['lon'] ?? 0.0) * 1.0,
        };
      }).toList();
      
      if (models.isNotEmpty) {
        print('First mapping: ${models.first}');
      } else {
        print('Models empty after mapping');
      }
    } else {
      print('HTTP error: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
