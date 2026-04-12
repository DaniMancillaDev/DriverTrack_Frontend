enum LocationMode { gps, manual }

class AppLocationState {
  final LocationMode mode;
  final double? latitude;
  final double? longitude;
  final String? manualCityName;
  final DateTime lastUpdated;
  final bool isFallback;

  const AppLocationState({
    required this.mode,
    this.latitude,
    this.longitude,
    this.manualCityName,
    required this.lastUpdated,
    this.isFallback = false,
  });

  factory AppLocationState.gps({
    required double latitude,
    required double longitude,
    bool isFallback = false,
  }) {
    return AppLocationState(
      mode: LocationMode.gps,
      latitude: latitude,
      longitude: longitude,
      lastUpdated: DateTime.now(),
      isFallback: isFallback,
    );
  }

  factory AppLocationState.manual({
    required String cityName,
  }) {
    return AppLocationState(
      mode: LocationMode.manual,
      manualCityName: cityName,
      lastUpdated: DateTime.now(),
    );
  }

  factory AppLocationState.loading() {
    return AppLocationState(
      mode: LocationMode.gps, // por defecto
      lastUpdated: DateTime.now(),
    );
  }
}
