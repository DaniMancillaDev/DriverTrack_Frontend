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
import '../../../../core/units/presentation/unit_system_provider.dart'
    show sharedPreferencesProvider;

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
import '../../../../core/units/presentation/unit_system_provider.dart'
    show sharedPreferencesProvider;

// ─── Proveedores de Infraestructura y Dependencias ───────────────────

/// Punto de acceso global al cliente HTTP para servicios de divisas.
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

/// Orquestador del almacenamiento persistente de preferencias de moneda.
final currencyLocalDataSourceProvider = Provider<CurrencyLocalDataSource>((
  ref,
) {
  return CurrencyLocalDataSourceImpl(
    sharedPreferences: ref.read(sharedPreferencesProvider),
  );
});

/// Gestiona la comunicación con APIs externas para la obtención de tipos de cambio.
final currencyRemoteDataSourceProvider = Provider<CurrencyRemoteDataSource>((
  ref,
) {
  return CurrencyRemoteDataSourceImpl(client: ref.read(httpClientProvider));
});

/// Implementación del repositorio de divisas que unifica fuentes de datos locales y remotas.
final currencyRepositoryProvider = Provider<CurrencyRepositoryImpl>((ref) {
  return CurrencyRepositoryImpl(
    localDataSource: ref.read(currencyLocalDataSourceProvider),
    remoteDataSource: ref.read(currencyRemoteDataSourceProvider),
  );
});

// ─── Casos de Uso (Lógica de Dominio Inyectada) ─────────────────────

/// Servicio de dominio para la obtención proactiva de tasas de cambio.
final getExchangeRateUseCaseProvider = Provider<GetExchangeRate>((ref) {
  return GetExchangeRate(ref.read(currencyRepositoryProvider));
});

/// Servicio de dominio para recuperar la moneda preferida del usuario.
final getUserCurrencyPreferenceUseCaseProvider =
    Provider<GetUserCurrencyPreference>((ref) {
      return GetUserCurrencyPreference(ref.read(currencyRepositoryProvider));
    });

/// Servicio de dominio para persistir cambios en la preferencia de moneda.
final saveUserCurrencyPreferenceUseCaseProvider =
    Provider<SaveUserCurrencyPreference>((ref) {
      return SaveUserCurrencyPreference(ref.read(currencyRepositoryProvider));
    });

/// Utilidad de dominio pura para el cálculo de conversiones monetarias.
final convertCurrencyUseCaseProvider = Provider<ConvertCurrency>((ref) {
  return ConvertCurrency();
});

// ─── Gestión de Estado de la Interfaz ─────────────────────────────

/// Representa el estado inmutable del sistema de divisas en la UI.
/// 
/// Consolida el tipo de cambio actual y la moneda activa seleccionada por el usuario.
class CurrencyState {
  /// Valor de conversión actual entre las monedas soportadas.
  final ExchangeRate exchangeRate;
  /// Moneda en uso para la visualización de costos (ej. USD o MXN).
  final Currency activeCurrency;

  CurrencyState({required this.exchangeRate, required this.activeCurrency});

  /// Crea una copia del estado permitiendo actualizaciones parciales.
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

/// Proveedor del Notificador que gestiona el ciclo de vida de las divisas.
/// 
/// Provee acceso reactivo al [CurrencyState] y permite disparar actualizaciones.
final currencyNotifierProvider =
    AsyncNotifierProvider<CurrencyNotifier, CurrencyState>(() {
      return CurrencyNotifier();
    });

/// Orquestador reactivo de la lógica de negocio para la gestión de divisas.
/// 
/// Sus responsabilidades incluyen:
/// * **Inicialización**: Carga las preferencias del usuario al arrancar la app.
/// * **Sincronización**: Actualiza los tipos de cambio desde servidores remotos.
/// * **Persistencia**: Garantiza que el cambio de moneda se guarde localmente.
/// * **Cálculo**: Provee métodos de conveniencia para convertir montos financieros.
class CurrencyNotifier extends AsyncNotifier<CurrencyState> {
  @override
  Future<CurrencyState> build() async {
    return _fetchInitialData();
  }

  /// Recupera los datos iniciales de sesión (preferencia y tasa base).
  Future<CurrencyState> _fetchInitialData() async {
    final getPrefUseCase = ref.read(getUserCurrencyPreferenceUseCaseProvider);
    final getRateUseCase = ref.read(getExchangeRateUseCaseProvider);

    Currency preferred = Currency.usd;
    final prefResult = await getPrefUseCase();
    prefResult.fold((_) {}, (val) => preferred = val);

    // Solicitamos siempre USD -> MXN para mantener una base de comparación estable
    final rateResult = await getRateUseCase(
      base: Currency.usd,
      target: Currency.mxn,
    );

    return rateResult.fold(
      (failure) => throw Exception(failure.message),
      (rate) => CurrencyState(exchangeRate: rate, activeCurrency: preferred),
    );
  }

  /// Refresca las tasas de cambio consultando el API externo.
  Future<void> refreshRates() async {
    state = const AsyncValue.loading();
    try {
      final getRateUseCase = ref.read(getExchangeRateUseCaseProvider);
      final rateResult = await getRateUseCase(
        base: Currency.usd,
        target: Currency.mxn,
      );

      final currentCurrency = state.value?.activeCurrency ?? Currency.usd;

      rateResult.fold(
        (failure) {
          state = AsyncValue.error(failure.message, StackTrace.current);
        },
        (rate) {
          state = AsyncValue.data(
            CurrencyState(exchangeRate: rate, activeCurrency: currentCurrency),
          );
        },
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Alterna entre las monedas disponibles (USD <-> MXN) y persiste la elección.
  Future<void> toggleCurrency() async {
    final currentState = state.value;
    if (currentState == null) return;

    final newCurrency = currentState.activeCurrency == Currency.usd
        ? Currency.mxn
        : Currency.usd;

    final savePrefUseCase = ref.read(saveUserCurrencyPreferenceUseCaseProvider);
    await savePrefUseCase(newCurrency);

    state = AsyncValue.data(currentState.copyWith(activeCurrency: newCurrency));
  }

  /// Utilidad para convertir un monto bruto a la moneda activa actualmente.
  double convert(double amount) {
    final currentState = state.value;
    if (currentState == null) return 0.0;

    final convertUseCase = ref.read(convertCurrencyUseCaseProvider);

    // Si la moneda activa es USD, convertimos usando la tasa estándar.
    // Si es MXN, invertimos la tasa para el cálculo.
    final effectiveRate = currentState.activeCurrency == Currency.usd
        ? currentState.exchangeRate
        : currentState.exchangeRate.invert();

    return convertUseCase(amount: amount, exchangeRate: effectiveRate);
  }
}
