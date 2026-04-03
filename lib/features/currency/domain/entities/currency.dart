enum Currency {
  usd('USD', '\$'),
  mxn('MXN', '\$');

  final String code;
  final String symbol;

  const Currency(this.code, this.symbol);

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
