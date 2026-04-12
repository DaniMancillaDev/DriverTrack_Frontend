import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/responsive/responsive.dart';
import '../ui/skeleton_loader.dart';
import '../../theme/app_color_scheme.dart';

class MaintenanceCardSkeleton extends StatelessWidget {
  const MaintenanceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return Container(
      margin: EdgeInsets.only(bottom: r.space(AppSpacing.md)),
      padding: EdgeInsets.all(r.space(AppSpacing.lg)),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contenedor de icono (44×44)
          SkeletonLoader(
            width: r.dim(44),
            height: r.dim(44),
            borderRadius: AppRadius.md,
          ),
          SizedBox(width: r.space(AppSpacing.lg)),

          // Columna de información central
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fila de punto + título
                Row(
                  children: [
                    SkeletonLoader(
                      width: r.dim(8),
                      height: r.dim(8),
                      borderRadius: 99,
                    ),
                    SizedBox(width: r.space(AppSpacing.s)),
                    SkeletonLoader(width: r.dim(110), height: r.dim(16)),
                  ],
                ),
                SizedBox(height: r.space(AppSpacing.xs)),

                // Cadena meta: vehículo • fecha • kilometraje
                SkeletonLoader(width: r.dim(180), height: r.dim(12)),

                SizedBox(height: r.space(AppSpacing.s)),

                // Píldora de notas (opcional, siempre muestra marcador)
                SkeletonLoader(
                  width: double.infinity,
                  height: r.dim(28),
                  borderRadius: AppRadius.s,
                ),
              ],
            ),
          ),

          SizedBox(width: r.space(AppSpacing.md)),

          // Costo final
          SkeletonLoader(width: r.dim(52), height: r.dim(20)),
        ],
      ),
    );
  }
}
