/// Entidad de recomendación de conducción basada en clima.
///
/// Generada por el motor de reglas, no acoplada a la UI.

import 'package:flutter/material.dart';

/// Severidad de la recomendación.
enum RecommendationSeverity { info, warning, critical }

/// Recomendación inmutable para el conductor.
class WeatherRecommendation {
  /// Clave i18n para el mensaje (ej: "weather.rec.hydration").
  final String messageKey;

  /// Severidad del aviso.
  final RecommendationSeverity severity;

  /// Icono representativo.
  final IconData icon;

  const WeatherRecommendation({
    required this.messageKey,
    required this.severity,
    required this.icon,
  });

  @override
  String toString() => 'WeatherRecommendation($messageKey, $severity)';
}
