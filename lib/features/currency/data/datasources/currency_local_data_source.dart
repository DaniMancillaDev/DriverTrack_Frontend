import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/currency.dart';
import '../models/exchange_rate_model.dart';

abstract class CurrencyLocalDataSource {
  /// Gets the cached exchange rate, throws [CacheFailure] if not present
  Future<ExchangeRateModel> getLastExchangeRate(String key);

  /// Caches the given [ExchangeRateModel]
  Future<void> cacheExchangeRate(ExchangeRateModel rate, String key);

  /// Gets the user preferred [Currency]
  Future<Currency> getPreferredCurrency();

  /// Saves the user preferred [Currency]
  Future<void> savePreferredCurrency(Currency currency);
}

const cachedExchangeRateKeyPrefix = 'CACHED_EXCHANGE_RATE_';
const preferredCurrencyKey = 'PREFERRED_CURRENCY';

class CurrencyLocalDataSourceImpl implements CurrencyLocalDataSource {
  final SharedPreferences sharedPreferences;

  CurrencyLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<ExchangeRateModel> getLastExchangeRate(String cacheKey) {
    final jsonString = sharedPreferences.getString(cacheKey);
    if (jsonString != null) {
      return Future.value(ExchangeRateModel.fromCacheJson(json.decode(jsonString)));
    } else {
      throw CacheFailure('No locally cached exchange rate found');
    }
  }

  @override
  Future<void> cacheExchangeRate(ExchangeRateModel rate, String cacheKey) {
    return sharedPreferences.setString(
      cacheKey,
      json.encode(rate.toJson()),
    );
  }

  @override
  Future<Currency> getPreferredCurrency() {
    final currencyString = sharedPreferences.getString(preferredCurrencyKey);
    if (currencyString != null) {
      return Future.value(Currency.fromString(currencyString));
    }
    // Default to USD if not set
    return Future.value(Currency.usd);
  }

  @override
  Future<void> savePreferredCurrency(Currency currency) {
    return sharedPreferences.setString(preferredCurrencyKey, currency.code);
  }
}
