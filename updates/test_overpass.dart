import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  String s = '19.4', w = '-99.2', n = '19.5', e = '-99.1';
  String bBoxStr = '$s,$w,$n,$e';
  
  String oqlQuery = 'node["amenity"="fuel"]($bBoxStr);';
  
  String overpassPayload = '''
  [out:json][timeout:15];
  (
    $oqlQuery
  );
  out center;
  ''';

  print('Sending payload: $overpassPayload');
  
  try {
    final response = await http.post(
      Uri.parse('https://overpass-api.de/api/interpreter'), 
      body: {'data': overpassPayload},
    );
    
    print('Status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Found: ${data['elements']?.length} elements');
    } else {
      print('Error body: ${response.body}');
    }
  } catch (e) {
    print('Exception: $e');
  }
}
