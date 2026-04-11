/// Representa las unidades de trayectoria y distancia soportadas.
enum DistanceUnit {
  /// Sistema métrico (km).
  kilometers,
  /// Sistema imperial (mi).
  miles;

  /// Símbolo corto para visualización en UI (km/mi).
  String get symbol {
    switch (this) {
      case DistanceUnit.kilometers:
        return 'km';
      case DistanceUnit.miles:
        return 'mi';
    }
  }
}
