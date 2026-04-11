class AppConfig {
  final String baseUrl;
  final String appName;

  const AppConfig({
    required this.baseUrl,
    this.appName = 'DriveTrack',
  });

  // Default configuration (Development)
  factory AppConfig.dev() {
    return const AppConfig(
      baseUrl: 'http://127.0.0.1:8000',
    );
  }

  // Production configuration (Example)
  factory AppConfig.prod() {
    return const AppConfig(
      baseUrl: 'https://api.drivetrack.app', // Placeholder
    );
  }
}
