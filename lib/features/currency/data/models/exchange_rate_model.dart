import '../../domain/entities/currency.dart';
import '../../domain/entities/exchange_rate.dart';

class ExchangeRateModel extends ExchangeRate {
  ExchangeRateModel({
    required super.baseCurrency,
    required super.targetCurrency,
    required super.rate,
    required super.lastUpdated,
  });

  factory ExchangeRateModel.fromJson(
    Map<String, dynamic> json,
    Currency target,
  ) {
    // ExchangeRate-API returns:
    // {
    //   "base_code": "USD",
    //   "time_last_update_unix": 1729017600,
    //   "rates": { "MXN": 19.5, ... }
    // }

    final baseCode = json['base_code'] as String;
    // La v4 devuelve 'rates', la v6 devuelve 'conversion_rates'
    final rates =
        (json['rates'] ?? json['conversion_rates']) as Map<String, dynamic>;
    final rate = (rates[target.code] as num).toDouble();
    final timeUnix = json['time_last_update_unix'] as int;

    return ExchangeRateModel(
      baseCurrency: Currency.fromString(baseCode),
      targetCurrency: target,
      rate: rate,
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(timeUnix * 1000),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base_code': baseCurrency.code,
      'target_code': targetCurrency.code,
      'rate': rate,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  factory ExchangeRateModel.fromCacheJson(Map<String, dynamic> json) {
    return ExchangeRateModel(
      baseCurrency: Currency.fromString(json['base_code'] as String),
      targetCurrency: Currency.fromString(json['target_code'] as String),
      rate: (json['rate'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }
}
