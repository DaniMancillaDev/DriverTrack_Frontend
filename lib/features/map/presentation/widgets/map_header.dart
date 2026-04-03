import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../theme/app_theme.dart';
import '../../../../../core/i18n/translations.g.dart';
import '../../../../../core/responsive/responsive.dart';

import '../providers/map_providers.dart';

class MapHeaderWidget extends ConsumerWidget {
  final VoidCallback onFilterChanged;

  const MapHeaderWidget({
    super.key,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = context.responsive;
    final activeFilter = ref.watch(mapFilterProvider);
    final searchQuery = ref.watch(mapSearchProvider);
    final isSearching = ref.watch(nearbyLocationsProvider).isLoading;

    return Container(
      padding: EdgeInsets.fromLTRB(
        r.space(AppSpacing.lg),
        MediaQuery.of(context).padding.top + r.space(AppSpacing.s),
        r.space(AppSpacing.lg),
        r.space(AppSpacing.s),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.6, 1.0],
          colors: [
            AppColors.background.withValues(alpha: 0.97),
            AppColors.background.withValues(alpha: 0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  Translations.of(context).map.title,
                  style: AppTextStyles.headline(context).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: r.space(AppSpacing.s),
                  vertical: r.space(6),
                ),
                decoration: BoxDecoration(
                  color: AppColors.cyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.near_me, size: AppIconSizes.xs(context), color: AppColors.cyan),
                    SizedBox(width: r.space(6)),
                    Text(
                      Translations.of(context).map.live,
                      style: AppTextStyles.caption(context).copyWith(
                        color: AppColors.cyan,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: r.space(AppSpacing.md)),
          
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
            ),
            child: TextField(
              onChanged: (val) => ref.read(mapSearchProvider.notifier).setSearch(val),
              style: AppTextStyles.bodyMedium(context).copyWith(color: Colors.white),
              decoration: InputDecoration(
                hintText: Translations.of(context).map.searchHint,
                hintStyle: AppTextStyles.bodyMedium(context).copyWith(color: AppColors.textMuted),
                prefixIcon: Icon(Icons.search, color: AppColors.textMuted, size: AppIconSizes.md(context)),
                suffixIcon: isSearching
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.cyan,
                        ),
                      ),
                    )
                  : (searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.close, color: AppColors.textMuted, size: AppIconSizes.sm(context)),
                          onPressed: () {
                            ref.read(mapSearchProvider.notifier).setSearch('');
                          },
                        )
                      : null),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: r.space(AppSpacing.s)),
              ),
            ),
          ),
          SizedBox(height: r.space(AppSpacing.s)),
          
          // Filter Pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildFilterPill(context, ref, 'all', Translations.of(context).map.filterAll, Icons.grid_view_rounded, activeFilter, r),
                  SizedBox(width: r.space(8)),
                  _buildFilterPill(context, ref, 'workshop', Translations.of(context).map.filterWorkshops, Icons.build_rounded, activeFilter, r),
                  SizedBox(width: r.space(8)),
                  _buildFilterPill(context, ref, 'gasstation', Translations.of(context).map.filterGasStations, Icons.local_gas_station_rounded, activeFilter, r),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(
    BuildContext context, 
    WidgetRef ref, 
    String key, 
    String label, 
    IconData icon, 
    String activeFilter, 
    AppResponsive r
  ) {
    final bool isSelected = activeFilter == key;
    Color accent = AppColors.orangePrimary;
    if (key == 'gasstation') accent = AppColors.cyan;

    return GestureDetector(
      onTap: () {
        ref.read(mapFilterProvider.notifier).setFilter(key);
        onFilterChanged();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: r.space(AppSpacing.md),
          vertical: r.space(AppSpacing.xs),
        ),
        decoration: BoxDecoration(
          color: isSelected ? accent.withValues(alpha: 0.15) : AppColors.surface,
          borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
          border: isSelected ? Border.all(color: accent.withValues(alpha: 0.4)) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppIconSizes.xs(context), color: isSelected ? accent : AppColors.textMuted),
            SizedBox(width: r.space(6)),
            Text(
              label,
              style: AppTextStyles.bodySmall(context).copyWith(
                color: isSelected ? accent : AppColors.textMuted,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
