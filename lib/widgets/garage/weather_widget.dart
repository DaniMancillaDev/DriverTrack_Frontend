/// Widget de clima para el dashboard del garaje.
///
/// Consume datos reales de OpenWeatherMap via [weatherProvider].
/// Muestra estados de loading, error y data con recomendaciones
/// de conducción generadas por el motor de reglas.

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/responsive/responsive.dart';
import '../../core/i18n/translations.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/units/presentation/unit_system_provider.dart';
import '../../core/units/domain/unit_formatter.dart';
import '../../features/weather/presentation/providers/weather_provider.dart';
import '../../features/weather/domain/entities/weather_entity.dart';
import '../../features/weather/domain/entities/weather_recommendation.dart';
import '../../theme/app_color_scheme.dart';

class WeatherWidget extends ConsumerWidget {
  const WeatherWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);
    final r = context.responsive;

    return weatherAsync.when(
      loading: () => _buildLoadingState(context, r),
      error: (error, _) => _buildErrorState(context, r, ref),
      data: (weatherState) => _buildDataState(context, r, ref, weatherState),
    );
  }

  // ─── Data State ──────────────────────────────────────────────

  Widget _buildDataState(
    BuildContext context,
    AppResponsive r,
    WidgetRef ref,
    WeatherState weatherState,
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final t = Translations.of(context);
    final unitSystem = ref.watch(unitSystemProvider);
    final weather = weatherState.weather;
    final recommendation = weatherState.primaryRecommendation;

    // Determinar color accent según severidad
    final accentColor = _getAccentColor(recommendation);
    final bg = accentColor.withValues(alpha: 0.08);

    // Formatear temperatura con el sistema de unidades existente
    final formattedTemp = UnitFormatter.formatTemperature(
      weather.temperatureCelsius,
      unitSystem,
      fractionDigits: 0,
    );

    // Traducir condición climática
    final conditionText = _getConditionText(weather.condition, t);

    // Texto de la recomendación
    final adviceText = _getRecommendationText(recommendation, t);

    return Container(
      padding: EdgeInsets.all(r.space(AppSpacing.lg)),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(r.r(AppRadius.xl)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: r.dim(40),
                      height: r.dim(40),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
                      ),
                      child: Icon(
                        _getWeatherIcon(weather.condition),
                        color: accentColor,
                        size: AppIconSizes.lg(context),
                      ),
                    ),
                    SizedBox(width: r.space(AppSpacing.s)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                t.weather.alert,
                                style: textTheme.labelSmall?.copyWith(
                                  color: context.colors.textMuted,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              if (weatherState.isFallbackLocation) ...[
                                SizedBox(width: r.space(AppSpacing.xxs)),
                                Icon(
                                  Icons.location_off,
                                  color: context.colors.textMuted,
                                  size: AppIconSizes.xs(context),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            '$conditionText · $formattedTemp',
                            style: textTheme.titleMedium?.copyWith(
                              color: context.colors.textMain,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildWeatherStat(
                    context,
                    Icons.opacity,
                    '${weather.humidity}%',
                    AppColors.cyan,
                  ),
                  SizedBox(height: r.space(AppSpacing.xxs)),
                  _buildWeatherStat(
                    context,
                    Icons.thermostat,
                    formattedTemp,
                    AppColors.orangeSecondary,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: r.space(AppSpacing.md)),
          Container(
            padding: EdgeInsets.all(r.space(AppSpacing.s)),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
              border: Border.all(color: accentColor.withValues(alpha: 0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  recommendation?.icon ?? Icons.check_circle_outline,
                  color: accentColor,
                  size: AppIconSizes.sm(context),
                ),
                SizedBox(width: r.space(AppSpacing.s)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        adviceText,
                        style: textTheme.bodySmall?.copyWith(
                          color: context.colors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: r.space(AppSpacing.xxs)),
                      GestureDetector(
                        onTap: () => _showCityInputDialog(context, ref),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: r.dim(10),
                              color: AppColors.orangeSecondary,
                            ),
                            SizedBox(width: 2),
                            Text(
                              weather.cityName,
                              style: textTheme.labelSmall?.copyWith(
                                color: AppColors.orangeSecondary,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 2),
                            Icon(
                              Icons.edit_rounded,
                              size: 9,
                              color: AppColors.orangeSecondary.withValues(alpha: 0.6),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCityInputDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _CityInputDialog(ref: ref),
    );
  }

  // ─── Loading State ───────────────────────────────────────────

  Widget _buildLoadingState(BuildContext context, AppResponsive r) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    const accent = AppColors.cyan;
    final bg = accent.withValues(alpha: 0.08);

    return Container(
      padding: EdgeInsets.all(r.space(AppSpacing.lg)),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(r.r(AppRadius.xxl)),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Container(
            width: r.dim(40),
            height: r.dim(40),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
            ),
            child: Icon(
              Icons.cloud_outlined,
              color: accent,
              size: AppIconSizes.lg(context),
            ),
          ),
          SizedBox(width: r.space(AppSpacing.s)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Translations.of(context).weather.alert,
                  style: textTheme.labelSmall?.copyWith(
                    color: context.colors.textMuted,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: r.space(AppSpacing.xxs)),
                SizedBox(
                  width: r.dim(120),
                  child: LinearProgressIndicator(
                    backgroundColor: context.colors.surfaceLight,
                    color: accent,
                    borderRadius: BorderRadius.circular(r.r(AppRadius.xs)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Error State ─────────────────────────────────────────────

  Widget _buildErrorState(
    BuildContext context,
    AppResponsive r,
    WidgetRef ref,
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    const accent = AppColors.red;
    final bg = accent.withValues(alpha: 0.08);

    return GestureDetector(
      onTap: () => ref.read(weatherProvider.notifier).refresh(),
      child: Container(
        padding: EdgeInsets.all(r.space(AppSpacing.lg)),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(r.r(AppRadius.xl)),
        ),
        child: Row(
          children: [
            Container(
              width: r.dim(40),
              height: r.dim(40),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
              ),
              child: Icon(
                Icons.cloud_off,
                color: accent,
                size: AppIconSizes.lg(context),
              ),
            ),
            SizedBox(width: r.space(AppSpacing.s)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Translations.of(context).weather.unavailable,
                    style: textTheme.titleMedium?.copyWith(
                      color: context.colors.textMain,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    Translations.of(context).weather.tapToRetry,
                    style: textTheme.bodySmall?.copyWith(
                      color: context.colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.refresh,
              color: context.colors.textMuted,
              size: AppIconSizes.md(context),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────

  Widget _buildWeatherStat(
    BuildContext context,
    IconData icon,
    String value,
    Color color,
  ) {
    final r = context.responsive;
    return Row(
      children: [
        Icon(icon, color: color, size: AppIconSizes.xs(context)),
        SizedBox(width: r.space(4)),
        Text(
          value,
          style: AppTextStyles.label(
            context,
          ).copyWith(color: context.colors.textMuted),
        ),
      ],
    );
  }

  /// Retorna color accent según la severidad de la recomendación.
  Color _getAccentColor(WeatherRecommendation? rec) {
    if (rec == null) return AppColors.green;
    return switch (rec.severity) {
      RecommendationSeverity.critical => AppColors.red,
      RecommendationSeverity.warning => AppColors.orangeSecondary,
      RecommendationSeverity.info => AppColors.cyan,
    };
  }

  /// Retorna el icono del clima según la condición.
  IconData _getWeatherIcon(WeatherCondition condition) {
    return switch (condition) {
      WeatherCondition.clear => Icons.wb_sunny,
      WeatherCondition.clouds => Icons.cloud_outlined,
      WeatherCondition.rain => Icons.water_drop,
      WeatherCondition.drizzle => Icons.grain,
      WeatherCondition.thunderstorm => Icons.flash_on,
      WeatherCondition.snow => Icons.ac_unit,
      WeatherCondition.fog => Icons.cloud,
      WeatherCondition.extreme => Icons.warning_amber_rounded,
      WeatherCondition.unknown => Icons.cloud_outlined,
    };
  }

  /// Traduce la condición climática a texto legible.
  String _getConditionText(WeatherCondition condition, Translations t) {
    return switch (condition) {
      WeatherCondition.clear => t.weather.conditions.clear,
      WeatherCondition.clouds => t.weather.conditions.cloudy,
      WeatherCondition.rain => t.weather.conditions.rainy,
      WeatherCondition.drizzle => t.weather.conditions.drizzle,
      WeatherCondition.thunderstorm => t.weather.conditions.storm,
      WeatherCondition.snow => t.weather.conditions.snow,
      WeatherCondition.fog => t.weather.conditions.foggy,
      WeatherCondition.extreme => t.weather.conditions.extreme,
      WeatherCondition.unknown => t.weather.conditions.variable,
    };
  }

  /// Obtiene el texto de recomendación.
  String _getRecommendationText(WeatherRecommendation? rec, Translations t) {
    if (rec == null) return t.weather.recommendations.stable;
    return switch (rec.messageKey) {
      'extremeHeat' => t.weather.recommendations.extremeHeat,
      'stayHydrated' => t.weather.recommendations.stayHydrated,
      'freezing' => t.weather.recommendations.freezing,
      'coldWeather' => t.weather.recommendations.coldWeather,
      'rainyConditions' => t.weather.recommendations.rainyConditions,
      'thunderstorm' => t.weather.recommendations.thunderstorm,
      'snowConditions' => t.weather.recommendations.snowConditions,
      'foggyConditions' => t.weather.recommendations.foggyConditions,
      'strongWind' => t.weather.recommendations.strongWind,
      'extremeWeather' => t.weather.recommendations.extremeWeather,
      _ => t.weather.recommendations.stable,
    };
  }
}

// ─── City Input Dialog ───────────────────────────────────────

/// Dialog para cambiar la ciudad del clima manualmente.
///
/// Incluye:
/// - Validación en tiempo real (ciudad no encontrada → muestra error inline)
/// - Indicador de carga mientras busca
/// - Botón "Usar GPS" para volver al modo automático
class _CityInputDialog extends StatefulWidget {
  final WidgetRef ref;

  const _CityInputDialog({required this.ref});

  @override
  State<_CityInputDialog> createState() => _CityInputDialogState();
}

class _CityInputDialogState extends State<_CityInputDialog> {
  final _controller = TextEditingController();
  bool _isLoading = false;
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final city = _controller.text.trim();
    if (city.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      await widget.ref.read(weatherProvider.notifier).setManualCity(city);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          // Detecta si el error fue 404 (ciudad no encontrada)
          final msg = e.toString().toLowerCase();
          if (msg.contains('404') || msg.contains('not found') || msg.contains('ciudad')) {
            _errorText = Translations.of(context).weather.cityNotFound;
          } else {
            _errorText = Translations.of(context).weather.cityNotFound;
          }
        });
      }
    }
  }

  void _useGps() {
    widget.ref.read(weatherProvider.notifier).setManualCity('');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final r = context.responsive;

    return AlertDialog(
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(r.r(AppRadius.xl)),
      ),
      title: Row(
        children: [
          Icon(
            Icons.location_city_rounded,
            color: AppColors.orangePrimary,
            size: AppIconSizes.md(context),
          ),
          SizedBox(width: r.space(AppSpacing.s)),
          Text(
            t.weather.changeCityTitle,
            style: AppTextStyles.title(context).copyWith(
              color: context.colors.textMain,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _search(),
            style: AppTextStyles.body(context).copyWith(
              color: context.colors.textMain,
            ),
            decoration: InputDecoration(
              hintText: t.weather.changeCityHint,
              hintStyle: AppTextStyles.body(context).copyWith(
                color: context.colors.textMuted,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: context.colors.textMuted,
                size: AppIconSizes.sm(context),
              ),
              filled: true,
              fillColor: context.colors.surfaceLight,
              errorText: _errorText,
              errorStyle: TextStyle(
                color: AppColors.red,
                fontSize: 11,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
                borderSide: BorderSide(
                  color: AppColors.orangePrimary.withValues(alpha: 0.6),
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
                borderSide: BorderSide(color: AppColors.red, width: 1),
              ),
            ),
          ),
        ],
      ),
      actions: [
        // Botón GPS (regresa a detección automática)
        TextButton.icon(
          onPressed: _isLoading ? null : _useGps,
          icon: Icon(
            Icons.gps_fixed_rounded,
            size: AppIconSizes.xs(context),
            color: context.colors.textMuted,
          ),
          label: Text(
            t.weather.useGps,
            style: TextStyle(color: context.colors.textMuted),
          ),
        ),
        // Botón Buscar
        FilledButton(
          onPressed: _isLoading ? null : _search,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.orangePrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
            ),
          ),
          child: _isLoading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(t.weather.search),
        ),
      ],
    );
  }
}
