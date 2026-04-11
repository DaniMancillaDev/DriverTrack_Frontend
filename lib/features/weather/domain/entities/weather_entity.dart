/// Entidad de dominio para datos climáticos.
///
/// Todos los valores se almacenan en unidades métricas (°C, m/s).
/// La conversión a unidades imperiales o personalizadas se delega a los
/// formateadores de la capa de presentación.

/// Enumeración con las condiciones climáticas principales soportadas.
enum WeatherCondition {
  /// Cielo despejado.
  clear,
  /// Cielo nublado o parcialmente nuboso.
  clouds,
  /// Lluvia moderada o fuerte.
  rain,
  /// Llovizna o lluvia ligera.
  drizzle,
  /// Tormentas eléctricas.
  thunderstorm,
  /// Nieve o granizo.
  snow,
  /// Neblina, bruma o visibilidad reducida.
  fog,
  /// Condiciones extremas (tornados, ráfagas violentas).
  extreme,
  /// Condición no identificada o error de mapeo.
  unknown;

  /// Traduce el campo 'main' de OpenWeatherMap al enum [WeatherCondition].
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

/// Representa el estado meteorológico actual obtenido de un servicio externo.
/// 
/// Es una entidad inmutable que consolida temperatura, visibilidad,
/// viento y metadatos de ubicación.
class WeatherEntity {
  /// Temperatura medida en grados Celsius.
  final double temperatureCelsius;

  /// Sensación térmica medida en grados Celsius.
  final double feelsLikeCelsius;

  /// Porcentaje de humedad relativa (0 a 100).
  final int humidity;

  /// Presión atmosférica a nivel del mar (hPa).
  final int pressure;

  /// Velocidad del viento en metros por segundo.
  final double windSpeed;

  /// Clasificación simplificada del clima ([WeatherCondition]).
  final WeatherCondition condition;

  /// Descripción extendida y localizada del clima (ej: "nubes dispersas").
  final String description;

  /// Código de icono compatible con OpenWeatherMap (ej: "01d").
  final String iconCode;

  /// Nombre de la ubicación geográfica (ciudad/distrito).
  final String cityName;

  /// Momento exacto de la última sincronización con el servidor.
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

  /// Verifica si los datos climáticos actuales siguen siendo válidos.
  /// 
  /// Por defecto, DriverTrack considera que el clima expira tras 15 minutos ([ttl]).
  bool isFresh({Duration ttl = const Duration(minutes: 15)}) {
    return DateTime.now().difference(fetchedAt) < ttl;
  }

  @override
  String toString() =>
      'WeatherEntity($cityName: ${temperatureCelsius.toStringAsFixed(1)}°C, $condition)';
}
