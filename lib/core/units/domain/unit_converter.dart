/// Contiene funciones puras para la conversión matemática entre sistemas de medidas.
class UnitConverter {
  const UnitConverter._();

  static const double _kmToMiRatio = 0.621371;

  // --- Distancia ---
  static double kmToMi(double km) => km * _kmToMiRatio;
  static double miToKm(double mi) => mi / _kmToMiRatio;

  // --- Temperatura ---
  static double celsiusToFahrenheit(double c) => (c * 9 / 5) + 32;
  static double fahrenheitToCelsius(double f) => (f - 32) * 5 / 9;
}
