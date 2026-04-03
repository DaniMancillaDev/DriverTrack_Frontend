import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../entities/currency.dart';
import '../entities/exchange_rate.dart';

abstract class CurrencyRepository {
  /// Fetches the exchange rate between a base currency and a target currency.
  Future<Result<Failure, ExchangeRate>> getExchangeRate({
    required Currency base,
    required Currency target,
  });

  /// Retrieves the user's preferred currency (e.g., from local storage).
  Future<Result<Failure, Currency>> getPreferredCurrency();

  /// Saves the user's preferred currency.
  Future<Result<Failure, void>> savePreferredCurrency(Currency currency);
}
