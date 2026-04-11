import 'distance_unit.dart';
import 'temperature_unit.dart';

/// Define los sistemas de unidades soportados por la aplicación.
/// 
/// Centraliza la lógica de selección de unidades para asegurar que toda 
/// la UI se adapte consistentemente al sistema preferido del usuario.
enum UnitSystem {
  /// Unidades SI (Kilómetros, Celsius).
  metric,
  /// Unidades imperiales (Millas, Fahrenheit).
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
