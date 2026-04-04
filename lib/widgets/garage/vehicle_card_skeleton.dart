import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/responsive/responsive.dart';
import '../ui/skeleton_loader.dart';
import '../../theme/app_color_scheme.dart';

class VehicleCardSkeleton extends StatelessWidget {
  const VehicleCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return Container(
      margin: EdgeInsets.only(bottom: r.space(AppSpacing.md)),
      padding: EdgeInsets.all(r.space(20)),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(r.r(AppRadius.xl)),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image placeholder
          SkeletonLoader(
            width: r.dim(80),
            height: r.dim(80),
            borderRadius: AppRadius.lg,
          ),
          SizedBox(width: r.space(16)),

          // Content column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title row: dot + name
                Row(
                  children: [
                    SkeletonLoader(
                      width: r.dim(8),
                      height: r.dim(8),
                      borderRadius: 99,
                    ),
                    SizedBox(width: r.space(8)),
                    SkeletonLoader(width: r.dim(120), height: r.dim(16)),
                  ],
                ),
                SizedBox(height: r.space(6)),

                // Mileage · Plate
                SkeletonLoader(width: r.dim(90), height: r.dim(12)),

                SizedBox(height: r.space(14)),

                // Footer: health badge + arrow
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SkeletonLoader(
                      width: r.dim(50),
                      height: r.dim(22),
                      borderRadius: AppRadius.s,
                    ),
                    SkeletonLoader(
                      width: r.dim(70),
                      height: r.dim(12),
                      borderRadius: AppRadius.xs,
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
}
