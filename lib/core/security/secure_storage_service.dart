/// Servicio de almacenamiento seguro para datos sensibles.
///
/// Utiliza [FlutterSecureStorage] para persistir información como tokens JWT
/// de forma encriptada en el dispositivo (Keystore en Android, Keychain en iOS).
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

/// Proveedor para el token de acceso inicial (leído al arranque de la app).
/// Este valor suele ser sobrescrito en el `main.dart` tras la lectura de storage.
final initialAccessTokenProvider = Provider<String?>((ref) => null);

/// Proveedor para el token de refresco inicial (leído al arranque de la app).
final initialRefreshTokenProvider = Provider<String?>((ref) => null);
