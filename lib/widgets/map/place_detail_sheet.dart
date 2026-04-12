import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../features/map/domain/entities/map_location.dart';
import '../ui/star_rating.dart';
import '../ui/custom_button.dart';
import '../../core/i18n/translations.g.dart';
import '../../core/responsive/responsive.dart';
import '../../theme/app_color_scheme.dart';

class PlaceDetailSheet extends StatelessWidget {
  final MapLocation location;
  final VoidCallback onClose;

  const PlaceDetailSheet({
    super.key,
    required this.location,
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
          maxHeight: MediaQuery.of(context).size.height * 0.90,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: context.colors.surface,
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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(r.space(AppSpacing.lg)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, accent, isWorkshop),
                        SizedBox(height: r.space(AppSpacing.md)),
                        _buildQuickStats(context, accent),
                        SizedBox(height: r.space(AppSpacing.md)),
                        _buildInfoGrid(context),
                        if (location.specialties != null) ...[
                          SizedBox(height: r.space(AppSpacing.md)),
                          _buildSpecialties(context, accent),
                        ],
                        SizedBox(height: r.space(AppSpacing.lg)),
                        _buildActionButtons(context, accent, isWorkshop),
                      ],
                    ),
                  ),
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
                style: AppTextStyles.sheetTitle(
                  context,
                ).copyWith(color: context.colors.textMain),
              ),
              SizedBox(height: r.space(4)),
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: AppIconSizes.xs(context),
                    color: context.colors.textMuted,
                  ),
                  SizedBox(width: r.space(4)),
                  Expanded(
                    child: Text(
                      location.address,
                      style: AppTextStyles.bodySmall(
                        context,
                      ).copyWith(color: context.colors.textMuted),
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
          icon: Icon(
            Icons.close_rounded,
            color: context.colors.textMuted,
            size: AppIconSizes.md(context),
          ),
          constraints: BoxConstraints(
            minWidth: r.dim(32),
            minHeight: r.dim(32),
          ),
          style: IconButton.styleFrom(
            backgroundColor: context.colors.border,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
            ),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context, Color accent) {
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
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: context.colors.textSecondary),
          ),
          if (location.distance.isNotEmpty) ...[
            SizedBox(width: r.space(AppSpacing.s)),
            Container(
              width: 1,
              height: r.dim(14),
              color: context.colors.borderLight,
            ),
            SizedBox(width: r.space(AppSpacing.s)),
            Text(
              location.distance,
              style: AppTextStyles.bodySmall(
                context,
              ).copyWith(color: accent, fontWeight: FontWeight.w600),
            ),
          ],
          SizedBox(width: r.space(AppSpacing.s)),
          Container(
            width: 1,
            height: r.dim(14),
            color: context.colors.borderLight,
          ),
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
            location.open
                ? Translations.of(context).map.openNow
                : Translations.of(context).map.closed,
            style: AppTextStyles.caption(context).copyWith(
              color: location.open ? AppColors.green : AppColors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid(BuildContext context) {
    final r = context.responsive;
    final bool hasPhone = location.phone.trim().isNotEmpty && location.phone != 'Unknown';
    final bool hasHours = location.hours.trim().isNotEmpty && location.hours != 'Horario no especificado';
    
    // Si no tiene horas ni teléfono, no mostramos la cuadrícula
    if (!hasHours && !hasPhone) return const SizedBox.shrink();

    return Row(
      children: [
        if (hasHours)
          Expanded(
            child: _buildInfoTag(
              context,
              Icons.access_time_filled_rounded,
              location.hours,
            ),
          ),
        if (hasHours && hasPhone) SizedBox(width: r.space(AppSpacing.xs)),
        if (hasPhone)
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
        color: context.colors.surfaceLight,
        borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppIconSizes.sm(context),
            color: context.colors.textMuted,
          ),
          SizedBox(width: r.space(AppSpacing.xs)),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: context.colors.textSecondary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialties(BuildContext context, Color accent) {
    final r = context.responsive;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Translations.of(context).map.specialties,
          style: AppTextStyles.label(
            context,
          ).copyWith(color: context.colors.textMuted, letterSpacing: 0.8),
        ),
        SizedBox(height: r.space(10)),
        Wrap(
          spacing: r.space(AppSpacing.xs),
          runSpacing: r.space(AppSpacing.xs),
          children: location.specialties!
              .map(
                (s) => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.space(AppSpacing.s),
                    vertical: r.space(AppSpacing.xxs),
                  ),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
                  ),
                  child: Text(
                    s,
                    style: AppTextStyles.caption(context).copyWith(
                      color: accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, Color accent, bool isWorkshop) {
    final r = context.responsive;
    final bool hasPhone = location.phone.trim().isNotEmpty && location.phone != 'Unknown';
    
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            onPressed: () async {
              final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${location.latitude},${location.longitude}');
              try {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        Translations.of(context).map.navigatingTo(name: location.name),
                        style: TextStyle(color: context.colors.surface),
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: context.colors.textMain,
                    ),
                  );
                }
              }
            },
            variant: ButtonVariant.gradient,
            gradientColors: isWorkshop ? null : [accent, accent],
            size: ButtonSize.lg,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.directions_rounded,
                  color: context.colors.textMain,
                  size: AppIconSizes.lg(context),
                ),
                SizedBox(width: r.space(10)),
                Flexible(
                  child: Text(
                    Translations.of(context).map.navigate,
                    style: AppTextStyles.body(context).copyWith(
                      color: context.colors.textMain,
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (hasPhone) ...[
          SizedBox(width: r.space(AppSpacing.s)),
          _buildCircularAction(context, Icons.call_rounded, accent, () async {
            final url = Uri.parse('tel:${location.phone}');
            try {
              await launchUrl(url);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      Translations.of(context).map.calling(phone: location.phone),
                      style: TextStyle(color: context.colors.surface),
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: context.colors.textMain,
                  ),
                );
              }
            }
          }),
        ],
      ],
    );
  }

  Widget _buildCircularAction(
    BuildContext context,
    IconData icon,
    Color accent,
    VoidCallback onTap,
  ) {
    final r = context.responsive;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: r.dim(52),
        width: r.dim(52),
        decoration: BoxDecoration(
          color: context.colors.surfaceLight,
          borderRadius: BorderRadius.circular(r.r(AppRadius.xl)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: accent,
          size: AppIconSizes.lg(context),
        ),
      ),
    );
  }
}
