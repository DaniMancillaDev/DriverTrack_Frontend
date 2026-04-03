import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../features/map/domain/entities/map_location.dart';
import '../ui/custom_list_card.dart';
import '../../core/i18n/translations.g.dart';
import '../../core/responsive/responsive.dart';

class PlacesListSheet extends StatelessWidget {
  final List<MapLocation> locations;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Function(MapLocation) onLocationSelected;

  const PlacesListSheet({
    super.key,
    required this.locations,
    required this.isExpanded,
    required this.onToggle,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: r.value(mobile: 600, tablet: 700),
          maxHeight: MediaQuery.of(context).size.height * 0.45,
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
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 32,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle / Initial Strip
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy < -10 && !isExpanded) {
                    onToggle();
                  } else if (details.delta.dy > 10 && isExpanded) {
                    onToggle();
                  }
                },
                onTap: onToggle,
                child: _buildHandleStrip(context),
              ),
              
              if (isExpanded)
                Flexible(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                      r.space(AppSpacing.lg),
                      0,
                      r.space(AppSpacing.lg),
                      r.space(AppSpacing.xl),
                    ),
                    itemCount: locations.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final loc = locations[index];
                      final bool isWorkshop = loc.type == 'workshop';
                      final Color accent = isWorkshop ? AppColors.orangePrimary : AppColors.cyan;
                      
                      return Padding(
                        padding: EdgeInsets.only(bottom: r.space(AppSpacing.md)),
                        child: CustomListCard(
                          onTap: () => onLocationSelected(loc),
                          leading: Container(
                            width: r.dim(44),
                            height: r.dim(44),
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(r.r(AppRadius.xs)),
                            ),
                            child: Icon(
                              isWorkshop ? Icons.build_rounded : Icons.local_gas_station_rounded,
                              color: accent,
                              size: AppIconSizes.lg(context),
                            ),
                          ),
                          title: loc.name,
                          subtitle: loc.address,
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                loc.distance,
                                style: AppTextStyles.bodySmall(context).copyWith(
                                  color: AppColors.cyan,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: r.space(4)),
                              Row(
                                children: [
                                  Icon(Icons.star_rounded, size: AppIconSizes.xs(context), color: AppColors.orangeSecondary),
                                  SizedBox(width: r.space(2)),
                                  Text(
                                    loc.rating.toString(),
                                    style: AppTextStyles.caption(context).copyWith(
                                      color: AppColors.textMain,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandleStrip(BuildContext context) {
    final r = context.responsive;
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(
        r.space(AppSpacing.lg),
        r.space(AppSpacing.s),
        r.space(AppSpacing.lg),
        r.space(AppSpacing.lg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: r.dim(36),
            height: r.dim(4),
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(r.r(AppRadius.xs)),
            ),
          ),
          SizedBox(height: r.space(AppSpacing.md)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Translations.of(context).map.nearbyResults,
                      style: AppTextStyles.caption(context).copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    SizedBox(height: r.space(4)),
                    Text(
                      Translations.of(context).map.locationsFound.replaceAll('{count}', locations.length.toString()),
                      style: AppTextStyles.button(context).copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildCountBadge(
                    context,
                    Icons.build_rounded,
                    AppColors.orangePrimary,
                    locations.where((l) => l.type == 'workshop').length.toString(),
                  ),
                  SizedBox(width: r.space(AppSpacing.xs)),
                  _buildCountBadge(
                    context,
                    Icons.local_gas_station_rounded,
                    AppColors.cyan,
                    locations.where((l) => l.type == 'gasstation').length.toString(),
                  ),
                ],
              ),
            ],
          ),
          if (!isExpanded) ...[
            SizedBox(height: r.space(AppSpacing.s)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                Translations.of(context).map.swipeUp,
                style: AppTextStyles.caption(context).copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCountBadge(BuildContext context, IconData icon, Color color, String count) {
    final r = context.responsive;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.space(AppSpacing.s),
        vertical: r.space(AppSpacing.xxs),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
      ),
      child: Row(
        children: [
          Icon(icon, size: AppIconSizes.xs(context), color: color),
          SizedBox(width: r.space(6)),
          Text(
            count,
            style: AppTextStyles.caption(context).copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
