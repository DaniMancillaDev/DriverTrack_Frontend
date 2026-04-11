class AppConfig {
  final String baseUrl;
  final String appName;
  final String openWeatherApiKey;

  const AppConfig({
    required this.baseUrl,
    this.appName = 'DriveTrack',
    required this.openWeatherApiKey,
  });

  // Default configuration (Development)
  factory AppConfig.dev() {
    return const AppConfig(
      baseUrl: 'http://127.0.0.1:8000',
      openWeatherApiKey: String.fromEnvironment('OWM_API_KEY'),
    );
  }

  // Production configuration (Example)
  factory AppConfig.prod() {
    return const AppConfig(
      baseUrl: 'https://api.drivetrack.app', // Placeholder
      openWeatherApiKey: String.fromEnvironment('OWM_API_KEY'),
    );
  }
}
