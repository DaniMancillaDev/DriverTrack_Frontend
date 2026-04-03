import 'package:intl/intl.dart';
import 'entities/currency.dart';

class CurrencyFormatter {
  const CurrencyFormatter._();

  /// Convierte y formatea un monto usando la divisa deseada y la tasa de cambio actual.
  static String format(
    double baseAmount, {
    required Currency baseCurrency,
    required Currency targetCurrency,
    required double exchangeRate,
  }) {
    double convertedAmount = baseAmount;
    
    if (baseCurrency != targetCurrency) {
      if (baseCurrency == Currency.usd && targetCurrency == Currency.mxn) {
        convertedAmount = baseAmount * exchangeRate;
      } else if (baseCurrency == Currency.mxn && targetCurrency == Currency.usd) {
        // En caso de que recibamos la tasa directa USD -> MXN pero nuestra base sea MXN
        convertedAmount = baseAmount / exchangeRate; 
      }
    }

    // Evita problemas de redondeo
    final rounded = (convertedAmount * 100).roundToDouble() / 100;

    final formatter = NumberFormat.currency(
      symbol: targetCurrency.symbol,
      decimalDigits: 2,
      customPattern: '\u00A4#,##0.00',
    );
    
    return '${formatter.format(rounded)}\u00A0${targetCurrency.code}';
  }
}
