/// A simple Result class to represent either a success or a failure
/// similar to Either&lt;L, R&gt; in dartz or fpdart.
class Result<L, R> {
  final L? _failure;
  final R? _success;
  final bool isSuccess;

  Result._(this._failure, this._success, this.isSuccess);

  factory Result.success(R success) => Result._(null, success, true);
  factory Result.failure(L failure) => Result._(failure, null, false);

  T fold<T>(
    T Function(L failure) onFailure,
    T Function(R success) onSuccess,
  ) {
    if (isSuccess) {
      return onSuccess(_success as R);
    }
    return onFailure(_failure as L);
  }
}
