import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/currency.dart';
import '../../domain/entities/exchange_rate.dart';
import '../../domain/usecases/convert_currency.dart';
import '../../domain/usecases/get_exchange_rate.dart';
import '../../domain/usecases/get_user_currency_preference.dart';
import '../../domain/usecases/save_user_currency_preference.dart';
import '../../data/datasources/currency_local_data_source.dart';
import '../../data/datasources/currency_remote_data_source.dart';
import '../../data/repositories/currency_repository_impl.dart';
import '../../../../core/units/presentation/unit_system_provider.dart' show sharedPreferencesProvider;

/// Providers for Dependencies
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

final currencyLocalDataSourceProvider = Provider<CurrencyLocalDataSource>((ref) {
  return CurrencyLocalDataSourceImpl(
    sharedPreferences: ref.read(sharedPreferencesProvider),
  );
});

final currencyRemoteDataSourceProvider = Provider<CurrencyRemoteDataSource>((ref) {
  return CurrencyRemoteDataSourceImpl(
    client: ref.read(httpClientProvider),
  );
});

final currencyRepositoryProvider = Provider<CurrencyRepositoryImpl>((ref) {
  return CurrencyRepositoryImpl(
    localDataSource: ref.read(currencyLocalDataSourceProvider),
    remoteDataSource: ref.read(currencyRemoteDataSourceProvider),
  );
});

final getExchangeRateUseCaseProvider = Provider<GetExchangeRate>((ref) {
  return GetExchangeRate(ref.read(currencyRepositoryProvider));
});

final getUserCurrencyPreferenceUseCaseProvider = Provider<GetUserCurrencyPreference>((ref) {
  return GetUserCurrencyPreference(ref.read(currencyRepositoryProvider));
});

final saveUserCurrencyPreferenceUseCaseProvider = Provider<SaveUserCurrencyPreference>((ref) {
  return SaveUserCurrencyPreference(ref.read(currencyRepositoryProvider));
});

final convertCurrencyUseCaseProvider = Provider<ConvertCurrency>((ref) {
  return ConvertCurrency();
});

/// State Class
class CurrencyState {
  final ExchangeRate exchangeRate;
  final Currency activeCurrency;

  CurrencyState({
    required this.exchangeRate,
    required this.activeCurrency,
  });

  CurrencyState copyWith({
    ExchangeRate? exchangeRate,
    Currency? activeCurrency,
  }) {
    return CurrencyState(
      exchangeRate: exchangeRate ?? this.exchangeRate,
      activeCurrency: activeCurrency ?? this.activeCurrency,
    );
  }
}

/// AsyncNotifier Provider
final currencyNotifierProvider = AsyncNotifierProvider<CurrencyNotifier, CurrencyState>(() {
  return CurrencyNotifier();
});

class CurrencyNotifier extends AsyncNotifier<CurrencyState> {
  @override
  Future<CurrencyState> build() async {
    return _fetchInitialData();
  }

  Future<CurrencyState> _fetchInitialData() async {
    final getPrefUseCase = ref.read(getUserCurrencyPreferenceUseCaseProvider);
    final getRateUseCase = ref.read(getExchangeRateUseCaseProvider);

    // Get preferred currency
    Currency preferred = Currency.usd;
    final prefResult = await getPrefUseCase();
    prefResult.fold((_) {}, (val) => preferred = val);

    // Get exchange rate (Fixed USD to MXN since that's our target conversion)
    // We always request USD -> MXN to have a stable cache, and can invert it later.
    final rateResult = await getRateUseCase(base: Currency.usd, target: Currency.mxn);

    return rateResult.fold(
      (failure) => throw Exception(failure.message),
      (rate) => CurrencyState(
        exchangeRate: rate,
        activeCurrency: preferred,
      ),
    );
  }

  /// Refreshes the exchange rate from the API
  Future<void> refreshRates() async {
    state = const AsyncValue.loading();
    try {
      final getRateUseCase = ref.read(getExchangeRateUseCaseProvider);
      final rateResult = await getRateUseCase(base: Currency.usd, target: Currency.mxn);
      
      final currentCurrency = state.value?.activeCurrency ?? Currency.usd;

      rateResult.fold(
        (failure) {
          state = AsyncValue.error(failure.message, StackTrace.current);
        },
        (rate) {
          state = AsyncValue.data(CurrencyState(
            exchangeRate: rate,
            activeCurrency: currentCurrency,
          ));
        },
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Toggles the active currency (e.g., USD -> MXN -> USD)
  Future<void> toggleCurrency() async {
    final currentState = state.value;
    if (currentState == null) return;

    final newCurrency = currentState.activeCurrency == Currency.usd 
        ? Currency.mxn 
        : Currency.usd;

    // Save to preferences
    final savePrefUseCase = ref.read(saveUserCurrencyPreferenceUseCaseProvider);
    await savePrefUseCase(newCurrency);

    state = AsyncValue.data(currentState.copyWith(activeCurrency: newCurrency));
  }
  
  /// Helper to convert amount using the current state and use case
  double convert(double amount) {
    final currentState = state.value;
    if (currentState == null) return 0.0;

    final convertUseCase = ref.read(convertCurrencyUseCaseProvider);
    
    // If our active currency is USD, we convert USD -> MXN using the standard rate.
    // If active is MXN, we convert MXN -> USD using the inverted rate.
    final effectiveRate = currentState.activeCurrency == Currency.usd 
        ? currentState.exchangeRate 
        : currentState.exchangeRate.invert();

    return convertUseCase(
      amount: amount,
      exchangeRate: effectiveRate,
    );
  }
}
