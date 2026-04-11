/// Contiene funciones puras para la conversión matemática entre sistemas de medidas.
/// 
/// Provee los factores de conversión y fórmulas necesarias para transicionar 
/// valores entre el sistema métrico e imperial de forma precisa.
class UnitConverter {
  const UnitConverter._();

  static const double _kmToMiRatio = 0.621371;

  // --- Distancia ---

  /// Convierte kilómetros a millas utilizando el ratio estándar 0.621371.
  static double kmToMi(double km) => km * _kmToMiRatio;
  
  /// Convierte millas a kilómetros realizando la operación inversa al ratio estándar.
  static double miToKm(double mi) => mi / _kmToMiRatio;

  // --- Temperatura ---

  /// Convierte grados Celsius a Fahrenheit siguiendo la fórmula tradicional (C * 9/5) + 32.
  static double celsiusToFahrenheit(double c) => (c * 9 / 5) + 32;
  
  /// Convierte grados Fahrenheit a Celsius siguiendo la fórmula tradicional (F - 32) * 5/9.
  static double fahrenheitToCelsius(double f) => (f - 32) * 5 / 9;
}
