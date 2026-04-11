import '../entities/exchange_rate.dart';

/// Caso de Uso: Realiza la conversión matemática entre montos monetarios.
/// 
/// Centraliza la lógica de redondeo financiero para evitar errores de precisión 
/// de punto flotante comunes en cálculos de divisas.
class ConvertCurrency {
  /// Ejecuta la conversión de un monto utilizando una tasa específica.
  /// 
  /// Redondea el resultado final a 2 decimales utilizando aritmética de 
  /// enteros para garantizar consistencia visual en la UI.
  double call({required double amount, required ExchangeRate exchangeRate}) {
    if (amount <= 0) return 0.0;

    final double rawResult = amount * exchangeRate.rate;
    // Redondeo a 2 decimales para evitar problemas de precisión como 1.0000000001
    final double roundedResult = (rawResult * 100).roundToDouble() / 100;

    return roundedResult;
  }
}
