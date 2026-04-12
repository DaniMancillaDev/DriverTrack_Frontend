import '../../domain/entities/currency.dart';
import '../../domain/entities/exchange_rate.dart';

/// Modelo de datos para las tasas de cambio de divisas.
/// 
/// Extiende [ExchangeRate] para incluir capacidades de serialización JSON,
/// permitiendo el mapeo de respuestas desde APIs externas y el almacenamiento local.
class ExchangeRateModel extends ExchangeRate {
  ExchangeRateModel({
    required super.baseCurrency,
    required super.targetCurrency,
    required super.rate,
    required super.lastUpdated,
  });

  /// Crea una instancia desde el formato JSON de ExchangeRate-API (v6).
  /// 
  /// Extrae la tasa correspondiente a la moneda de destino ([target]) y 
  /// convierte la marca de tiempo UNIX a [DateTime].
  factory ExchangeRateModel.fromJson(
    Map<String, dynamic> json,
    Currency target,
  ) {
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

  /// Convierte la instancia a un mapa JSON para persistencia local.
  Map<String, dynamic> toJson() {
    return {
      'base_code': baseCurrency.code,
      'target_code': targetCurrency.code,
      'rate': rate,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  /// Reconstruye el modelo desde un mapa JSON recuperado de caché.
  factory ExchangeRateModel.fromCacheJson(Map<String, dynamic> json) {
    return ExchangeRateModel(
      baseCurrency: Currency.fromString(json['base_code'] as String),
      targetCurrency: Currency.fromString(json['target_code'] as String),
      rate: (json['rate'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }
}
