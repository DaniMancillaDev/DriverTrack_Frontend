/// Motor de recomendaciones de conducción basado en clima.
///
/// Usa un sistema de reglas extensible: para agregar nuevas
/// recomendaciones, solo agrega un nuevo [WeatherRule] a la lista.
/// No hay lógica hardcodeada en la UI.

import 'package:flutter/material.dart';
import '../entities/weather_entity.dart';
import '../entities/weather_recommendation.dart';

/// Una regla individual que evalúa el clima y puede generar recomendaciones.
typedef WeatherRule =
    List<WeatherRecommendation> Function(WeatherEntity weather);

/// Motor principal de recomendaciones.
class RecommendationEngine {
  const RecommendationEngine._();

  /// Reglas por defecto orientadas a conductores.
  static final List<WeatherRule> _defaultRules = [
    _heatRule,
    _coldRule,
    _rainRule,
    _thunderstormRule,
    _snowRule,
    _fogRule,
    _extremeWindRule,
    _extremeRule,
  ];

  /// Evalúa todas las reglas y retorna las recomendaciones aplicables.
  static List<WeatherRecommendation> evaluate(WeatherEntity weather) {
    final recommendations = <WeatherRecommendation>[];
    for (final rule in _defaultRules) {
      recommendations.addAll(rule(weather));
    }
    return recommendations;
  }

  // ─── Built-in Rules ──────────────────────────────────────────

  /// Calor extremo (>35°C)
  static List<WeatherRecommendation> _heatRule(WeatherEntity w) {
    if (w.temperatureCelsius > 35) {
      return [
        const WeatherRecommendation(
          messageKey: 'extremeHeat',
          severity: RecommendationSeverity.critical,
          icon: Icons.local_fire_department,
        ),
      ];
    }
    if (w.temperatureCelsius > 30) {
      return [
        const WeatherRecommendation(
          messageKey: 'stayHydrated',
          severity: RecommendationSeverity.warning,
          icon: Icons.water_drop_outlined,
        ),
      ];
    }
    return [];
  }

  /// Frío (<5°C)
  static List<WeatherRecommendation> _coldRule(WeatherEntity w) {
    if (w.temperatureCelsius < 0) {
      return [
        const WeatherRecommendation(
          messageKey: 'freezing',
          severity: RecommendationSeverity.critical,
          icon: Icons.ac_unit,
        ),
      ];
    }
    if (w.temperatureCelsius < 5) {
      return [
        const WeatherRecommendation(
          messageKey: 'coldWeather',
          severity: RecommendationSeverity.warning,
          icon: Icons.severe_cold,
        ),
      ];
    }
    return [];
  }

  /// Lluvia
  static List<WeatherRecommendation> _rainRule(WeatherEntity w) {
    if (w.condition == WeatherCondition.rain ||
        w.condition == WeatherCondition.drizzle) {
      return [
        const WeatherRecommendation(
          messageKey: 'rainyConditions',
          severity: RecommendationSeverity.warning,
          icon: Icons.umbrella,
        ),
      ];
    }
    return [];
  }

  /// Tormenta eléctrica
  static List<WeatherRecommendation> _thunderstormRule(WeatherEntity w) {
    if (w.condition == WeatherCondition.thunderstorm) {
      return [
        const WeatherRecommendation(
          messageKey: 'thunderstorm',
          severity: RecommendationSeverity.critical,
          icon: Icons.flash_on,
        ),
      ];
    }
    return [];
  }

  /// Nieve
  static List<WeatherRecommendation> _snowRule(WeatherEntity w) {
    if (w.condition == WeatherCondition.snow) {
      return [
        const WeatherRecommendation(
          messageKey: 'snowConditions',
          severity: RecommendationSeverity.critical,
          icon: Icons.snowing,
        ),
      ];
    }
    return [];
  }

  /// Niebla / baja visibilidad
  static List<WeatherRecommendation> _fogRule(WeatherEntity w) {
    if (w.condition == WeatherCondition.fog) {
      return [
        const WeatherRecommendation(
          messageKey: 'foggyConditions',
          severity: RecommendationSeverity.warning,
          icon: Icons.cloud,
        ),
      ];
    }
    return [];
  }

  /// Viento fuerte (>15 m/s ≈ 54 km/h)
  static List<WeatherRecommendation> _extremeWindRule(WeatherEntity w) {
    if (w.windSpeed > 15) {
      return [
        const WeatherRecommendation(
          messageKey: 'strongWind',
          severity: RecommendationSeverity.warning,
          icon: Icons.air,
        ),
      ];
    }
    return [];
  }

  /// Condiciones extremas (tornado, etc.)
  static List<WeatherRecommendation> _extremeRule(WeatherEntity w) {
    if (w.condition == WeatherCondition.extreme) {
      return [
        const WeatherRecommendation(
          messageKey: 'extremeWeather',
          severity: RecommendationSeverity.critical,
          icon: Icons.warning_amber_rounded,
        ),
      ];
    }
    return [];
  }
}
