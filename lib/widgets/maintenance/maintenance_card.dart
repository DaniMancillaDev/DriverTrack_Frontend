import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/maintenance_view_model.dart';
import '../ui/custom_list_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/units/presentation/unit_system_provider.dart';
import '../../core/units/domain/unit_formatter.dart';
import '../../features/currency/presentation/widgets/currency_display.dart';
import '../../core/responsive/responsive.dart';
import '../../core/i18n/translations.g.dart';
import '../../theme/app_color_scheme.dart';

/// Una tarjeta de resumen para registros de mantenimiento en listas.
/// 
/// Provee una previsualización compacta de una intervención, resaltando el 
/// costo y la categoría mediante colores de acento. Incluye micro-interacciones 
/// táctiles ([AnimatedScale]) para mejorar el feedback visual al presionar.
class MaintenanceCard extends ConsumerStatefulWidget {
  /// ViewModel con la lógica de presentación del registro.
  final MaintenanceViewModel vm;
  /// Nombre legible del vehículo asociado (para contexto en listas globales).
  final String vehicleName;
  /// Callback al presionar para ver detalles completos.
  final VoidCallback onTap;

  const MaintenanceCard({
    super.key,
    required this.vm,
    required this.vehicleName,
    required this.onTap,
  });

  @override
  ConsumerState<MaintenanceCard> createState() => _MaintenanceCardState();
}

class _MaintenanceCardState extends ConsumerState<MaintenanceCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final unitSystem = ref.watch(unitSystemProvider);
    final r = context.responsive;
    final accent = widget.vm.computedAccent;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
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
          child: Padding(
            padding: EdgeInsets.all(r.space(AppSpacing.lg)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ícono de categoría con fondo accent
                Container(
                  width: r.dim(44),
                  height: r.dim(44),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
                  ),
                  child: Icon(
                    widget.vm.computedIcon,
                    color: accent,
                    size: AppIconSizes.md(context),
                  ),
                ),
                SizedBox(width: r.space(AppSpacing.lg)),

                // Información central
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.vm.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: context.colors.textMain,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.4,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: r.space(AppSpacing.xxs)),

                      // Meta: vehículo · fecha · km
                      Text(
                        '${widget.vehicleName} · ${DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(widget.vm.date)} · ${UnitFormatter.formatDistance(widget.vm.mileage.toDouble(), unitSystem, fractionDigits: 0)}',
                        style: AppTextStyles.caption(context).copyWith(
                          color: context.colors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: r.space(AppSpacing.xs)),

                      // Chip de categoría — visibilidad instantánea del tipo de servicio
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: r.space(AppSpacing.xs),
                          vertical: r.space(3),
                        ),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(r.r(AppRadius.s)),
                        ),
                        child: Text(
                          widget.vm.category.isNotEmpty
                              ? widget.vm.category
                              : Translations.of(context).maintenance.categoryGeneral,
                          style: AppTextStyles.tiny(context).copyWith(
                            color: accent,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),

                      if (widget.vm.notes != null) ...[
                        SizedBox(height: r.space(AppSpacing.s)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: r.space(AppSpacing.s),
                            vertical: r.space(4),
                          ),
                          decoration: BoxDecoration(
                            color: context.colors.surfaceLight,
                            borderRadius:
                                BorderRadius.circular(r.r(AppRadius.s)),
                          ),
                          child: Text(
                            widget.vm.notes!,
                            style: AppTextStyles.caption(context).copyWith(
                              color: context.colors.textSecondary,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Costo en color accent para jerarquía visual
                SizedBox(width: r.space(AppSpacing.md)),
                if (widget.vm.cost > 0)
                  CurrencyDisplay(
                    amount: widget.vm.cost,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w800,
                    ),
                  )
                else
                  Text(
                    Translations.of(context).common.free,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.green,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
