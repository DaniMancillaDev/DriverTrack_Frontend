import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

/// Utilidad para transformar datos crudos de mantenimiento en elementos visuales.
///
/// Ayuda a desacoplar la representación en el servidor (strings simples)
/// de la rica interfaz de usuario de DriverTrack (iconos, colores, segmentación).
class MaintenanceMapper {
  /// Extrae el título principal de una descripción.
  /// 
  /// Utiliza el carácter '|' para separar el título de las notas adicionales.
  /// Ej: "Cambio de Aceite | Sintético 5W30" -> "Cambio de Aceite"
  static String getTitle(String description) {
    if (description.contains('|')) {
      return description.split('|')[0].trim();
    }
    return description;
  }

  /// Extrae las notas secundarias de una descripción.
  /// 
  /// Si existe el carácter '|', retorna lo que está después de él.
  /// Ej: "Cambio de Aceite | Sintético 5W30" -> "Sintético 5W30"
  static String? getNotes(String description) {
    if (description.contains('|')) {
      final parts = description.split('|');
      if (parts.length > 1 && parts[1].trim().isNotEmpty) {
        return parts[1].trim();
      }
    }
    return null;
  }

  /// Infiere una categoría de UI basada en palabras clave en la descripción.
  ///
  /// Clasifica los servicios en grupos como 'Fluid Service', 'Wear & Tear', etc.
  /// para facilitar la organización visual.
  static String getCategory(String description) {
    final lowerDesc = description.toLowerCase();
    if (lowerDesc.contains('oil') || lowerDesc.contains('filter')) {
      return 'Fluid Service';
    } else if (lowerDesc.contains('tire') ||
        lowerDesc.contains('wheel') ||
        lowerDesc.contains('brake')) {
      return 'Wear & Tear';
    } else if (lowerDesc.contains('inspection') ||
        lowerDesc.contains('check')) {
      return 'Inspection';
    } else if (lowerDesc.contains('wash') || lowerDesc.contains('clean')) {
      return 'Cosmetic';
    } else if (lowerDesc.contains('battery') || lowerDesc.contains('spark')) {
      return 'Electrical';
    }
    return 'General';
  }

  /// Retorna un icono de Flutter específico para la categoría de mantenimiento.
  static IconData getIcon(String category) {
    if (category == 'Fluid Service') return Icons.opacity;
    if (category == 'Wear & Tear') return Icons.build_circle_outlined;
    if (category == 'Inspection') return Icons.fact_check_outlined;
    if (category == 'Cosmetic') return Icons.water_drop;
    if (category == 'Electrical') return Icons.battery_charging_full;
    return Icons.settings_outlined;
  }

  /// Retorna un color de énfasis para la categoría de mantenimiento.
  static Color getAccent(String category) {
    if (category == 'Fluid Service') return AppColors.orangePrimary;
    if (category == 'Wear & Tear') return AppColors.cyan;
    if (category == 'Inspection') return AppColors.green;
    if (category == 'Cosmetic') return AppColors.accent;
    if (category == 'Electrical') return AppColors.purple;
    return AppColors.textSecondary;
  }
}
