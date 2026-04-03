import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/exchange_rate.dart';
import '../../domain/repositories/currency_repository.dart';
import '../datasources/currency_local_data_source.dart';
import '../datasources/currency_remote_data_source.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;
  final CurrencyLocalDataSource localDataSource;

  // Let's assume cache is valid for 1 hour
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
    // Both base -> target and target -> base can be cached.
    // It's cleaner to cache USD -> MXN simply and invert if MXN -> USD is requested in theory,
    // but the task asks to fetch dynamic. Let's just use "USD" as the base for the cache key or dynamic.
    final cacheKey = '$cachedExchangeRateKeyPrefix${base.code}_TO_${target.code}';

    try {
      // First check local cache
      final cachedRate = await localDataSource.getLastExchangeRate(cacheKey);
      
      final now = DateTime.now();
      // If cache is still valid
      if (now.difference(cachedRate.lastUpdated) <= cacheDuration) {
        return Result.success(cachedRate);
      }
    } catch (_) {
      // Cache empty or corrupted, ignore and fetch remote
    }

    try {
      // Fetch remote
      final remoteRate = await remoteDataSource.getExchangeRate(base, target);
      // Cache the fresh data
      localDataSource.cacheExchangeRate(remoteRate, cacheKey);
      return Result.success(remoteRate);
    } on Failure catch (e) {
      // If remote fails, fallback to old cache if it exists, otherwise return error
      try {
        final cachedFallback = await localDataSource.getLastExchangeRate(cacheKey);
        return Result.success(cachedFallback);
      } catch (_) {
        return Result.failure(e);
      }
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
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
