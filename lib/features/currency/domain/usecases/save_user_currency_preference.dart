import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../entities/currency.dart';
import '../repositories/currency_repository.dart';

class SaveUserCurrencyPreference {
  final CurrencyRepository _repository;

  SaveUserCurrencyPreference(this._repository);

  Future<Result<Failure, void>> call(Currency currency) {
    return _repository.savePreferredCurrency(currency);
  }
}
