import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/responsive/responsive.dart';
import '../../theme/app_color_scheme.dart';
import '../../models/maintenance_model.dart';
import '../../viewmodels/vehicle_view_model.dart';

import '../../core/i18n/translations.g.dart';

class ProfileVehicleItem extends StatelessWidget {
  final String name;
  final String details;
  final Color color;
  final bool isFavorite;
  final VoidCallback? onTap;

  // ─── Nuevos campos para panel de acción ──────────────────
  final VehicleViewModel? viewModel;
  final List<Maintenance> maintenanceRecords;
  final VoidCallback? onLogService;

  const ProfileVehicleItem({
    super.key,
    required this.name,
    required this.details,
    required this.color,
    this.isFavorite = false,
    this.onTap,
    // Opcionales para mantener compatibilidad con usos anteriores
    this.viewModel,
    this.maintenanceRecords = const [],
    this.onLogService,
  });

  /// Último registro de mantenimiento ordenado por fecha desc.
  Maintenance? get _lastService {
    if (maintenanceRecords.isEmpty) return null;
    final sorted = [...maintenanceRecords]..sort((a, b) => b.date.compareTo(a.date));
    return sorted.first;
  }

  /// Texto relativo del último servicio: "hace 3 días" / "hace 2 meses" / "hace 1 año".
  String? _lastServiceText(BuildContext context, Translations t) {
    final last = _lastService;
    if (last == null) return null;
    final diff = DateTime.now().difference(last.date);
    
    if (diff.inDays < 1) return t.time.today;
    if (diff.inDays == 1) return t.time.yesterday;
    if (diff.inDays < 30) return t.time.daysAgo(n: diff.inDays);
    if (diff.inDays < 365) return t.time.monthsAgo(n: (diff.inDays / 30).floor());
    return t.time.yearsAgo(n: (diff.inDays / 365).floor());
  }

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    final vm = viewModel;
    final t = Translations.of(context);
    final lastText = _lastServiceText(context, t);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: r.space(AppSpacing.md),
          vertical: r.space(AppSpacing.s),
        ),
        decoration: BoxDecoration(color: context.colors.surface),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Fila principal ────────────────────────────
            Row(
              children: [
                // Ícono del vehículo
                Container(
                  width: r.dim(36),
                  height: r.dim(36),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
                  ),
                  child: Icon(
                    vm?.typeIcon ?? Icons.directions_car,
                    color: color,
                    size: AppIconSizes.sm(context),
                  ),
                ),
                SizedBox(width: r.space(AppSpacing.s)),
                // Nombre + detalles
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.bodySmall(context).copyWith(
                          color: context.colors.textMain,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        details,
                        style: AppTextStyles.label(
                          context,
                        ).copyWith(color: context.colors.textMuted),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Chip de salud
                if (vm != null) _HealthChip(viewModel: vm, r: r),
                if (isFavorite) ...[
                  SizedBox(width: r.space(AppSpacing.xs)),
                  Icon(
                    Icons.favorite_rounded,
                    size: AppIconSizes.xs(context),
                    color: AppColors.red,
                  ),
                ],
              ],
            ),

            // ─── Fila secundaria: último servicio + botón ──
            if (vm != null) ...[
              SizedBox(height: r.space(AppSpacing.xs)),
              Row(
                children: [
                  SizedBox(width: r.dim(36) + r.space(AppSpacing.s)), // alinear con texto
                  // Último servicio
                  Icon(
                    Icons.build_circle_outlined,
                    size: r.dim(11),
                    color: context.colors.textMuted,
                  ),
                  SizedBox(width: r.space(4)),
                  Expanded(
                    child: Text(
                      lastText != null
                          ? t.profile.lastServiceLabel(time: lastText)
                          : t.profile.noServicesLogged,
                      style: AppTextStyles.label(context).copyWith(
                        color: context.colors.textMuted,
                        fontSize: 10,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Botón rápido  "Registrar servicio"
                  if (onLogService != null)
                    _QuickServiceButton(
                      onTap: onLogService!,
                      r: r,
                      context: context,
                      label: t.profile.registerAction,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Chip de salud ────────────────────────────────────────────

class _HealthChip extends StatelessWidget {
  final VehicleViewModel viewModel;
  final AppResponsive r;

  const _HealthChip({required this.viewModel, required this.r});

  @override
  Widget build(BuildContext context) {
    final color = viewModel.statusColor;
    final pct = viewModel.healthPercentage.round();
    final icon = switch (viewModel.status) {
      'good' => Icons.check_circle_outline_rounded,
      'warning' => Icons.warning_amber_rounded,
      _ => Icons.error_outline_rounded,
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.space(AppSpacing.xs),
        vertical: r.space(3),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: r.dim(10), color: color),
          SizedBox(width: r.space(3)),
          Text(
            '$pct%',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Botón "Registrar servicio" ───────────────────────────────

class _QuickServiceButton extends StatelessWidget {
  final VoidCallback onTap;
  final AppResponsive r;
  final BuildContext context;
  final String label;

  const _QuickServiceButton({
    required this.onTap,
    required this.r,
    required this.context,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: r.space(AppSpacing.s),
          vertical: r.space(4),
        ),
        decoration: BoxDecoration(
          color: AppColors.orangePrimary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: AppColors.orangePrimary.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.build_rounded,
              size: r.dim(10),
              color: AppColors.orangePrimary,
            ),
            SizedBox(width: r.space(AppSpacing.xs)),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.orangePrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileAddAction extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const ProfileAddAction({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: r.space(AppSpacing.s)),
        color: context.colors.background,
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.bodySmall(context).copyWith(
              color: AppColors.orangePrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
