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
        color: AppColors.surface,
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
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              if (weatherState.isFallbackLocation) ...[
                                SizedBox(width: r.space(AppSpacing.xxs)),
                                Icon(
                                  Icons.location_off,
                                  color: AppColors.textMuted,
                                  size: AppIconSizes.xs(context),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            '$conditionText · $formattedTemp',
                            style: textTheme.titleMedium?.copyWith(
                              color: AppColors.textMain,
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
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: r.space(AppSpacing.xxs)),
                      GestureDetector(
                        onTap: () => _showCityInputDialog(context, ref),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              weather.cityName,
                              style: textTheme.labelSmall?.copyWith(
                                color: AppColors.textDark,
                                fontSize: 9,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.textDark.withValues(alpha: 0.5),
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.edit, size: 10, color: AppColors.textDark),
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
    final controller = TextEditingController();
    final r = context.responsive;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Cambiar Ciudad',
          style: AppTextStyles.title(context).copyWith(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: AppTextStyles.body(context).copyWith(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Ej. Monterrey, MX',
            hintStyle: AppTextStyles.body(context).copyWith(color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.surfaceLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(weatherProvider.notifier).setManualCity('');
              Navigator.pop(context);
            },
            child: Text('Usar GPS / Auto', style: TextStyle(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(weatherProvider.notifier).setManualCity(controller.text);
              }
              Navigator.pop(context);
            },
            child: Text('Buscar', style: TextStyle(color: AppColors.orangePrimary)),
          ),
        ],
      ),
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(r.r(AppRadius.xxl)),
        border: Border.all(color: AppColors.border),
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
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: r.space(AppSpacing.xxs)),
                SizedBox(
                  width: r.dim(120),
                  child: LinearProgressIndicator(
                    backgroundColor: AppColors.surfaceLight,
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

  Widget _buildErrorState(BuildContext context, AppResponsive r, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    const accent = AppColors.red;
    final bg = accent.withValues(alpha: 0.08);

    return GestureDetector(
      onTap: () => ref.read(weatherProvider.notifier).refresh(),
      child: Container(
        padding: EdgeInsets.all(r.space(AppSpacing.lg)),
        decoration: BoxDecoration(
          color: AppColors.surface,
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
                      color: AppColors.textMain,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    Translations.of(context).weather.tapToRetry,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.refresh,
              color: AppColors.textMuted,
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
          style: AppTextStyles.label(context).copyWith(color: AppColors.textMuted),
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
