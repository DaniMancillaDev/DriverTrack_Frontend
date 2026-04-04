import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/responsive/responsive.dart';
import '../../theme/app_color_scheme.dart';

class ProfileVehicleItem extends StatelessWidget {
  final String name;
  final String details;
  final Color color;
  final bool isFavorite;
  final VoidCallback? onTap;

  const ProfileVehicleItem({
    super.key,
    required this.name,
    required this.details,
    required this.color,
    this.isFavorite = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: r.space(AppSpacing.md),
          vertical: r.space(AppSpacing.s),
        ),
        decoration: BoxDecoration(color: context.colors.background),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: r.dim(32),
                    height: r.dim(32),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
                    ),
                    child: Icon(
                      Icons.directions_car,
                      color: color,
                      size: AppIconSizes.sm(context),
                    ),
                  ),
                  SizedBox(width: r.space(AppSpacing.s)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: AppTextStyles.bodySmall(context).copyWith(
                            color: context.colors.textMain,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          details,
                          style: AppTextStyles.label(
                            context,
                          ).copyWith(color: context.colors.textMuted),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                if (isFavorite)
                  Icon(
                    Icons.favorite_rounded,
                    size: AppIconSizes.sm(context),
                    color: AppColors.red,
                  ),
                SizedBox(width: r.space(AppSpacing.xs)),
                Icon(
                  Icons.chevron_right,
                  size: AppIconSizes.sm(context),
                  color: context.colors.surfaceLight2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileAddAction extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const ProfileAddAction({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: r.space(AppSpacing.s)),
        color: context.colors.background,
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.bodySmall(context).copyWith(
              color: AppColors.orangePrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
