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
  ];
}
