/// Unidades de medida para temperatura ambiente y del motor.
enum TemperatureUnit {
  /// Escala de grados Celsius.
  celsius,
  /// Escala de grados Fahrenheit.
  fahrenheit;

  /// Símbolo de grado con sufijo de la escala correspondiente (°C/°F).
  String get symbol {
    switch (this) {
      case TemperatureUnit.celsius:
        return '°C';
      case TemperatureUnit.fahrenheit:
        return '°F';
    }
  }
}
