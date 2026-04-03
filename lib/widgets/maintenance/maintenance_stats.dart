import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../ui/summary_stats.dart';
import '../../viewmodels/maintenance_view_model.dart';
import '../../core/i18n/translations.g.dart';
import '../../features/currency/presentation/widgets/currency_display.dart';
import '../../core/responsive/responsive.dart';

class MaintenanceStats extends StatelessWidget {
  final List<MaintenanceViewModel> maintenances;

  const MaintenanceStats({super.key, required this.maintenances});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final double totalSpent = maintenances.fold(
      0,
      (sum, item) => sum + item.cost,
    );
    final int recordsCount = maintenances.length;
    final int vehiclesCount = maintenances
        .map((e) => e.vehicleId)
        .toSet()
        .length;

    final stats = [
      StatItem(
        label: t.maintenance.totalSpent,
        customValue: CurrencyDisplay(
          amount: totalSpent,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.green,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        accent: AppColors.green,
      ),
      StatItem(
        label: t.maintenance.servicesLabel,
        value: '$recordsCount',
        accent: AppColors.orangePrimary,
      ),
      StatItem(
        label: t.maintenance.vehiclesLabel,
        value: '$vehiclesCount',
        accent: AppColors.cyan,
      ),
    ];

    return SummaryStats(stats: stats);
  }
}
