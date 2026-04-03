import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/vehicle_type_model.dart';
import '../../theme/app_theme.dart';
import '../../core/i18n/translations.g.dart';
import '../../core/responsive/responsive.dart';
import '../../core/units/presentation/unit_system_provider.dart';
import '../../core/units/domain/unit_system.dart';

class VehiclePreviewCard extends ConsumerWidget {
  final VehicleType? type;
  final String? brand;
  final String model;
  final String? year;
  final String plate;
  final String mileage;

  const VehiclePreviewCard({
    super.key,
    required this.type,
    this.brand,
    required this.model,
    this.year,
    required this.plate,
    required this.mileage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = context.responsive;
    final isMetric = ref.watch(unitSystemProvider) == UnitSystem.metric;
    final t = Translations.of(context);
    final unitShort = isMetric ? t.garage.unitKmShort : t.garage.unitMiShort;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final titleParts = [
      brand,
      model,
      year,
    ].where((e) => e != null && e.isNotEmpty).toList();
    
    final title = titleParts.isEmpty ? t.garage.yourVehicle : titleParts.join(' ');

    return Container(
      padding: EdgeInsets.all(r.space(AppSpacing.md)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(r.r(AppRadius.xl)),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: r.dim(48),
            height: r.dim(48),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.orangePrimary.withValues(alpha: 0.2),
                  AppColors.orangePrimary.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
              border: Border.all(
                color: AppColors.orangePrimary.withValues(alpha: 0.3),
              ),
            ),
            child: Icon(
              _getIconData(type?.icon),
              color: AppColors.orangePrimary,
              size: r.dim(24),
            ),
          ),
          SizedBox(width: r.space(AppSpacing.md)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: r.space(AppSpacing.xs)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (plate.isNotEmpty) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: r.space(8),
                          vertical: r.space(2),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(r.r(AppRadius.s)),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Text(
                          plate.toUpperCase(),
                          style: textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      if (mileage.isNotEmpty)
                        SizedBox(width: r.space(AppSpacing.s)),
                    ],
                    if (mileage.isNotEmpty) ...[
                      Icon(
                        Icons.speed,
                        size: r.dim(12),
                        color: AppColors.textDim,
                      ),
                      SizedBox(width: r.space(4)),
                      Text(
                        '$mileage $unitShort',
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    if (plate.isEmpty && mileage.isEmpty)
                      Text(
                        t.garage.plateNotSet,
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.textDim,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static IconData _getIconData(String? name) {
    switch (name) {
      case 'directions_car_filled_rounded':
        return Icons.directions_car_filled_rounded;
      case 'motorcycle_rounded':
        return Icons.motorcycle_rounded;
      default:
        return Icons.directions_car;
    }
  }
}
