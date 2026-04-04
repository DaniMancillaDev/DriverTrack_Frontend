import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';
import '../theme/app_theme.dart';
import '../core/i18n/translations.g.dart';

class VehicleViewModel {
  final Vehicle vehicle;
  final int? _overrideMileage;

  const VehicleViewModel(this.vehicle, [this._overrideMileage]);

  // Expose pure data directly for convenience
  int get id => vehicle.id;
  int get userId => vehicle.userId;
  String get type => vehicle.vehicleType.slug;
  String get brand => vehicle.brand;
  String get model => vehicle.model;
  String get plate => vehicle.plate;
  int get year => vehicle.year;
  int get mileage => _overrideMileage ?? vehicle.mileage;
  int get maxMileage =>
      vehicle.maxMileage == 0 ? 1 : vehicle.maxMileage; // prevent div by 0
  String? get imageUrl => vehicle.imageUrl;
  String? get nextService => vehicle.nextService;
  String get status {
    final hp = healthPercentage;
    if (hp >= 90) return 'good';
    if (hp >= 70) return 'warning';
    return 'critical';
  }

  bool get isFavorite => vehicle.isFavorite;

  IconData get typeIcon => _getIconData(vehicle.vehicleType.icon);

  static IconData _getIconData(String name) {
    switch (name) {
      case 'directions_car_filled_rounded':
        return Icons.directions_car_filled_rounded;
      case 'motorcycle_rounded':
        return Icons.motorcycle_rounded;
      default:
        return Icons.directions_car;
    }
  }

  String get displayName => vehicle.displayName;

  // Visual Properties

  /// Calculates the health percentage based on mileage limits.
  /// Result is clamped between 0 and 100.
  double get healthPercentage {
    return (100 - (mileage / maxMileage * 100)).toDouble().clamp(0, 100);
  }

  /// Returns the UI color associated with the vehicle's health status.
  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'good':
      case 'healthy':
        return AppColors.green;
      case 'warning':
        return AppColors.orangeSecondary;
      case 'critical':
      case 'overdue':
        return AppColors.red;
      default:
        return AppColors.orangeSecondary; // Fallback
    }
  }

  /// Returns the UI icon associated with the vehicle's health status.
  IconData get statusIcon {
    switch (status.toLowerCase()) {
      case 'good':
      case 'healthy':
        return Icons.shield_outlined;
      case 'warning':
        return Icons.warning_amber_rounded;
      case 'critical':
      case 'overdue':
        return Icons.error_outline_rounded;
      default:
        return Icons.warning_amber_rounded; // Fallback
    }
  }

  /// A human-readable label for the vehicle's health status.
  String getStatusLabel(Translations t) {
    switch (status.toLowerCase()) {
      case 'good':
      case 'healthy':
        return t.garage.statusHealthy;
      case 'warning':
        return t.garage.statusNeedsService;
      case 'critical':
      case 'overdue':
        return t.garage.statusCritical;
      default:
        return t.common.unknownVehicle;
    }
  }

  /// Returns a placeholder image if the `imageUrl` is null or empty.
  String get displayImageUrl {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return imageUrl!;
    }
    return vehicle.vehicleType.imageUrl;
  }
}
