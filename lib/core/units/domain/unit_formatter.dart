import 'unit_system.dart';
import 'unit_converter.dart';

/// Clase de utilidad para formatear valores brutos según el sistema de unidades activo.
/// Se asume que en base de datos (o internamente) la app guarda siempre:
/// - Distancia en Kilómetros
/// - Temperatura en Celsius
class UnitFormatter {
  const UnitFormatter._();
  
  /// Formatea la distancia y retorna un String con el símbolo correspondiente.
  /// Ej: 10.5 km o 6.5 mi
  static String formatDistance(double kilometers, UnitSystem system, {int fractionDigits = 1}) {
    double value = kilometers;
    if (system == UnitSystem.imperial) {
      value = UnitConverter.kmToMi(kilometers);
    }
    
    // Si el valor no tiene decimales reales, podemos mostrarlo sin `.0`
    String formattedValue;
    if (value == value.roundToDouble() && fractionDigits > 0) {
      formattedValue = value.toStringAsFixed(0);
    } else {
      formattedValue = value.toStringAsFixed(fractionDigits);
    }

    return '$formattedValue ${system.distanceUnit.symbol}';
  }

  /// Formatea la temperatura y retorna un String con el símbolo correspondiente.
  /// Ej: 25 °C o 77 °F
  static String formatTemperature(double celsius, UnitSystem system, {int fractionDigits = 0}) {
    double value = celsius;
    if (system == UnitSystem.imperial) {
      value = UnitConverter.celsiusToFahrenheit(celsius);
    }
    
    return '${value.toStringAsFixed(fractionDigits)} ${system.temperatureUnit.symbol}';
  }
}
