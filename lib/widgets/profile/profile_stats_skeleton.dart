import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/responsive/responsive.dart';
import '../ui/skeleton_loader.dart';
import '../../theme/app_color_scheme.dart';

class ProfileStatsSkeleton extends StatelessWidget {
  const ProfileStatsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.space(AppSpacing.lg)),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(r.r(AppRadius.xl)),
          // Sin borde — el widget real no tiene borde exterior
        ),
        child: Row(
          children: List.generate(2, (idx) {
            return Expanded(
              child: Row(
                children: [
                  // Divisor entre celdas (coincide con el divisor de 1px del Container)
                  if (idx > 0)
                    Container(
                      width: 1,
                      height: r.dim(36),
                      margin: EdgeInsets.symmetric(
                        vertical: r.space(AppSpacing.md),
                      ),
                      color: context.colors.borderLight,
                    ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: r.space(AppSpacing.md),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Valor (número)
                          SkeletonLoader(
                            width: r.dim(36),
                            height: r.dim(22),
                            borderRadius: AppRadius.s,
                          ),
                          SizedBox(height: r.space(6)),
                          // Etiqueta
                          SkeletonLoader(width: r.dim(50), height: r.dim(11)),
                          SizedBox(height: r.space(4)),
                          // Sub-etiqueta
                          SkeletonLoader(width: r.dim(38), height: r.dim(10)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
