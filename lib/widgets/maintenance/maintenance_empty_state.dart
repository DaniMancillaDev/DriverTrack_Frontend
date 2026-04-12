import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/i18n/translations.g.dart';
import '../../core/responsive/responsive.dart';
import '../../theme/app_color_scheme.dart';

class MaintenanceEmptyState extends StatelessWidget {
  final bool isFiltering;

  const MaintenanceEmptyState({super.key, this.isFiltering = false});

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: r.space(AppSpacing.xxxl),
        horizontal: r.space(AppSpacing.xl),
      ),
      decoration: BoxDecoration(
        color: context.colors.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(r.r(AppRadius.xxl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(r.space(AppSpacing.xxl)),
            decoration: BoxDecoration(
              color: AppColors.orangePrimary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(r.r(AppRadius.xl)),
            ),
            child: Icon(
              isFiltering ? Icons.search_off_rounded : Icons.history_rounded,
              size: AppIconSizes.massive(context),
              color: AppColors.orangePrimary.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: r.space(AppSpacing.xxl)),
          Text(
            isFiltering
                ? Translations.of(context).maintenance.noRecordsTitle
                : Translations.of(context).maintenance.noServiceRecords,
            textAlign: TextAlign.center,
            style: AppTextStyles.headlineMedium(
              context,
            ).copyWith(color: context.colors.textMain, letterSpacing: -0.5),
          ),
          SizedBox(height: r.space(AppSpacing.s)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: r.space(AppSpacing.lg)),
            child: Text(
              isFiltering
                  ? Translations.of(context).maintenance.noRecordsFiltering
                  : Translations.of(context).maintenance.noRecordsEmpty,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(
                context,
              ).copyWith(color: context.colors.textMuted, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
