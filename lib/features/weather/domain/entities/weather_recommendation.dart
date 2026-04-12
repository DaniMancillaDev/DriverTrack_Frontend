import 'package:flutter/material.dart';

/// Define la gravedad de un aviso o recomendación.
enum RecommendationSeverity { 
  /// Información general o sugerencia leve.
  info, 
  /// Advertencia sobre condiciones que requieren atención.
  warning, 
  /// Emergencia o condición climática peligrosa para conducir.
  critical 
}

/// Representa un consejo de seguridad generado automáticamente según el clima.
///
/// Estas recomendaciones ayudan al conductor a ajustar su comportamiento
/// (ej: reducir velocidad ante lluvia, encender luces en neblina).
class WeatherRecommendation {
  /// Identificador para la localización del mensaje.
  final String messageKey;

  /// Nivel de importancia de la recomendación.
  final RecommendationSeverity severity;

  /// Icono visual sugerido para la alerta.
  final IconData icon;

  const WeatherRecommendation({
    required this.messageKey,
    required this.severity,
    required this.icon,
  });

  @override
  String toString() => 'WeatherRecommendation($messageKey, $severity)';
}
