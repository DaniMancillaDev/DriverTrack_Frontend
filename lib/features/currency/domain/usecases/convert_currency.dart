import '../entities/exchange_rate.dart';

class ConvertCurrency {
  /// Converts an amount using the provided exchange rate.
  /// It prevents simple double rounding issues by rounding the final result
  /// to 2 decimals using integer arithmetic.
  double call({
    required double amount,
    required ExchangeRate exchangeRate,
  }) {
    if (amount <= 0) return 0.0;
    
    final double rawResult = amount * exchangeRate.rate;
    // Round to 2 decimal places to avoid precision errors like 1.0000000001
    final double roundedResult = (rawResult * 100).roundToDouble() / 100;
    
    return roundedResult;
  }
}
