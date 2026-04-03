/// Servicio de geolocalización.
///
/// Encapsula la lógica de permisos y obtención de ubicación.
/// Provee coordenadas de fallback si el usuario deniega permisos.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// Resultado de ubicación.
class LocationResult {
  final double latitude;
  final double longitude;
  final bool isFallback;

  const LocationResult({
    required this.latitude,
    required this.longitude,
    this.isFallback = false,
  });
}

/// Servicio que obtiene la ubicación del dispositivo.
class GeoLocationService {
  const GeoLocationService();

  /// Coordenadas de fallback (Ciudad de México).
  static const _fallbackLat = 19.4326;
  static const _fallbackLon = -99.1332;

  /// Obtiene la ubicación actual del usuario.
  ///
  /// Maneja el flujo completo de permisos:
  /// 1. Verifica si el servicio de ubicación está habilitado
  /// 2. Solicita permisos si no los tiene
  /// 3. Retorna fallback si el usuario deniega
  Future<LocationResult> getCurrentLocation() async {
    try {
      // 1. Verificar permisos primero
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return _fallback();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return _fallback();
      }

      // 2. Verificar si el servicio de ubicación (GPS) está habilitado
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return _fallback();
      }

      // Obtener posición actual
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high, // Alta precisión para dispositivos físicos
          timeLimit: Duration(seconds: 20), // Mayor tiempo de espera para el GPS
        ),
      );

      return LocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      debugPrint('Error del GPS: $e. Intentando localizar por WiFi/IP...');
      return _getLocationFromIP();
    }
  }

  /// Intenta obtener la ubicación usando un servicio por IP (muy rápido en interiores)
  Future<LocationResult> _getLocationFromIP() async {
    try {
      final response = await http
          .get(Uri.parse('http://ip-api.com/json/'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final lat = (data['lat'] as num).toDouble();
        final lon = (data['lon'] as num).toDouble();
        debugPrint('Geolocalización por IP exitosa: Lat $lat, Lon $lon');
        return LocationResult(latitude: lat, longitude: lon, isFallback: true);
      }
      return _fallback();
    } catch (e) {
      debugPrint('Fallo en geolocalización por IP: $e');
      return _fallback();
    }
  }

  /// Retorna la ubicación de fallback.
  LocationResult _fallback() {
    return const LocationResult(
      latitude: _fallbackLat,
      longitude: _fallbackLon,
      isFallback: true,
    );
  }
}
