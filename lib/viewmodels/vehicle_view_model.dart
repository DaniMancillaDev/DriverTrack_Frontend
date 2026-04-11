import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';
import '../theme/app_theme.dart';
import '../core/i18n/translations.g.dart';

/// Orquestador de la lógica de presentación para la ficha técnica de un [Vehicle].
///
/// Su responsabilidad es transformar los datos crudos del dominio en estados 
/// visuales comprensibles, calculando métricas de salud, determinando 
/// niveles de criticidad y resolviendo activos visuales (iconos/imágenes).
class VehicleViewModel {
  /// Entidad de dominio que contiene los datos base del vehículo.
  final Vehicle vehicle;

  /// Kilometraje temporal que sobrescribe el valor real (útil para simulaciones o previsualizaciones).
  final int? _overrideMileage;

  const VehicleViewModel(this.vehicle, [this._overrideMileage]);

  /// Identificador persistente del vehículo.
  int get id => vehicle.id;

  /// Referencia al propietario de la unidad.
  int get userId => vehicle.userId;

  /// Categoría técnica del vehículo (ej: 'sedan', 'motorcycle').
  String get type => vehicle.vehicleType.slug;

  /// Fabricante del vehículo.
  String get brand => vehicle.brand;

  /// Línea o modelo comercial.
  String get model => vehicle.model;

  /// Identificación alfanumérica ante las autoridades de tránsito.
  String get plate => vehicle.plate;

  /// Año de ensamblaje o registro inicial.
  int get year => vehicle.year;

  /// Odómetro actual, priorizando valores de sobrescritura si existen.
  int get mileage => _overrideMileage ?? vehicle.mileage;

  /// Límite de kilometraje configurado para el próximo mantenimiento mayor.
  /// Garantiza que el valor mínimo sea 1 para evitar errores aritméticos.
  int get maxMileage =>
      vehicle.maxMileage == 0 ? 1 : vehicle.maxMileage;

  /// Dirección URL de la imagen representativa en el servidor.
  String? get imageUrl => vehicle.imageUrl;

  /// Descripción textual del próximo servicio programado.
  String? get nextService => vehicle.nextService;

  /// Clasificación semántica del estado del vehículo basada en la proximidad al [maxMileage].
  /// 
  /// Niveles resultantes:
  /// * **'good'**: Salud óptima (>= 90%).
  /// * **'warning'**: Requiere atención pronta (>= 70%).
  /// * **'critical'**: Mantenimiento urgente o vencido (< 70%).
  String get status {
    final hp = healthPercentage;
    if (hp >= 90) return 'good';
    if (hp >= 70) return 'warning';
    return 'critical';
  }

  /// Indica si el usuario ha marcado esta unidad como favorita para acceso rápido.
  bool get isFavorite => vehicle.isFavorite;

  /// Resuelve el glifo visual representativo del tipo de vehículo.
  IconData get typeIcon => _getIconData(vehicle.vehicleType.icon);

  /// Centraliza el mapeo de identificadores de iconos a constantes de [Icons].
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

  /// Denominación comercial completa (Marca + Modelo).
  String get displayName => vehicle.displayName;

  // ─── Lógica de Salud Visual ──────────────────────────────────

  /// Porcentaje de vida útil restante antes del próximo gran mantenimiento.
  /// 
  /// Se calcula como la relación inversa entre el kilometraje actual y el máximo permitido.
  double get healthPercentage {
    return (100 - (mileage / maxMileage * 100)).toDouble().clamp(0, 100);
  }

  /// Color temático asociado al nivel de urgencia del mantenimiento.
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

  /// Glifo de estado para feedback visual rápido sobre la salud.
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

  /// Etiqueta descriptiva y localizada que resume el estado actual.
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

  /// Resuelve la imagen a mostrar, usando una foto real o un respaldo (placeholder) 
  /// basado en la tipología del vehículo.
  String get displayImageUrl {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return imageUrl!;
    }
    // Respaldo inteligente basado en el tipo
    if (vehicle.vehicleType.slug.toLowerCase().contains('motorcycle') || typeIcon == Icons.motorcycle_rounded) {
      return 'assets/images/demo_motorcycle.png';
    }
    return 'assets/images/demo_car.png';
  }
}
