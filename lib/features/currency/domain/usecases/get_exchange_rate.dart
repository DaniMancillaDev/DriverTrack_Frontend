import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../entities/currency.dart';
import '../entities/exchange_rate.dart';
import '../repositories/currency_repository.dart';

class GetExchangeRate {
  final CurrencyRepository _repository;

  GetExchangeRate(this._repository);

  Future<Result<Failure, ExchangeRate>> call({
    required Currency base,
    required Currency target,
  }) {
    return _repository.getExchangeRate(base: base, target: target);
  }
}
