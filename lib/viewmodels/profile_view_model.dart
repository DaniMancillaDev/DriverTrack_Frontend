import '../models/vehicle_model.dart';
import '../models/maintenance_model.dart';
import '../theme/app_theme.dart';
import '../core/i18n/translations.g.dart';

/// Orquestador de métricas agregadas para el perfil del usuario.
///
/// Su responsabilidad es consolidar datos de múltiples vehículos y 
/// mantenimientos para presentar indicadores clave de rendimiento (KPIs) 
/// y resúmenes financieros de forma visual y atractiva.
class ProfileStatsViewModel {
  /// Colección completa de vehículos vinculados a la cuenta.
  final List<Vehicle> vehicles;

  /// Historial íntegro de servicios realizados por el usuario.
  final List<Maintenance> maintenance;

  ProfileStatsViewModel({required this.vehicles, required this.maintenance});

  /// Conteo total de la flota en formato de texto.
  String get vehicleCount => vehicles.length.toString();

  /// Conteo total de intervenciones técnicas registradas.
  String get maintenanceCount => maintenance.length.toString();

  /// Calcula el gasto acumulado global y aplica un formato de abreviación monetaria.
  /// 
  /// Ejemplos: "$2.5K", "$850".
  String get totalCostFormatted {
    final total = maintenance.fold<double>(0, (sum, item) => sum + item.cost);
    if (total >= 1000) return '\$${(total / 1000).toStringAsFixed(1)}K';
    return '\$${total.toStringAsFixed(0)}';
  }

  /// Retorna una lista estructurada de objetos para renderizar tarjetas de estadísticas.
  ///
  /// Consolida etiquetas localizadas, valores dinámicos y colores de identidad visual.
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
