import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/responsive/responsive.dart';
import '../../theme/app_color_scheme.dart';

/// Define un punto de dato individual para el componente de estadísticas.
class StatItem {
  /// Etiqueta descriptiva de la métrica.
  final String label;
  /// Valor textual a mostrar (opcional si se provee [customValue]).
  final String? value;
  /// Widget personalizado para representar el valor (ej: indicador de salud).
  final Widget? customValue;
  /// Color semántico para resaltar la importancia del dato.
  final Color accent;

  StatItem({
    required this.label,
    this.value,
    this.customValue,
    required this.accent,
  }) : assert(value != null || customValue != null);
}

/// Un panel horizontal de métricas y estadísticas clave.
/// 
/// Organiza una lista de [StatItem] en una fila dividida por separadores 
/// verticales sutíles. Es utilizado en dashboards para dar visibilidad rápida 
/// a costos, kilometraje o salud de flota.
class SummaryStats extends StatelessWidget {
  /// Lista de métricas a mostrar.
  final List<StatItem> stats;

  const SummaryStats({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.surfaceLight,
        border: Border.all(color: context.colors.borderLight, width: 1.0),
        borderRadius: BorderRadius.circular(r.r(AppRadius.xl)),
      ),
      child: Row(
        children: () {
          final List<Widget> cells = [];
          for (int i = 0; i < stats.length; i++) {
            final StatItem stat = stats[i];
            cells.add(
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.space(AppSpacing.md),
                    vertical: r.space(AppSpacing.lg),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (stat.customValue != null)
                        stat.customValue!
                      else if (stat.value != null)
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            stat.value!,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: stat.accent,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                ),
                          ),
                        ),
                      SizedBox(height: r.space(4)),
                      Text(
                        stat.label.toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.tiny(context).copyWith(
                          color: context.colors.textMuted,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
            if (i < stats.length - 1) {
              cells.add(
                Container(
                  width: 1,
                  height: 36,
                  margin: EdgeInsets.symmetric(
                    vertical: r.space(AppSpacing.md),
                  ),
                  color: context.colors.border,
                ),
              );
            }
          }
          return cells;
        }(),
      ),
    );
  }
}
