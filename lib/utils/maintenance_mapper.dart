import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MaintenanceMapper {
  /// Parses the raw description to extract a main title for the UI.
  /// (e.g., "Oil Change | Used synthetic" -> "Oil Change")
  static String getTitle(String description) {
    if (description.contains('|')) {
      return description.split('|')[0].trim();
    }
    return description;
  }

  /// Parses the raw description to extract the secondary notes.
  /// (e.g., "Oil Change | Used synthetic" -> "Used synthetic")
  static String? getNotes(String description) {
    if (description.contains('|')) {
      final parts = description.split('|');
      if (parts.length > 1 && parts[1].trim().isNotEmpty) {
        return parts[1].trim();
      }
    }
    return null;
  }

  /// Infers a UI category from the maintenance description.
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

  /// Returns a specific UI icon based on the inferred category.
  static IconData getIcon(String category) {
    if (category == 'Fluid Service') return Icons.opacity;
    if (category == 'Wear & Tear') return Icons.build_circle_outlined;
    if (category == 'Inspection') return Icons.fact_check_outlined;
    if (category == 'Cosmetic') return Icons.water_drop;
    if (category == 'Electrical') return Icons.battery_charging_full;
    return Icons.settings_outlined;
  }

  /// Returns a specific UI color accent based on the inferred category.
  static Color getAccent(String category) {
    if (category == 'Fluid Service') return AppColors.orangePrimary;
    if (category == 'Wear & Tear') return AppColors.cyan;
    if (category == 'Inspection') return AppColors.green;
    if (category == 'Cosmetic') return AppColors.accent;
    if (category == 'Electrical') return AppColors.purple;
    return AppColors.textSecondary;
  }
}
