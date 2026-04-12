import 'currency.dart';

/// Representa la tasa de cambio entre dos monedas en un momento dado.
/// 
/// Se utiliza para cálculos financieros en tiempo real, manteniendo la 
/// trazabilidad de la última actualización para asegurar la frescura de los datos.
class ExchangeRate {
  /// Moneda de origen para el cálculo.
  final Currency baseCurrency;
  /// Moneda a la que se desea convertir.
  final Currency targetCurrency;
  /// Multiplicador para realizar la conversión.
  final double rate;
  /// Marca de tiempo de la última sincronización con el proveedor de tasas (o el servidor).
  final DateTime lastUpdated;

  ExchangeRate({
    required this.baseCurrency,
    required this.targetCurrency,
    required this.rate,
    required this.lastUpdated,
  });

  /// Invierte la tasa para realizar la conversión en sentido contrario.
  /// 
  /// Útil cuando se tiene la tasa USD/MXN pero se necesita MXN/USD sin 
  /// realizar una nueva petición de red.
  ExchangeRate invert() {
    return ExchangeRate(
      baseCurrency: targetCurrency,
      targetCurrency: baseCurrency,
      rate: 1.0 / rate,
      lastUpdated: lastUpdated,
    );
  }
}
