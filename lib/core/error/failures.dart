/// Clase base para representar errores de lógica de negocio o de sistema.
/// 
/// A diferencia de las excepciones, los [Failure] están diseñados para ser
/// propagados a través de las capas de la aplicación (Domain -> UI) de forma segura.
abstract class Failure {
  /// Mensaje descriptivo del error para depuración o logs.
  final String message;

  Failure(this.message);
}

/// Representa un error ocurrido en el servidor remoto.
class ServerFailure extends Failure {
  ServerFailure([super.message = 'Server Error']);
}

/// Representa un error al intentar acceder al almacenamiento local (cache/DB).
class CacheFailure extends Failure {
  CacheFailure([super.message = 'Cache Error']);
}

/// Representa un error de conectividad a internet.
class NetworkFailure extends Failure {
  NetworkFailure([super.message = 'Network Error']);
}
