import 'package:intl/intl.dart';
import 'entities/currency.dart';

/// Utilidad estática para la representación visual de montos monetarios.
/// 
/// Realiza conversiones dinámicas basadas en tasas de cambio y aplica 
/// formatos de numeración conformes al estándar local de la divisa de destino.
class CurrencyFormatter {
  const CurrencyFormatter._();

  /// Convierte y formatea un monto usando la divisa deseada y la tasa de cambio actual.
  /// 
  /// Utiliza la biblioteca [intl] para asegurar un formato de moneda profesional:
  /// * Redondeo a 2 decimales.
  /// * Separador de miles y decimales correcto.
  /// * Inyección de código de divisa ISO (ej: $1,250.00 MXN).
  static String format(
    double baseAmount, {
    required Currency baseCurrency,
    required Currency targetCurrency,
    required double exchangeRate,
  }) {
    double convertedAmount = baseAmount;

    // Lógica de conversión si las monedas difieren
    if (baseCurrency != targetCurrency) {
      if (baseCurrency == Currency.usd && targetCurrency == Currency.mxn) {
        convertedAmount = baseAmount * exchangeRate;
      } else if (baseCurrency == Currency.mxn &&
          targetCurrency == Currency.usd) {
        // En caso de que recibamos la tasa directa USD -> MXN pero nuestra base sea MXN,
        // aplicamos la inversa para obtener el valor en dólares.
        convertedAmount = baseAmount / exchangeRate;
      }
    }

    // Evita problemas de precisión en coma flotante redondeando a 2 decimales.
    final rounded = (convertedAmount * 100).roundToDouble() / 100;

    final formatter = NumberFormat.currency(
      symbol: targetCurrency.symbol,
      decimalDigits: 2,
      customPattern: '\u00A4#,##0.00',
    );

    return '${formatter.format(rounded)}\u00A0${targetCurrency.code}';
  }
}
