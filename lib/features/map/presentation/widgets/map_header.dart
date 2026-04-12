// Removed dart:ui
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../theme/app_theme.dart';
import '../../../../../core/i18n/translations.g.dart';
import '../../../../../core/responsive/responsive.dart';

import '../providers/map_providers.dart';
import '../../../../theme/app_color_scheme.dart';

class MapHeaderWidget extends ConsumerStatefulWidget {
  final VoidCallback onFilterChanged;

  const MapHeaderWidget({super.key, required this.onFilterChanged});

  @override
  ConsumerState<MapHeaderWidget> createState() => _MapHeaderWidgetState();
}

class _MapHeaderWidgetState extends ConsumerState<MapHeaderWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchController.text = ref.read(mapSearchProvider);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    final activeFilter = ref.watch(mapFilterProvider);
    final searchQuery = ref.watch(mapSearchProvider);

    final isLoading = ref.watch(nearbyLocationsProvider).isLoading;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Content with SafeArea padding
          Padding(
            padding: EdgeInsets.fromLTRB(
              r.space(AppSpacing.lg),
              MediaQuery.of(context).padding.top + r.space(AppSpacing.xs),
              r.space(AppSpacing.lg),
              r.space(AppSpacing.md),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Translations.of(context).map.subtitle,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: context.colors.textDim,
                                ),
                          ),
                          Text(
                            Translations.of(context).map.title,
                            style: AppTextStyles.headline(context).copyWith(
                              color: context.colors.textMain,
                              fontWeight: FontWeight.w900,
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
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) =>
                        ref.read(mapSearchProvider.notifier).setSearch(val),
                    style: AppTextStyles.bodyMedium(
                      context,
                    ).copyWith(color: context.colors.textMain),
                    decoration: InputDecoration(
                      hintText: Translations.of(context).map.searchHint,
                      hintStyle: AppTextStyles.bodyMedium(
                        context,
                      ).copyWith(color: context.colors.textMuted),
                      prefixIcon: Icon(
                        Icons.search,
                        color: context.colors.textMuted,
                        size: AppIconSizes.md(context),
                      ),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.close,
                                color: context.colors.textMuted,
                                size: AppIconSizes.sm(context),
                              ),
                              onPressed: () {
                                _searchController.clear();
                                ref
                                    .read(mapSearchProvider.notifier)
                                    .setSearch('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: r.space(AppSpacing.s),
                      ),
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
                        _buildFilterPill(
                          context,
                          ref,
                          'all',
                          Translations.of(context).map.filterAll,
                          Icons.grid_view_rounded,
                          activeFilter,
                          r,
                        ),
                        SizedBox(width: r.space(AppSpacing.xxs)),
                        _buildFilterPill(
                          context,
                          ref,
                          'workshop',
                          Translations.of(context).map.filterWorkshops,
                          Icons.build_rounded,
                          activeFilter,
                          r,
                        ),
                        SizedBox(width: r.space(AppSpacing.xxs)),
                        _buildFilterPill(
                          context,
                          ref,
                          'gasstation',
                          Translations.of(context).map.filterGasStations,
                          Icons.local_gas_station_rounded,
                          activeFilter,
                          r,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Progress bar — at the bottom of the header, in natural flow
          if (isLoading)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: r.space(AppSpacing.lg),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(r.r(AppRadius.xs)),
                child: const LinearProgressIndicator(
                  color: AppColors.cyan,
                  backgroundColor: Colors.transparent,
                  minHeight: 3,
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
    AppResponsive r,
  ) {
    final bool isSelected = activeFilter == key;
    Color accent = AppColors.orangePrimary;
    if (key == 'gasstation') accent = AppColors.cyan;

    return GestureDetector(
      onTap: () {
        ref.read(mapFilterProvider.notifier).setFilter(key);
        widget.onFilterChanged();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: r.space(AppSpacing.md),
          vertical: r.space(AppSpacing.xs),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? accent.withValues(alpha: 0.15)
              : context.colors.surface,
          borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
          border: isSelected
              ? Border.all(color: accent.withValues(alpha: 0.4))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppIconSizes.xs(context),
              color: isSelected ? accent : context.colors.textMuted,
            ),
            SizedBox(width: r.space(AppSpacing.xxs)),
            Text(
              label,
              style: AppTextStyles.bodySmall(context).copyWith(
                color: isSelected ? accent : context.colors.textMuted,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
