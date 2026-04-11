import 'unit_system.dart';
import 'unit_converter.dart';

/// Clase de utilidad para formatear valores brutos según el sistema de unidades activo.
/// 
/// Se encarga de la transformación visual de los datos, asegurando que los usuarios
/// vean las medidas en sus unidades preferidas con el redondeo y símbolos adecuados.
/// 
/// El sistema asume que internamente (Base de datos/API) las medidas son:
/// - Distancia: Kilómetros (km)
/// - Temperatura: Celsius (°C)
class UnitFormatter {
  const UnitFormatter._();

  /// Formatea un valor de distancia (en km) según el [UnitSystem] solicitado.
  /// 
  /// Retorna un String que incluye el valor redondeado y el símbolo de la unidad.
  /// Ej: `10.5 km` o `6.5 mi`.
  static String formatDistance(
    double kilometers,
    UnitSystem system, {
    int fractionDigits = 1,
  }) {
    double value = kilometers;
    if (system == UnitSystem.imperial) {
      value = UnitConverter.kmToMi(kilometers);
    }

    // Lógica para omitir decimales si el valor es un entero exacto
    String formattedValue;
    if (value == value.roundToDouble() && fractionDigits > 0) {
      formattedValue = value.toStringAsFixed(0);
    } else {
      formattedValue = value.toStringAsFixed(fractionDigits);
    }

    return '$formattedValue ${system.distanceUnit.symbol}';
  }

  /// Formatea un valor de temperatura (en °C) según el [UnitSystem] solicitado.
  /// 
  /// Retorna un String con el símbolo correspondiente (°C/°F).
  /// Ej: `25 °C` o `77 °F`.
  static String formatTemperature(
    double celsius,
    UnitSystem system, {
    int fractionDigits = 0,
  }) {
    double value = celsius;
    if (system == UnitSystem.imperial) {
      value = UnitConverter.celsiusToFahrenheit(celsius);
    }

    return '${value.toStringAsFixed(fractionDigits)} ${system.temperatureUnit.symbol}';
  }
}
