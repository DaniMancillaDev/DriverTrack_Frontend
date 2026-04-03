import '../models/vehicle_model.dart';
import '../models/maintenance_model.dart';
import '../theme/app_theme.dart';
import '../core/i18n/translations.g.dart';

class ProfileStatsViewModel {
  final List<Vehicle> vehicles;
  final List<Maintenance> maintenance;

  ProfileStatsViewModel({required this.vehicles, required this.maintenance});

  String get vehicleCount => vehicles.length.toString();
  String get maintenanceCount => maintenance.length.toString();

  String get totalCostFormatted {
    final total = maintenance.fold<double>(0, (sum, item) => sum + item.cost);
    if (total >= 1000) return '\$${(total / 1000).toStringAsFixed(1)}K';
    return '\$${total.toStringAsFixed(0)}';
  }

  List<Map<String, dynamic>> getStatsItems(Translations t) => [
    {
      'label': t.profile.statsVehicles,
      'value': vehicleCount,
      'accent': AppColors.orangePrimary,
      'sub': t.profile.statsVehiclesSub,
    },
    {
      'label': t.profile.statsServices,
      'value': maintenanceCount,
      'accent': AppColors.cyan,
      'sub': t.profile.statsServicesSub,
    },
    {
      'label': t.profile.statsSaved,
      'value': totalCostFormatted,
      'accent': AppColors.green,
      'sub': t.profile.statsSavedSub,
    },
  ];
}
