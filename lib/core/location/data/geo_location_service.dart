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

  /// Verifica y solicita permisos, asegurando que el servicio GPS esté encendido.
  Future<bool> _ensurePermissions() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Permiso de GPS denegado por el usuario.');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Permiso de GPS denegado permanentemente.');
      return false;
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('El servicio de GPS está desactivado en el dispositivo.');
      return false;
    }

    return true;
  }

  /// Obtiene una ubicación rápida (Caché o Precisión Media con timeout corto).
  /// Útil para responder rápidamente a la UI sin bloquear.
  Future<LocationResult?> getQuickLocation() async {
    try {
      final hasPermission = await _ensurePermissions();
      if (!hasPermission) return null;

      // 1. Intentar la última conocida (Casi instantáneo)
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        debugPrint('Geolocalización: Obtenida getLastKnownPosition rápida');
        return LocationResult(
          latitude: lastKnown.latitude,
          longitude: lastKnown.longitude,
        );
      }

      // 2. Si no hay caché, intentar leer el GPS con precisión media y timeout corto
      debugPrint('Geolocalización: Solicitando posición rápida (Medium, 3s timeout)');
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 3),
        ),
      );

      return LocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      debugPrint('Geolocalización rápida falló: $e');
      return null;
    }
  }

  /// Obtiene la ubicación actual del usuario.
  /// 
  /// Utiliza alta precisión si [highAccuracy] es true.
  Future<LocationResult> getCurrentLocation({bool highAccuracy = true}) async {
    try {
      final hasPermission = await _ensurePermissions();
      if (!hasPermission) {
        return _getLocationFromIP();
      }

      final accuracy = highAccuracy ? LocationAccuracy.high : LocationAccuracy.medium;
      final timeLimit = highAccuracy ? const Duration(seconds: 15) : const Duration(seconds: 8);

      debugPrint('Geolocalización: Solicitando precisa (Accuracy: $accuracy, Timeout: ${timeLimit.inSeconds}s)');
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: accuracy,
          timeLimit: timeLimit,
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
