import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../entities/currency.dart';
import '../entities/exchange_rate.dart';

/// Contrato para la gestión de datos financieros y preferencias de moneda.
/// 
/// Define las operaciones necesarias para obtener tasas de cambio y 
/// persistir la moneda elegida por el usuario de forma persistente.
abstract class CurrencyRepository {
  /// Obtiene la tasa de cambio entre una moneda base y una de destino.
  /// 
  /// Puede provenir de una fuente remota (API) o caché local.
  Future<Result<Failure, ExchangeRate>> getExchangeRate({
    required Currency base,
    required Currency target,
  });

  /// Recupera la preferencia de moneda almacenada localmente por el usuario.
  Future<Result<Failure, Currency>> getPreferredCurrency();

  /// Persiste la moneda elegida por el usuario para futuras sesiones.
  Future<Result<Failure, void>> savePreferredCurrency(Currency currency);
}
