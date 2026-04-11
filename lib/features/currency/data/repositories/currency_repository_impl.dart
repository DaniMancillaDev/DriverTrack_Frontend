import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/exchange_rate.dart';
import '../../domain/repositories/currency_repository.dart';
import '../datasources/currency_local_data_source.dart';
import '../datasources/currency_remote_data_source.dart';

/// Implementación del repositorio de divisas.
/// 
/// Gestiona la recuperación de tasas de cambio y las preferencias de moneda del usuario.
/// Implementa una política de caché de 1 hora para minimizar peticiones externas
/// y asegurar que el formateo de precios en la app sea fluido.
/// 
/// La lógica de conversión utiliza [ExchangeRate] para calcular valores entre divisas,
/// priorizando el uso de datos locales (caché) para mejorar la latencia y permitir
/// el funcionamiento offline mediante un mecanismo de fallback.
class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;
  final CurrencyLocalDataSource localDataSource;

  /// Duración máxima de validez para las tasas de cambio almacenadas localmente.
  static const cacheDuration = Duration(hours: 1);

  CurrencyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Result<Failure, ExchangeRate>> getExchangeRate({
    required Currency base,
    required Currency target,
  }) async {
    final cacheKey =
        '$cachedExchangeRateKeyPrefix${base.code}_TO_${target.code}';

    try {
      // 1. Intentar recuperación desde el almacenamiento local
      final cachedRate = await localDataSource.getLastExchangeRate(cacheKey);

      final now = DateTime.now();
      // Si el caché es fresco, se retorna inmediatamente
      if (now.difference(cachedRate.lastUpdated) <= cacheDuration) {
        return Result.success(cachedRate);
      }
    } catch (_) {
      // Caché inexistente o corrupto: continuar a la red
    }

    try {
      // 2. Intentar obtención remota
      final remoteRate = await remoteDataSource.getExchangeRate(base, target);
      // Actualizar el almacenamiento local con el valor fresco
      localDataSource.cacheExchangeRate(remoteRate, cacheKey);
      return Result.success(remoteRate);
    } on Failure catch (e) {
      // 3. Fallback: Si la red falla, intentar usar el caché obsoleto antes de reportar error
      try {
        final cachedFallback = await localDataSource.getLastExchangeRate(
          cacheKey,
        );
        return Result.success(cachedFallback);
      } catch (_) {
        return Result.failure(e);
      }
    } catch (e) {
      return Result.failure(ServerFailure());
    }
  }

  @override
  Future<Result<Failure, Currency>> getPreferredCurrency() async {
    try {
      final currency = await localDataSource.getPreferredCurrency();
      return Result.success(currency);
    } catch (_) {
      return Result.failure(CacheFailure());
    }
  }

  @override
  Future<Result<Failure, void>> savePreferredCurrency(Currency currency) async {
    try {
      await localDataSource.savePreferredCurrency(currency);
      return Result.success(null);
    } catch (_) {
      return Result.failure(CacheFailure());
    }
  }
}
