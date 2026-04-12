/// Modelo de datos para el clima.
///
/// Extiende la entidad de dominio con serialización JSON
/// para comunicación con la API de OpenWeatherMap.

import '../../domain/entities/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  const WeatherModel({
    required super.temperatureCelsius,
    required super.feelsLikeCelsius,
    required super.humidity,
    required super.pressure,
    required super.windSpeed,
    required super.condition,
    required super.description,
    required super.iconCode,
    required super.cityName,
    required super.fetchedAt,
  });

  /// Crea un modelo desde la respuesta JSON de OpenWeatherMap.
  ///
  /// Formato esperado: https://openweathermap.org/current#current_JSON
  factory WeatherModel.fromOwmJson(Map<String, dynamic> json) {
    final mainData = json['main'] as Map<String, dynamic>;
    final windData = json['wind'] as Map<String, dynamic>;
    final weatherList = json['weather'] as List;
    final weatherData = weatherList.first as Map<String, dynamic>;

    return WeatherModel(
      temperatureCelsius: (mainData['temp'] as num).toDouble(),
      feelsLikeCelsius: (mainData['feels_like'] as num).toDouble(),
      humidity: mainData['humidity'] as int,
      pressure: mainData['pressure'] as int,
      windSpeed: (windData['speed'] as num).toDouble(),
      condition: WeatherCondition.fromOwmMain(weatherData['main'] as String),
      description: weatherData['description'] as String,
      iconCode: weatherData['icon'] as String,
      cityName: json['name'] as String,
      fetchedAt: DateTime.now(),
    );
  }

  /// Serializa a JSON para almacenamiento local (cache).
  Map<String, dynamic> toJson() {
    return {
      'temperature_celsius': temperatureCelsius,
      'feels_like_celsius': feelsLikeCelsius,
      'humidity': humidity,
      'pressure': pressure,
      'wind_speed': windSpeed,
      'condition': condition.name,
      'description': description,
      'icon_code': iconCode,
      'city_name': cityName,
      'fetched_at': fetchedAt.toIso8601String(),
    };
  }

  /// Reconstruye desde JSON del cache local.
  factory WeatherModel.fromCacheJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperatureCelsius: (json['temperature_celsius'] as num).toDouble(),
      feelsLikeCelsius: (json['feels_like_celsius'] as num).toDouble(),
      humidity: json['humidity'] as int,
      pressure: json['pressure'] as int,
      windSpeed: (json['wind_speed'] as num).toDouble(),
      condition: WeatherCondition.values.firstWhere(
        (c) => c.name == json['condition'],
        orElse: () => WeatherCondition.unknown,
      ),
      description: json['description'] as String,
      iconCode: json['icon_code'] as String,
      cityName: json['city_name'] as String,
      fetchedAt: DateTime.parse(json['fetched_at'] as String),
    );
  }
}
