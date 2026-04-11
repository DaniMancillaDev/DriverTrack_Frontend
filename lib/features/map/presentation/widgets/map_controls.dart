import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../theme/app_color_scheme.dart';

class MapControls extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onMyLocation;

  const MapControls({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onMyLocation,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // My Location Button
        FloatingActionButton.small(
          heroTag: 'map_my_location',
          onPressed: onMyLocation,
          backgroundColor: context.colors.surface,
          foregroundColor: AppColors.cyan,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
          ),
          child: Icon(Icons.my_location, size: AppIconSizes.sm(context)),
        ),
        SizedBox(height: r.space(AppSpacing.md)),

        // Zoom Controls
        Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onZoomIn,
                icon: Icon(
                  Icons.add,
                  color: context.colors.textMain,
                  size: AppIconSizes.md(context),
                ),
                padding: EdgeInsets.all(r.space(AppSpacing.s)),
                constraints: const BoxConstraints(),
              ),
              Container(
                height: 1,
                width: r.dim(24),
                color: context.colors.borderLight,
              ),
              IconButton(
                onPressed: onZoomOut,
                icon: Icon(
                  Icons.remove,
                  color: context.colors.textMain,
                  size: AppIconSizes.md(context),
                ),
                padding: EdgeInsets.all(r.space(AppSpacing.s)),
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
