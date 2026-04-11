import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/responsive/responsive.dart';
import '../../theme/app_color_scheme.dart';
import 'skeleton_loader.dart';

class NotificationCardSkeleton extends StatelessWidget {
  const NotificationCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Padding(
        padding: EdgeInsets.all(r.space(AppSpacing.lg)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Placeholder
            SkeletonLoader(
              width: r.dim(38),
              height: r.dim(38),
              borderRadius: r.r(12),
            ),
            SizedBox(width: r.space(AppSpacing.s)),
            
            // Content Placeholders
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  SkeletonLoader(
                    width: r.dim(160),
                    height: r.dim(14),
                  ),
                  SizedBox(height: r.space(10)),
                  
                  // Message Line 1
                  SkeletonLoader(
                    width: double.infinity,
                    height: r.dim(12),
                  ),
                  SizedBox(height: r.space(6)),
                  
                  // Message Line 2
                  SkeletonLoader(
                    width: r.dim(120),
                    height: r.dim(12),
                  ),
                  SizedBox(height: r.space(12)),
                  
                  // Timestamp row
                  Row(
                    children: [
                      SkeletonLoader(
                        width: r.dim(5),
                        height: r.dim(5),
                        borderRadius: 10,
                      ),
                      SizedBox(width: r.space(4)),
                      SkeletonLoader(
                        width: r.dim(40),
                        height: r.dim(10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
