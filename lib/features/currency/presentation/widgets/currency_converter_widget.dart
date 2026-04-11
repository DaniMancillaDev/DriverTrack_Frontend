import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/currency.dart';
import '../providers/currency_provider.dart';
import '../../../../core/i18n/translations.g.dart';
import '../../../../theme/app_theme.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../theme/app_color_scheme.dart';

class CurrencyConverterWidget extends ConsumerStatefulWidget {
  const CurrencyConverterWidget({super.key});

  @override
  ConsumerState<CurrencyConverterWidget> createState() =>
      _CurrencyConverterWidgetState();
}

class _CurrencyConverterWidgetState
    extends ConsumerState<CurrencyConverterWidget> {
  final _amountController = TextEditingController();
  double _amount = 0.0;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onAmountChanged(String value) {
    setState(() {
      _amount = double.tryParse(value) ?? 0.0;
    });
  }

  String _formatCurrency(double amount, Currency currency) {
    final formatter = NumberFormat.currency(
      symbol: currency.symbol,
      decimalDigits: 2,
      customPattern: '\u00A4#,##0.00',
    );
    return '${formatter.format(amount)} ${currency.code}';
  }

  @override
  Widget build(BuildContext context) {
    final currencyAsync = ref.watch(currencyNotifierProvider);
    final r = context.responsive;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(r.r(AppRadius.xl)),
      ),
      child: currencyAsync.when(
        data: (state) {
          final convertedAmount = ref
              .read(currencyNotifierProvider.notifier)
              .convert(_amount);
          final targetCurrency = state.activeCurrency == Currency.usd
              ? Currency.mxn
              : Currency.usd;
          final displayRate = state.activeCurrency == Currency.usd
              ? state.exchangeRate.rate
              : state.exchangeRate.invert().rate;

          return Padding(
            padding: EdgeInsets.all(r.space(AppSpacing.lg)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Translations.of(context).currency.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: context.colors.textMain,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => ref
                          .read(currencyNotifierProvider.notifier)
                          .refreshRates(),
                      child: Container(
                        width: r.dim(34),
                        height: r.dim(34),
                        decoration: BoxDecoration(
                          color: context.colors.surfaceLight,
                          borderRadius: BorderRadius.circular(r.r(AppRadius.s)),
                        ),
                        child: Icon(
                          Icons.refresh_rounded,
                          size: AppIconSizes.sm(context),
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: r.space(AppSpacing.lg)),

                // From currency row
                _CurrencyRow(
                  code: state.activeCurrency.code,
                  symbol: state.activeCurrency.symbol,
                  isPrimary: true,
                  child: TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: context.colors.textMain,
                      fontWeight: FontWeight.w800,
                    ),
                    decoration: InputDecoration(
                      hintText: '0.00',
                      hintStyle: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(
                            color: context.colors.textDim,
                            fontWeight: FontWeight.w600,
                          ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: _onAmountChanged,
                  ),
                ),

                // Swap button
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: r.space(AppSpacing.s),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: context.colors.borderLight,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => ref
                            .read(currencyNotifierProvider.notifier)
                            .toggleCurrency(),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: r.space(AppSpacing.md),
                          ),
                          width: r.dim(34),
                          height: r.dim(34),
                          decoration: BoxDecoration(
                            color: AppColors.orangePrimary.withValues(
                              alpha: 0.12,
                            ),
                            borderRadius: BorderRadius.circular(
                              r.r(AppRadius.s),
                            ),
                          ),
                          child: Icon(
                            Icons.swap_vert_rounded,
                            size: AppIconSizes.md(context),
                            color: AppColors.orangePrimary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: context.colors.borderLight,
                        ),
                      ),
                    ],
                  ),
                ),

                // To currency row
                _CurrencyRow(
                  code: targetCurrency.code,
                  symbol: targetCurrency.symbol,
                  isPrimary: false,
                  child: Text(
                    _amount > 0
                        ? _formatCurrency(convertedAmount, targetCurrency)
                        : '—',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.green,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                // Exchange rate footnote
                SizedBox(height: r.space(AppSpacing.md)),
                Text(
                  Translations.of(context).currency.rateDesc
                      .replaceAll('{from}', state.activeCurrency.code)
                      .replaceAll('{rate}', displayRate.toStringAsFixed(4))
                      .replaceAll('{to}', targetCurrency.code),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: context.colors.textMuted,
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
        loading: () => Padding(
          padding: EdgeInsets.all(r.space(AppSpacing.xl)),
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.orangePrimary,
            ),
          ),
        ),
        error: (err, stack) => Padding(
          padding: EdgeInsets.all(r.space(AppSpacing.xl)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(r.space(AppSpacing.lg)),
                decoration: BoxDecoration(
                  color: AppColors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi_off_rounded,
                  color: AppColors.red,
                  size: AppIconSizes.xl(context),
                ),
              ),
              SizedBox(height: r.space(AppSpacing.md)),
              Text(
                Translations.of(context).currency.errorLoadingRates,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: r.space(AppSpacing.lg)),
              GestureDetector(
                onTap: () =>
                    ref.read(currencyNotifierProvider.notifier).refreshRates(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.space(AppSpacing.xl),
                    vertical: r.space(AppSpacing.s),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.orangePrimary,
                    borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
                  ),
                  child: Text(
                    Translations.of(context).currency.tryAgain,
                    style: AppTextStyles.bodyMedium(context).copyWith(
                      color: Colors.white, // Safe: background is orange primary which needs white text
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CurrencyRow extends StatelessWidget {
  final String code;
  final String symbol;
  final bool isPrimary;
  final Widget child;

  const _CurrencyRow({
    required this.code,
    required this.symbol,
    required this.isPrimary,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    return Container(
      padding: EdgeInsets.all(r.space(AppSpacing.md)),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
      ),
      child: Row(
        children: [
          // Currency badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: r.space(AppSpacing.s),
              vertical: r.space(AppSpacing.xxs),
            ),
            decoration: BoxDecoration(
              color: context.colors.surfaceLight,
              borderRadius: BorderRadius.circular(r.r(AppRadius.s)),
            ),
            child: Text(
              code,
              style: AppTextStyles.caption(context).copyWith(
                color: isPrimary ? AppColors.orangePrimary : AppColors.green,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ),
          SizedBox(width: r.space(AppSpacing.md)),
          Expanded(child: child),
        ],
      ),
    );
  }
}
