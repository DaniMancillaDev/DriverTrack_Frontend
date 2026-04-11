import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';
import '../theme/app_theme.dart';
import '../core/i18n/translations.g.dart';

/// Modelo de vista para representar y gestionar un [Vehicle] en la UI.
///
/// Encapsula la lógica de presentación, como el cálculo del porcentaje de salud,
/// la selección de colores según el estado y la resolución de iconos.
class VehicleViewModel {
  /// El objeto de dominio del vehículo.
  final Vehicle vehicle;

  /// Kilometraje temporal que sobrescribe al del vehículo (usado en previsualizaciones).
  final int? _overrideMileage;

  const VehicleViewModel(this.vehicle, [this._overrideMileage]);

  /// Identificador único del vehículo.
  int get id => vehicle.id;

  /// ID del propietario.
  int get userId => vehicle.userId;

  /// Slug de identificación del tipo (ej: sedan, suv).
  String get type => vehicle.vehicleType.slug;

  /// Marca del vehículo.
  String get brand => vehicle.brand;

  /// Modelo del vehículo.
  String get model => vehicle.model;

  /// Placa o matrícula.
  String get plate => vehicle.plate;

  /// Año de fabricación.
  int get year => vehicle.year;

  /// Retorna el kilometraje actual, considerando sobrescrituras.
  int get mileage => _overrideMileage ?? vehicle.mileage;

  /// Kilometraje máximo para mantenimiento preventivo.
  /// Previene división por cero retornando 1 si es 0.
  int get maxMileage =>
      vehicle.maxMileage == 0 ? 1 : vehicle.maxMileage;

  /// URL de la imagen del vehículo.
  String? get imageUrl => vehicle.imageUrl;

  /// Fecha del próximo servicio programado.
  String? get nextService => vehicle.nextService;

  /// Determina el estado de salud del vehículo basado en su kilometraje.
  /// 
  /// * 'good': Salud >= 90%
  /// * 'warning': Salud >= 70%
  /// * 'critical': Salud < 70%
  String get status {
    final hp = healthPercentage;
    if (hp >= 90) return 'good';
    if (hp >= 70) return 'warning';
    return 'critical';
  }

  /// Indica si es un vehículo favorito para el acceso rápido.
  bool get isFavorite => vehicle.isFavorite;

  /// Obtiene el icono de Flutter correspondiente al tipo de vehículo.
  IconData get typeIcon => _getIconData(vehicle.vehicleType.icon);

  /// Mapea nombres de strings a constantes de [Icons].
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

  /// Nombre completo (Marca + Modelo).
  String get displayName => vehicle.displayName;

  // Propiedades Visuales

  /// Calcula el porcentaje de salud (vida útil restante).
  /// El resultado se encuentra entre 0.0 y 100.0.
  double get healthPercentage {
    return (100 - (mileage / maxMileage * 100)).toDouble().clamp(0, 100);
  }

  /// Retorna el color de la UI asociado al estado de salud.
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
        return AppColors.orangeSecondary;
    }
  }

  /// Retorna el icono de estado asociado a la salud.
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
        return Icons.warning_amber_rounded;
    }
  }

  /// Retorna una etiqueta localizada para el estado de salud.
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

  /// Retorna la URL de la imagen si existe, o un recurso local de respaldo
  /// basado en el tipo de vehículo.
  String get displayImageUrl {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return imageUrl!;
    }
    // Backup basado en el tipo
    if (vehicle.vehicleType.slug.toLowerCase().contains('motorcycle') || typeIcon == Icons.motorcycle_rounded) {
      return 'assets/images/demo_motorcycle.png';
    }
    return 'assets/images/demo_car.png';
  }
}
