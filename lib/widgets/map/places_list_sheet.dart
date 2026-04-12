import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../features/map/domain/entities/map_location.dart';
import '../ui/custom_list_card.dart';
import '../../core/i18n/translations.g.dart';
import '../../core/responsive/responsive.dart';
import '../../theme/app_color_scheme.dart';

class PlacesListSheet extends StatefulWidget {
  final List<MapLocation> locations;

  final Function(MapLocation) onLocationSelected;
  final VoidCallback onClose;

  const PlacesListSheet({
    super.key,
    required this.locations,
    required this.onLocationSelected,
    required this.onClose,
  });

  @override
  State<PlacesListSheet> createState() => _PlacesListSheetState();
}

class _PlacesListSheetState extends State<PlacesListSheet> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final locations = widget.locations;
    final onLocationSelected = widget.onLocationSelected;
    final r = context.responsive;
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: r.value(mobile: 600, tablet: 700),
          maxHeight: _isExpanded
              ? MediaQuery.of(context).size.height * 0.90
              : MediaQuery.of(context).size.height * 0.40,
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
              _buildHandleStrip(context, locations),
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
                      final Color accent = isWorkshop
                          ? AppColors.orangePrimary
                          : AppColors.cyan;

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: r.space(AppSpacing.md),
                        ),
                        child: CustomListCard(
                          onTap: () => onLocationSelected(loc),
                          leading: Container(
                            width: r.dim(44),
                            height: r.dim(44),
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                r.r(AppRadius.xs),
                              ),
                            ),
                            child: Icon(
                              isWorkshop
                                  ? Icons.build_rounded
                                  : Icons.local_gas_station_rounded,
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
                                style: AppTextStyles.bodySmall(context)
                                    .copyWith(
                                      color: AppColors.cyan,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              SizedBox(height: r.space(4)),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    size: AppIconSizes.xs(context),
                                    color: AppColors.orangeSecondary,
                                  ),
                                  SizedBox(width: r.space(2)),
                                  Text(
                                    loc.rating.toString(),
                                    style: AppTextStyles.caption(context)
                                        .copyWith(
                                          color: context.colors.textMain,
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

  Widget _buildHandleStrip(BuildContext context, List<MapLocation> locations) {
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
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              height: r.dim(16),
              color: Colors.transparent,
              child: Center(
                child: Container(
                  width: r.dim(36),
                  height: r.dim(4),
                  decoration: BoxDecoration(
                    color: context.colors.borderLight,
                    borderRadius: BorderRadius.circular(r.r(AppRadius.xs)),
                  ),
                ),
              ),
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
                      style: AppTextStyles.caption(
                        context,
                      ).copyWith(color: context.colors.textMuted),
                    ),
                    SizedBox(height: r.space(4)),
                    Text(
                      Translations.of(context).map.locationsFound(
                        count: locations.length.toString(),
                      ),
                      style: AppTextStyles.button(
                        context,
                      ).copyWith(color: context.colors.textMain),
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
                    locations
                        .where((l) => l.type == 'workshop')
                        .length
                        .toString(),
                  ),
                  SizedBox(width: r.space(AppSpacing.xs)),
                  _buildCountBadge(
                    context,
                    Icons.local_gas_station_rounded,
                    AppColors.cyan,
                    locations
                        .where((l) => l.type == 'gasstation')
                        .length
                        .toString(),
                  ),
                  SizedBox(width: r.space(AppSpacing.s)),
                  IconButton(
                    onPressed: widget.onClose,
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
                      backgroundColor: context.colors.surfaceLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget _buildCountBadge(
    BuildContext context,
    IconData icon,
    Color color,
    String count,
  ) {
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
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
