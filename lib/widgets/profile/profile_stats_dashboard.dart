import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../profile/profile_stats_skeleton.dart';
import '../../providers/app_providers.dart';
import '../../viewmodels/profile_view_model.dart';
import '../../core/responsive/responsive.dart';
import '../../core/i18n/translations.g.dart';
import '../../theme/app_color_scheme.dart';

class ProfileStatsDashboard extends ConsumerWidget {
  const ProfileStatsDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesAsync = ref.watch(vehiclesProvider);
    final maintenanceAsync = ref.watch(
      maintenanceDocsProvider(const MaintenanceParams()),
    );

    return vehiclesAsync.when(
      data: (vehiclesList) => maintenanceAsync.when(
        data: (maintenanceList) {
          final viewModel = ProfileStatsViewModel(
            vehicles: vehiclesList,
            maintenance: maintenanceList,
          );

          return _buildDashboard(context, viewModel);
        },
        loading: () => const ProfileStatsSkeleton(),
        error: (_, __) => const ProfileStatsSkeleton(),
      ),
      loading: () => const ProfileStatsSkeleton(),
      error: (_, __) => const ProfileStatsSkeleton(),
    );
  }

  Widget _buildDashboard(BuildContext context, ProfileStatsViewModel vm) {
    final r = context.responsive;
    final items = vm.getStatsItems(Translations.of(context));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.space(AppSpacing.lg)),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surfaceLight,
          border: Border.all(color: context.colors.borderLight, width: 1.0),
          borderRadius: BorderRadius.circular(r.r(AppRadius.xl)),
        ),
        child: Row(
          children: () {
            final List<Widget> cells = [];
            for (int idx = 0; idx < items.length; idx++) {
              final Map<String, dynamic> s = items[idx];
              if (idx > 0) {
                cells.add(
                  Container(
                    width: 1,
                    height: 36,
                    margin: EdgeInsets.symmetric(
                      vertical: r.space(AppSpacing.md),
                    ),
                    color: Colors.white.withValues(alpha: 0.07),
                  ),
                );
              }
              cells.add(
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: r.space(AppSpacing.md),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            s['value'] as String,
                            style: AppTextStyles.headlineMedium(context)
                                .copyWith(
                                  color: s['accent'] as Color,
                                  fontSize: r.sp(21),
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                        Text(
                          s['label'] as String,
                          style: AppTextStyles.label(
                            context,
                          ).copyWith(color: context.colors.textMuted),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          s['sub'] as String,
                          style: AppTextStyles.micro(
                            context,
                          ).copyWith(color: context.colors.textSecondary),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return cells;
          }(),
        ),
      ),
    );
  }
}
