import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../entities/currency.dart';
import '../repositories/currency_repository.dart';

class GetUserCurrencyPreference {
  final CurrencyRepository _repository;

  GetUserCurrencyPreference(this._repository);

  Future<Result<Failure, Currency>> call() {
    return _repository.getPreferredCurrency();
  }
}
