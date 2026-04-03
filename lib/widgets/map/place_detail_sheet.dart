import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../features/map/domain/entities/map_location.dart';
import '../ui/star_rating.dart';
import '../ui/custom_button.dart';
import '../../core/i18n/translations.g.dart';
import '../../core/responsive/responsive.dart';

class PlaceDetailSheet extends StatelessWidget {
  final MapLocation location;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onClose;

  const PlaceDetailSheet({
    super.key,
    required this.location,
    required this.isExpanded,
    required this.onToggle,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final bool isWorkshop = location.type == 'workshop';
    final Color accent = isWorkshop ? AppColors.orangePrimary : AppColors.cyan;
    final r = context.responsive;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: r.value(mobile: 600, tablet: 700),
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(r.r(AppRadius.xl)),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 40,
                spreadRadius: 0,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy < -10 && !isExpanded) {
                    onToggle();
                  } else if (details.delta.dy > 10 && isExpanded) {
                    onToggle();
                  }
                },
                onTap: onToggle,
                child: Container(
                  width: double.infinity,
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: r.space(AppSpacing.s)),
                  child: Center(
                    child: Container(
                      width: r.dim(36),
                      height: r.dim(4),
                      decoration: BoxDecoration(
                        color: AppColors.borderLight,
                        borderRadius: BorderRadius.circular(r.r(AppRadius.xs)),
                      ),
                    ),
                  ),
                ),
              ),
              
              Flexible(
                child: SingleChildScrollView(
                  physics: isExpanded ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      r.space(AppSpacing.lg),
                      0,
                      r.space(AppSpacing.lg),
                      r.space(AppSpacing.lg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, accent, isWorkshop),
                        SizedBox(height: r.space(AppSpacing.md)),
                        _buildQuickStats(context),
                        SizedBox(height: r.space(AppSpacing.md)),
                        _buildInfoGrid(context),
                        if (location.specialties != null) ...[
                          SizedBox(height: r.space(AppSpacing.md)),
                          _buildSpecialties(context),
                        ],
                        SizedBox(height: r.space(AppSpacing.lg)),
                        _buildActionButtons(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color accent, bool isWorkshop) {
    final r = context.responsive;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: r.dim(48),
          height: r.dim(48),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
          ),
          child: Icon(
            isWorkshop ? Icons.build_rounded : Icons.local_gas_station_rounded,
            color: accent,
            size: AppIconSizes.lg(context),
          ),
        ),
        SizedBox(width: r.space(AppSpacing.s)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location.name,
                style: AppTextStyles.sheetTitle(context).copyWith(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: r.space(4)),
              Row(
                children: [
                  Icon(Icons.location_on_rounded, size: AppIconSizes.xs(context), color: AppColors.textMuted),
                  SizedBox(width: r.space(4)),
                  Expanded(
                    child: Text(
                      location.address,
                      style: AppTextStyles.bodySmall(context).copyWith(
                        color: AppColors.textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onClose,
          icon: Icon(Icons.close_rounded, color: AppColors.textMuted, size: AppIconSizes.md(context)),
          constraints: BoxConstraints(minWidth: r.dim(32), minHeight: r.dim(32)),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.border,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
            ),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    final r = context.responsive;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          StarRating(rating: location.rating),
          SizedBox(width: r.space(6)),
          Text(
            location.rating.toString(),
            style: AppTextStyles.bodySmall(context).copyWith(
              color: AppColors.orangeSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: r.space(4)),
          Text(
            '(${location.reviews})',
            style: AppTextStyles.caption(context).copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(width: r.space(AppSpacing.s)),
          Container(width: 1, height: r.dim(14), color: Colors.white.withValues(alpha: 0.08)),
          SizedBox(width: r.space(AppSpacing.s)),
          Text(
            location.distance,
            style: AppTextStyles.bodySmall(context).copyWith(
              color: AppColors.cyan,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: r.space(AppSpacing.s)),
          Container(width: 1, height: r.dim(14), color: Colors.white.withValues(alpha: 0.08)),
          SizedBox(width: r.space(AppSpacing.s)),
          Container(
            width: r.dim(6),
            height: r.dim(6),
            decoration: BoxDecoration(
              color: location.open ? AppColors.green : AppColors.red,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: r.space(6)),
          Text(
            location.open ? Translations.of(context).map.openNow : Translations.of(context).map.closed,
            style: AppTextStyles.caption(context).copyWith(
              color: location.open ? AppColors.green : AppColors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: r.space(AppSpacing.s)),
          Text(
            location.priceLevel,
            style: AppTextStyles.bodySmall(context).copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid(BuildContext context) {
    final r = context.responsive;
    return Row(
      children: [
        Expanded(
          child: _buildInfoTag(context, Icons.access_time_filled_rounded, location.hours),
        ),
        SizedBox(width: r.space(AppSpacing.xs)),
        Expanded(
          child: _buildInfoTag(context, Icons.phone_rounded, location.phone),
        ),
      ],
    );
  }

  Widget _buildInfoTag(BuildContext context, IconData icon, String text) {
    final r = context.responsive;
    return Container(
      padding: EdgeInsets.all(r.space(AppSpacing.s)),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
      ),
      child: Row(
        children: [
          Icon(icon, size: AppIconSizes.sm(context), color: AppColors.textMuted),
          SizedBox(width: r.space(AppSpacing.xs)),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption(context).copyWith(
                color: AppColors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialties(BuildContext context) {
    final r = context.responsive;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Translations.of(context).map.specialties,
          style: AppTextStyles.label(context).copyWith(
            color: AppColors.textMuted,
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: r.space(10)),
        Wrap(
          spacing: r.space(AppSpacing.xs),
          runSpacing: r.space(AppSpacing.xs),
          children: location.specialties!.map((s) => Container(
            padding: EdgeInsets.symmetric(
              horizontal: r.space(AppSpacing.s),
              vertical: r.space(AppSpacing.xxs),
            ),
            decoration: BoxDecoration(
              color: AppColors.orangePrimary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
            ),
            child: Text(
              s,
              style: AppTextStyles.caption(context).copyWith(
                color: AppColors.orangeSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final r = context.responsive;
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(Translations.of(context).map.navigatingTo.replaceAll('{name}', location.name)),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.surface,
                ),
              );
            },
            variant: ButtonVariant.gradient,
            size: ButtonSize.lg,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.directions_rounded, color: Colors.white, size: AppIconSizes.lg(context)),
                SizedBox(width: r.space(10)),
                Flexible(
                  child: Text(
                    Translations.of(context).map.navigate,
                    style: AppTextStyles.body(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: r.space(AppSpacing.s)),
        _buildCircularAction(context, Icons.call_rounded, () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(Translations.of(context).map.calling.replaceAll('{phone}', location.phone)),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCircularAction(BuildContext context, IconData icon, VoidCallback onTap) {
    final r = context.responsive;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: r.dim(52),
        width: r.dim(52),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(r.r(AppRadius.xl)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.cyan, size: AppIconSizes.lg(context)),
      ),
    );
  }
}
