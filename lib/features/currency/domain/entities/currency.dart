/// Define las monedas soportadas para transacciones y visualización de costos.
enum Currency {
  /// Dólar estadounidense.
  usd('USD', '\$'),
  /// Peso mexicano.
  mxn('MXN', '\$');

  /// Código ISO de la moneda (ej. 'USD').
  final String code;
  /// Símbolo visual (ej. '\$').
  final String symbol;

  const Currency(this.code, this.symbol);

  /// Convierte una cadena de texto (ej. 'USD') a su representación [Currency].
  /// 
  /// Por defecto retorna [Currency.mxn] si el formato no coincide.
  factory Currency.fromString(String code) {
    switch (code.toUpperCase()) {
      case 'USD':
        return Currency.usd;
      case 'MXN':
      default:
        return Currency.mxn;
    }
  }
}
