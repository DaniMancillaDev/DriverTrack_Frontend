import 'currency.dart';

class ExchangeRate {
  final Currency baseCurrency;
  final Currency targetCurrency;
  final double rate;
  final DateTime lastUpdated;

  ExchangeRate({
    required this.baseCurrency,
    required this.targetCurrency,
    required this.rate,
    required this.lastUpdated,
  });

  /// Inverts the rate if we need the reverse conversion.
  ExchangeRate invert() {
    return ExchangeRate(
      baseCurrency: targetCurrency,
      targetCurrency: baseCurrency,
      rate: 1.0 / rate,
      lastUpdated: lastUpdated,
    );
  }
}
