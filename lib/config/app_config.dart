/// Orquestador central de la configuración del entorno de la aplicación.
/// 
/// Permite conmutar entre distintos ambientes (Desarrollo, Producción) 
/// centralizando las URLs de API y otras constantes de comportamiento global.
class AppConfig {
  /// URL base para las peticiones al backend de DriverTrack.
  final String baseUrl;
  /// Nombre oficial de la aplicación.
  final String appName;

  const AppConfig({
    required this.baseUrl,
    this.appName = 'DriveTrack',
  });

  /// Configuración para el entorno de desarrollo (FastAPI local).
  factory AppConfig.dev() {
    return const AppConfig(
      baseUrl: 'http://localhost:8000',
    );
  }

  /// Configuración para el entorno de producción.
  factory AppConfig.prod() {
    return const AppConfig(
      baseUrl: 'https://drivertrack.mikecardona076.com',
    );
  }
}
