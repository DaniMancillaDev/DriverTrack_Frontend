import 'package:flutter/material.dart';
import '../models/maintenance_model.dart';
import '../utils/maintenance_mapper.dart';
import '../core/i18n/translations.g.dart';

class MaintenanceViewModel {
  final Maintenance maintenance;

  const MaintenanceViewModel(this.maintenance);

  // Expose pure data directly for convenience
  int get id => maintenance.id;
  int get vehicleId => maintenance.vehicleId;
  DateTime get date => maintenance.date;
  String get description => maintenance.description;
  double get cost => maintenance.cost;
  int get mileage => maintenance.mileage;

  // Extracted Visual Properties via Mapper
  String get title => MaintenanceMapper.getTitle(description);
  String? get notes => MaintenanceMapper.getNotes(description);
  String get category => maintenance.category;
  IconData get computedIcon => MaintenanceMapper.getIcon(category);
  Color get computedAccent => MaintenanceMapper.getAccent(category);

  /// Returns the relative time since the service was performed.
  /// Uses i18n translations for locale-aware strings.
  String getTimeAgo(Translations t) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) return t.time.today;
    if (difference.inDays < 30)
      return t.time.daysAgo.replaceAll('{n}', '${difference.inDays}');
    if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return t.time.monthsAgo.replaceAll('{n}', '$months');
    }
    final years = (difference.inDays / 365).floor();
    return t.time.yearsAgo.replaceAll('{n}', '$years');
  }

  // Helper method (usually this comes from a separate provider/store, but useful for the UI rendering pass)
  String vehicleName(String nameFallback) => nameFallback;
}
