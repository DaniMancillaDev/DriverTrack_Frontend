/// Clase utilitaria para modelar resultados de operaciones que pueden fallar.
///
/// Inspirada en el patrón `Either<L, R>`, permite retornar un objeto que contiene
/// o bien un error ([L]) o bien un éxito ([R]), forzando al consumidor a manejar
/// ambos casos mediante el método [fold].
///
/// Ejemplo de uso:
/// ```dart
/// final result = await repository.getData();
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (data) => print('Éxito: $data'),
/// );
/// ```
class Result<L, R> {
  final L? _failure;
  final R? _success;

  /// Indica si la operación fue exitosa.
  final bool isSuccess;

  Result._(this._failure, this._success, this.isSuccess);

  /// Crea un resultado exitoso que contiene un valor [success].
  factory Result.success(R success) => Result._(null, success, true);

  /// Crea un resultado fallido que contiene un error [failure].
  factory Result.failure(L failure) => Result._(failure, null, false);

  /// Ejecuta [onSuccess] si la operación fue exitosa, o [onFailure] si falló.
  /// Retorna el valor producido por la función ejecutada.
  T fold<T>(T Function(L failure) onFailure, T Function(R success) onSuccess) {
    if (isSuccess) {
      return onSuccess(_success as R);
    }
    return onFailure(_failure as L);
  }
}
