import 'package:flutter/material.dart';
import '../../models/vehicle_type_model.dart';
import '../../theme/app_theme.dart';
import '../../core/i18n/translations.g.dart';
import '../../core/responsive/responsive.dart';
import '../../theme/app_color_scheme.dart';

class VehicleTypeToggle extends StatelessWidget {
  final List<VehicleType> vehicleTypes;
  final VehicleType selectedType;
  final Function(VehicleType) onChanged;

  const VehicleTypeToggle({
    super.key,
    required this.vehicleTypes,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            bottom: r.space(AppSpacing.xs),
            left: r.space(AppSpacing.xxs),
          ),
          child: Text(
            Translations.of(context).garage.vehicleType.toUpperCase(),
            style: AppTextStyles.label(
              context,
            ).copyWith(color: context.colors.textSecondary, letterSpacing: 0.6),
          ),
        ),
        Container(
          padding: EdgeInsets.all(r.space(AppSpacing.xxs)),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(r.r(AppRadius.xl)),
            // Removed caging border for white-space fluidity (Tip 1)
          ),
          child: Row(
            children: vehicleTypes.asMap().entries.map((entry) {
              final index = entry.key;
              final type = entry.value;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : r.space(AppSpacing.xxs),
                  ),
                  child: _buildTypeButton(context, type),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeButton(BuildContext context, VehicleType type) {
    final isActive = selectedType.id == type.id;
    final icon = _getIconData(type.icon);
    final r = context.responsive;

    return GestureDetector(
      onTap: () => onChanged(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: r.space(AppSpacing.s)),
        decoration: BoxDecoration(
          gradient: isActive ? AppColors.primaryGradient : null,
          borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.orangePrimary.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : context.colors.textDark,
              size: AppIconSizes.md(context),
            ),
            SizedBox(width: r.space(AppSpacing.xs)),
            Flexible(
              child: Text(
                type.icon == 'motorcycle_rounded' ||
                        type.slug.toLowerCase().contains('moto')
                    ? Translations.of(context).garage.vehicleTypes.motorcycle
                    : (type.icon == 'directions_car_filled_rounded' ||
                              type.slug.toLowerCase().contains('car')
                          ? Translations.of(context).garage.vehicleTypes.car
                          : type.label),
                style: AppTextStyles.bodyMedium(context).copyWith(
                  color: isActive ? Colors.white : context.colors.textDark,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static IconData _getIconData(String name) {
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
