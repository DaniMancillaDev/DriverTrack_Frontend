import '../models/vehicle_model.dart';
import '../models/maintenance_model.dart';
import '../theme/app_theme.dart';
import '../core/i18n/translations.g.dart';

/// Modelo de vista para las estadísticas globales en el perfil del usuario.
///
/// Consolida datos de múltiples vehículos y mantenimientos para presentar
/// contadores y sumas financieras de forma visual y atractiva.
class ProfileStatsViewModel {
  /// Lista de todos los vehículos del usuario.
  final List<Vehicle> vehicles;

  /// Historial completo de mantenimientos registrados.
  final List<Maintenance> maintenance;

  ProfileStatsViewModel({required this.vehicles, required this.maintenance});

  /// Cantidad total de vehículos en formato String.
  String get vehicleCount => vehicles.length.toString();

  /// Cantidad total de servicios realizados.
  String get maintenanceCount => maintenance.length.toString();

  /// Calcula el gasto acumulado total y lo formatea (ej. $2.5K o $850).
  String get totalCostFormatted {
    final total = maintenance.fold<double>(0, (sum, item) => sum + item.cost);
    if (total >= 1000) return '\$${(total / 1000).toStringAsFixed(1)}K';
    return '\$${total.toStringAsFixed(0)}';
  }

  /// Retorna una lista estructurada para renderizar tarjetas de estadísticas.
  ///
  /// Incluye etiquetas localizadas, valores calculados y colores de énfasis.
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
