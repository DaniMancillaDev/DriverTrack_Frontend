/// Entidad de dominio para datos climáticos.
///
/// Todos los valores se almacenan en unidades métricas (°C, m/s).
/// La conversión a imperial se realiza en la capa de presentación
/// mediante el UnitFormatter existente.

/// Condiciones climáticas soportadas.
enum WeatherCondition {
  clear,
  clouds,
  rain,
  drizzle,
  thunderstorm,
  snow,
  fog,
  extreme,
  unknown;

  /// Convierte el código OWM `main` field al enum.
  static WeatherCondition fromOwmMain(String main) {
    return switch (main.toLowerCase()) {
      'clear' => WeatherCondition.clear,
      'clouds' => WeatherCondition.clouds,
      'rain' => WeatherCondition.rain,
      'drizzle' => WeatherCondition.drizzle,
      'thunderstorm' => WeatherCondition.thunderstorm,
      'snow' => WeatherCondition.snow,
      'mist' ||
      'fog' ||
      'haze' ||
      'smoke' ||
      'dust' ||
      'sand' ||
      'ash' => WeatherCondition.fog,
      'squall' || 'tornado' => WeatherCondition.extreme,
      _ => WeatherCondition.unknown,
    };
  }
}

/// Entidad inmutable que representa el clima actual.
class WeatherEntity {
  /// Temperatura en °C.
  final double temperatureCelsius;

  /// Sensación térmica en °C.
  final double feelsLikeCelsius;

  /// Humedad relativa (0–100).
  final int humidity;

  /// Presión atmosférica en hPa.
  final int pressure;

  /// Velocidad del viento en m/s.
  final double windSpeed;

  /// Condición climática principal.
  final WeatherCondition condition;

  /// Descripción textual del clima (del API).
  final String description;

  /// Código de icono OWM (ej: "10d").
  final String iconCode;

  /// Nombre de la ciudad.
  final String cityName;

  /// Timestamp de cuando se obtuvo el dato.
  final DateTime fetchedAt;

  const WeatherEntity({
    required this.temperatureCelsius,
    required this.feelsLikeCelsius,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.condition,
    required this.description,
    required this.iconCode,
    required this.cityName,
    required this.fetchedAt,
  });

  /// Determina si los datos son considerados "frescos" (< ttl).
  bool isFresh({Duration ttl = const Duration(minutes: 15)}) {
    return DateTime.now().difference(fetchedAt) < ttl;
  }

  @override
  String toString() =>
      'WeatherEntity($cityName: ${temperatureCelsius.toStringAsFixed(1)}°C, $condition)';
}
