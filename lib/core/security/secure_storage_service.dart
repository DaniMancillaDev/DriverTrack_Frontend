/// Bóveda de seguridad para el almacenamiento de secretos y tokens.
///
/// Su responsabilidad es encapsular la lógica de persistencia encriptada, 
/// utilizando [FlutterSecureStorage] para interactuar con los sistemas nativos 
/// Keystore (Android) y Keychain (iOS).
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

/// Orquestador de hidratación inicial para el token de acceso.
/// Normalmente se inyecta su valor real durante el arranque de la app en main.dart.
final initialAccessTokenProvider = Provider<String?>((ref) => null);

/// Orquestador de hidratación inicial para el token de refresco.
final initialRefreshTokenProvider = Provider<String?>((ref) => null);
