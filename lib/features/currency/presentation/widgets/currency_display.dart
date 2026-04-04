import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/currency.dart';
import '../../domain/currency_formatter.dart';
import '../providers/currency_provider.dart';

/// Un widget que muestra un monto garantizado formatado en la divisa preferida.
/// Se actualiza de manera reactiva cada vez que el usuario alterna divisas
/// o el tipo de cambio se renueva.
class CurrencyDisplay extends ConsumerWidget {
  /// El monto guardado en base de datos.
  final double amount;

  /// La divisa del monto como está almacenado. Se asume USD por defecto.
  final Currency baseCurrency;

  /// El estilo de texto para el número mostrado.
  final TextStyle? style;

  const CurrencyDisplay({
    super.key,
    required this.amount,
    this.baseCurrency = Currency.usd,
    this.style,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escucha el estado global de divisas
    final currencyAsync = ref.watch(currencyNotifierProvider);

    // Si aún está cargando o falla, mostramos el formato seguro default
    final fallbackText = CurrencyFormatter.format(
      amount,
      baseCurrency: baseCurrency,
      targetCurrency: baseCurrency,
      exchangeRate: 1.0,
    );

    return currencyAsync.when(
      data: (state) {
        // La ExchangeRate en el provider siempre guarda baseCurrency=USD como convención
        final rateValue = state.exchangeRate.rate;

        final formattedValue = CurrencyFormatter.format(
          amount,
          baseCurrency: baseCurrency,
          targetCurrency: state.activeCurrency,
          exchangeRate: rateValue,
        );

        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(formattedValue, style: style, maxLines: 1),
        );
      },
      loading: () => FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          fallbackText,
          style: style?.copyWith(color: Colors.grey),
          maxLines: 1,
        ),
      ),
      error: (_, __) => FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(fallbackText, style: style, maxLines: 1),
      ),
    );
  }
}
