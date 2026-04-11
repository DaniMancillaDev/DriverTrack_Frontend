import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../models/vehicle_model.dart';
import '../../viewmodels/vehicle_view_model.dart';
import '../../providers/app_providers.dart';
import '../../core/i18n/translations.g.dart';
import '../../core/units/presentation/unit_system_provider.dart';
import '../../core/units/domain/unit_formatter.dart';
import '../../core/responsive/responsive.dart';
import '../../theme/app_color_scheme.dart';

/// Tarjeta interactiva que representa un vehículo en el Garaje.
/// 
/// Este componente es una "Smart Component" que:
/// 1. Observa el historial de mantenimiento mediante [maintenanceDocsProvider].
/// 2. Determina el kilometraje real comparando el odómetro del vehículo con el último servicio.
/// 3. Utiliza [VehicleViewModel] para calcular el estado de salud (Healthy, Attention, Critical).
/// 4. Adapta las unidades de medida dinámicamente según [unitSystemProvider].
class VehicleCard extends ConsumerStatefulWidget {
  /// Entidad de datos del vehículo a mostrar.
  final Vehicle vehicleData;
  /// Callback disparado al tocar la tarjeta del vehículo.
  final VoidCallback onTap;

  const VehicleCard({
    super.key,
    required this.vehicleData,
    required this.onTap,
  });

  @override
  ConsumerState<VehicleCard> createState() => _VehicleCardState();
}

class _VehicleCardState extends ConsumerState<VehicleCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final maintenanceAsync = ref.watch(
      maintenanceDocsProvider(
        MaintenanceParams(vehicleId: widget.vehicleData.id),
      ),
    );

    return maintenanceAsync.maybeWhen(
      data: (records) {
        int realMileage = widget.vehicleData.mileage;
        if (records.isNotEmpty) {
          final maxRecorded = records
              .map((r) => r.mileage)
              .reduce((a, b) => a > b ? a : b);
          if (maxRecorded > realMileage) {
            realMileage = maxRecorded;
          }
        }

        final v = VehicleViewModel(widget.vehicleData, realMileage);
        return _buildCard(context, ref, v, records);
      },
      orElse: () {
        final v = VehicleViewModel(widget.vehicleData);
        return _buildCard(context, ref, v, []);
      },
    );
  }

  Widget _buildCard(
    BuildContext context,
    WidgetRef ref,
    VehicleViewModel v,
    List<dynamic> records,
  ) {
    final unitSystem = ref.watch(unitSystemProvider);
    final Color color = v.statusColor;
    final r = context.responsive;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final t = Translations.of(context);

    final scale = _isPressed ? 0.98 : 1.0;

    String statusText = v.status == 'critical'
        ? t.garage.statusCritical
        : (v.status == 'attention'
              ? t.garage.statusNeedsService
              : t.garage.statusHealthy);

    String getFormattedMileage() => UnitFormatter.formatDistance(
      v.mileage.toDouble(),
      unitSystem,
      fractionDigits: 0,
    );

    final hasNextService =
        v.nextService != null && v.nextService != 'Pending Service Config';

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: Container(
          margin: EdgeInsets.only(bottom: r.space(AppSpacing.md)),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(r.r(AppRadius.xl)),
            border: Border.all(
               color: context.colors.border.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: context.colors.isDark
                    ? Colors.black.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.06),
                blurRadius: r.dim(24),
                offset: Offset(0, r.dim(8)),
              ),
            ],
          ),
          // ClipRRect para respetar el border-radius en el ribbon
          child: ClipRRect(
            borderRadius: BorderRadius.circular(r.r(AppRadius.xl)),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Status Ribbon ─────────────────────────────────────────
                  // Barra lateral de 4px que comunica la salud del vehículo
                  // verde = saludable, amarillo = atención, rojo = crítico
                  Container(
                    width: r.dim(4),
                    decoration: BoxDecoration(
                      color: color,
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.5),
                          blurRadius: 6,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),

                  // ── Contenido principal de la card ────────────────────────
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(r.space(20)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Cuadro de imagen izquierdo
                          Container(
                            width: r.dim(80),
                            height: r.dim(80),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                r.r(AppRadius.lg),
                              ),
                              color: context.colors.surfaceLight,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                r.r(AppRadius.lg),
                              ),
                              child: v.displayImageUrl.startsWith('http')
                                  ? Image.network(
                                      v.displayImageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Center(
                                          child: Icon(
                                            v.typeIcon,
                                            color: context.colors.borderLight,
                                            size: r.dim(32),
                                          ),
                                        );
                                      },
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    (loadingProgress
                                                            .expectedTotalBytes ??
                                                        1)
                                                : null,
                                            strokeWidth: 2,
                                            color: color.withValues(alpha: 0.5),
                                          ),
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      v.displayImageUrl,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          SizedBox(width: r.space(16)),

                          // Columna de contenido derecho
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Título (sin dot — el ribbon ya comunica el estado)
                                Text(
                                  v.displayName,
                                  style: textTheme.titleMedium?.copyWith(
                                    color: context.colors.textMain,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: r.space(4)),

                                // Metadato: Kilometraje • Placa
                                Row(
                                  children: [
                                    Icon(
                                      Icons.speed,
                                      size: r.dim(12),
                                      color: context.colors.textDim,
                                    ),
                                    SizedBox(width: r.space(4)),
                                    Expanded(
                                      child: Text(
                                        '${getFormattedMileage()}${v.plate.isNotEmpty ? ' • ${v.plate.toUpperCase()}' : ''}',
                                        style: textTheme.labelMedium?.copyWith(
                                          color: context.colors.textMuted,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: r.space(12)),

                                // Footer: health badge + próximo servicio
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: r.space(8),
                                            vertical: r.space(4),
                                          ),
                                          decoration: BoxDecoration(
                                            color: color.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(
                                              r.r(AppRadius.s),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: r.dim(6),
                                                height: r.dim(6),
                                                decoration: BoxDecoration(
                                                  color: color,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              SizedBox(width: r.space(5)),
                                              Text(
                                                '${v.healthPercentage.round()}%',
                                                style: textTheme.labelSmall
                                                    ?.copyWith(
                                                      color: color,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                              ),
                                            ],
                                          ),
                                      ),
                                    ),
                                    SizedBox(width: r.space(8)),

                                    // Próximo servicio o flecha
                                    if (hasNextService)
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Icon(
                                              Icons.build_circle,
                                              size: r.dim(12),
                                              color: AppColors.orangeSecondary,
                                            ),
                                            SizedBox(width: r.space(4)),
                                            Flexible(
                                              child: Text(
                                                v.nextService!,
                                                style: textTheme.labelSmall
                                                    ?.copyWith(
                                                      color:
                                                          AppColors
                                                              .orangeSecondary,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    else
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: context.colors.borderLight,
                                        size: r.dim(12),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
