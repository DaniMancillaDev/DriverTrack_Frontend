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

class VehicleCard extends ConsumerStatefulWidget {
  final Vehicle vehicleData;
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
      maintenanceDocsProvider(MaintenanceParams(vehicleId: widget.vehicleData.id)),
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

  Widget _buildCard(BuildContext context, WidgetRef ref, VehicleViewModel v, List<dynamic> records) {
    final unitSystem = ref.watch(unitSystemProvider);
    final Color color = v.statusColor;
    final r = context.responsive;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final t = Translations.of(context);
    
    final scale = _isPressed ? 0.98 : 1.0;
    
    String statusText = v.status == 'critical' 
        ? t.garage.statusCritical 
        : (v.status == 'attention' ? t.garage.statusNeedsService : t.garage.statusHealthy);
        
    String getFormattedMileage() => UnitFormatter.formatDistance(v.mileage.toDouble(), unitSystem, fractionDigits: 0);
    
    final hasNextService = v.nextService != null && v.nextService != 'Pending Service Config';

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
          padding: EdgeInsets.all(r.space(20)),
          decoration: BoxDecoration(
             color: AppColors.surface,
             borderRadius: BorderRadius.circular(r.r(AppRadius.xl)),
             border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
                width: 1,
             ),
             boxShadow: [
               BoxShadow(
                 color: Colors.black.withValues(alpha: 0.15),
                 blurRadius: r.dim(24),
                 offset: Offset(0, r.dim(8)),
               )
             ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Cuadro de imagen izquierdo
              Container(
                width: r.dim(80),
                height: r.dim(80),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
                  color: AppColors.surfaceLight,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
                  child: Image.network(
                    v.displayImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          v.type.toLowerCase().contains('moto') 
                              ? Icons.motorcycle 
                              : Icons.directions_car,
                          color: AppColors.borderLight,
                          size: r.dim(32),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / 
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                          strokeWidth: 2,
                          color: color.withValues(alpha: 0.5),
                        ),
                      );
                    },
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
                    // Título y Dot de estado
                    Row(
                      children: [
                        Container(
                          width: r.dim(8),
                          height: r.dim(8),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.5),
                                blurRadius: 4,
                              )
                            ]
                          ),
                        ),
                        SizedBox(width: r.space(8)),
                        Expanded(
                          child: Text(
                            v.displayName,
                            style: textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: r.space(4)),
                    
                    // Metadato: Kilometraje • Placa
                    Row(
                      children: [
                        Icon(Icons.speed, size: r.dim(12), color: AppColors.textDim),
                        SizedBox(width: r.space(4)),
                        Expanded(
                          child: Text(
                            '${getFormattedMileage()}${v.plate.isNotEmpty ? ' • ${v.plate.toUpperCase()}' : ''}',
                            style: textTheme.labelMedium?.copyWith(
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: r.space(12)),
                    
                    // Footer: Estado de salud y accion/próximo servicio
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Tooltip(
                            message: statusText,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: r.space(8),
                                vertical: r.space(4),
                              ),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(r.r(AppRadius.s)),
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
                                    style: textTheme.labelSmall?.copyWith(
                                      color: color,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: r.space(8)),
                        
                        // Próximo servicio o flecha
                        if (hasNextService)
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.build_circle, size: r.dim(12), color: AppColors.orangeSecondary),
                                SizedBox(width: r.space(4)),
                                Flexible(
                                  child: Text(
                                    v.nextService!,
                                    style: textTheme.labelSmall?.copyWith(
                                      color: AppColors.orangeSecondary,
                                      fontWeight: FontWeight.w700,
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
                            Icons.arrow_forward_ios_rounded,
                            color: AppColors.borderLight,
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
    );
  }
}
