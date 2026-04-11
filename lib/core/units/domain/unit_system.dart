import 'distance_unit.dart';
import 'temperature_unit.dart';

/// Orquestador de la jerarquía de sistemas de medida de la aplicación.
/// 
/// Su responsabilidad es actuar como el contrato semántico para la selección de 
/// unidades de medida. Centraliza la lógica de agrupación (Métrico vs Imperial) 
/// para asegurar que toda la interfaz se adapte consistentemente a las 
/// preferencias físicas del usuario.
enum UnitSystem {
  /// Sistema Internacional (SI): Base técnica en Kilómetros y Celsius.
  metric,
  /// Sistema de Unidades del Reino Unido/EE.UU.: Base técnica en Millas y Fahrenheit.
  imperial;

  /// Retorna la unidad de distancia asociada al sistema actual.
  DistanceUnit get distanceUnit {
    switch (this) {
      case UnitSystem.metric:
        return DistanceUnit.kilometers;
      case UnitSystem.imperial:
        return DistanceUnit.miles;
    }
  }

  /// Retorna la unidad de temperatura asociada al sistema actual.
  TemperatureUnit get temperatureUnit {
    switch (this) {
      case UnitSystem.metric:
        return TemperatureUnit.celsius;
      case UnitSystem.imperial:
        return TemperatureUnit.fahrenheit;
    }
  }
}
