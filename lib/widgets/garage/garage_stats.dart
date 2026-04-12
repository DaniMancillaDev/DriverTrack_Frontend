import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../models/vehicle_model.dart';
import '../../viewmodels/vehicle_view_model.dart';
import '../../providers/app_providers.dart';
import '../ui/summary_stats.dart';
import '../../core/i18n/translations.g.dart';
import '../../core/units/presentation/unit_system_provider.dart';
import '../../core/units/domain/unit_system.dart';
import '../../core/units/domain/unit_converter.dart';
import '../../core/units/domain/unit_formatter.dart';

/// Panel de resumen estadístico para el garaje del usuario.
/// 
/// Calcula métricas agregadas de toda la flota, incluyendo el kilometraje 
/// acumulado total (considerando registros de mantenimiento) y el número 
/// de vehículos que requieren atención inmediata ('services due').
class GarageStats extends ConsumerWidget {
  /// Lista de vehículos sobre los cuales calcular las estadísticas.
  final List<Vehicle> vehicles;

  const GarageStats({super.key, required this.vehicles});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final unitSystem = ref.watch(unitSystemProvider);
    final isMetric = unitSystem == UnitSystem.metric;
    final totalDistanceLabel = isMetric
        ? t.garage.totalFleetDistance
        : t.garage.totalFleetDistanceMiles;

    if (vehicles.isEmpty) {
      return SummaryStats(
        stats: [
          StatItem(
            label: t.garage.vehicles,
            value: '0',
            accent: AppColors.orangePrimary,
          ),
          StatItem(label: t.garage.alerts, value: '0', accent: AppColors.red),
        ],
      );
    }

    // Observa los registros de mantenimiento para todos los vehículos
    final maintenanceAsync = ref.watch(
      maintenanceDocsProvider(const MaintenanceParams()),
    );

    return maintenanceAsync.maybeWhen(
      data: (allRecords) {
        // Calcula el kilometraje total tomando el máximo de cada vehículo
        int totalCalculatedMiles = 0;
        for (var vehicle in vehicles) {
          int vehicleMileage = vehicle.mileage;
          final vehicleRecords = allRecords
              .where((r) => r.vehicleId == vehicle.id)
              .toList(); // Materializar para evitar múltiples iteraciones

          if (vehicleRecords.isNotEmpty) {
            final latestRecordMileage = vehicleRecords
                .map((r) => r.mileage)
                .reduce((a, b) => a > b ? a : b);
            if (latestRecordMileage > vehicleMileage) {
              vehicleMileage = latestRecordMileage;
            }
          }

          totalCalculatedMiles += vehicleMileage;
        }

        final servicesDue = vehicles.where((v) {
          final vehicleRecords = allRecords.where((r) => r.vehicleId == v.id).toList();
          return VehicleViewModel.fromVehicleWithRecords(v, vehicleRecords).status != 'good';
        }).length;

        // Convierte el valor si es necesario (asumiendo que la base es KM)
        final double mileageToDisplay = isMetric 
            ? totalCalculatedMiles.toDouble() 
            : UnitConverter.kmToMi(totalCalculatedMiles.toDouble());

        final displayValue = UnitFormatter.formatOdometer(mileageToDisplay);

        return SummaryStats(
          stats: [
            StatItem(
              label: totalDistanceLabel,
              value: displayValue,
              accent: AppColors.orangePrimary,
            ),
            StatItem(
              label: t.garage.servicesDue,
              value: servicesDue.toString(),
              accent: servicesDue > 0 ? AppColors.red : AppColors.green,
            ),
          ],
        );
      },
      // Mantiene estadísticas básicas visibles durante carga o error
      orElse: () {
        final totalMiles = vehicles.fold<int>(0, (sum, v) => sum + v.mileage);
        final servicesDue = vehicles
            .where((v) => VehicleViewModel(v).status != 'good')
            .length;

        // Convierte el valor de respaldo
        final double fallbackToDisplay = isMetric 
            ? totalMiles.toDouble() 
            : UnitConverter.kmToMi(totalMiles.toDouble());

        final displayFallback = UnitFormatter.formatOdometer(fallbackToDisplay);

        return SummaryStats(
          stats: [
            StatItem(
              label: totalDistanceLabel,
              value: displayFallback,
              accent: AppColors.orangePrimary,
            ),
            StatItem(
              label: t.garage.servicesDue,
              value: servicesDue.toString(),
              accent: servicesDue > 0 ? AppColors.red : AppColors.green,
            ),
          ],
        );
      },
    );
  }
}
