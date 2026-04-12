import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/currency.dart';
import '../models/exchange_rate_model.dart';

/// Interfaz para la persistencia local de datos de divisas.
/// 
/// Se encarga de almacenar en caché las tasas de cambio y recordar la 
/// preferencia de moneda del usuario entre sesiones.
abstract class CurrencyLocalDataSource {
  /// Recupera una tasa de cambio almacenada localmente. 
  /// 
  /// Lanza un [CacheFailure] si la clave no existe o los datos están corruptos.
  Future<ExchangeRateModel> getLastExchangeRate(String key);

  /// Almacena una tasa de cambio en el almacenamiento persistente.
  Future<void> cacheExchangeRate(ExchangeRateModel rate, String key);

  /// Obtiene la moneda preferida del usuario (ej: 'USD', 'MXN').
  Future<Currency> getPreferredCurrency();

  /// Guarda de forma permanente la moneda preferida del usuario.
  Future<void> savePreferredCurrency(Currency currency);
}

/// Prefijo para las claves de caché de tasas de cambio en SharedPreferences.
const cachedExchangeRateKeyPrefix = 'CACHED_EXCHANGE_RATE_';
/// Clave de SharedPreferences para la moneda preferida del usuario.
const preferredCurrencyKey = 'PREFERRED_CURRENCY';

/// Implementación de la fuente de datos local utilizando [SharedPreferences].
class CurrencyLocalDataSourceImpl implements CurrencyLocalDataSource {
  final SharedPreferences sharedPreferences;

  CurrencyLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<ExchangeRateModel> getLastExchangeRate(String cacheKey) {
    final jsonString = sharedPreferences.getString(cacheKey);
    if (jsonString != null) {
      return Future.value(
        ExchangeRateModel.fromCacheJson(json.decode(jsonString)),
      );
    } else {
      throw CacheFailure('No locally cached exchange rate found');
    }
  }

  @override
  Future<void> cacheExchangeRate(ExchangeRateModel rate, String cacheKey) {
    return sharedPreferences.setString(cacheKey, json.encode(rate.toJson()));
  }

  @override
  Future<Currency> getPreferredCurrency() {
    final currencyString = sharedPreferences.getString(preferredCurrencyKey);
    if (currencyString != null) {
      return Future.value(Currency.fromString(currencyString));
    }
    // Por defecto USD si no hay nada guardado
    return Future.value(Currency.usd);
  }

  @override
  Future<void> savePreferredCurrency(Currency currency) {
    return sharedPreferences.setString(preferredCurrencyKey, currency.code);
  }
}
