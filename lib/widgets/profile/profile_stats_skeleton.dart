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
          // No border — real widget has no outer border
        ),
        child: Row(
          children: List.generate(3, (idx) {
            return Expanded(
              child: Row(
                children: [
                  // Divider between cells (matches Container 1px divider)
                  if (idx > 0)
                    Container(
                      width: 1,
                      height: r.dim(36),
                      margin: EdgeInsets.symmetric(
                        vertical: r.space(AppSpacing.md),
                      ),
                      color: Colors.white.withValues(alpha: 0.07),
                    ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: r.space(AppSpacing.md),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Value (number)
                          SkeletonLoader(
                            width: r.dim(36),
                            height: r.dim(22),
                            borderRadius: AppRadius.s,
                          ),
                          SizedBox(height: r.space(6)),
                          // Label
                          SkeletonLoader(width: r.dim(50), height: r.dim(11)),
                          SizedBox(height: r.space(4)),
                          // Sub label
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
