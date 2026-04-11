import 'package:flutter/material.dart';
import '../models/maintenance_model.dart';
import '../features/maintenance/domain/mappers/maintenance_mapper.dart';
import '../core/i18n/translations.g.dart';

/// Modelo de vista para representar un registro de [Maintenance] en la UI.
///
/// Refina los datos planos del modelo mediante mappers para obtener
/// iconos, colores y formato de fechas relativo al contexto actual.
class MaintenanceViewModel {
  /// Objeto de dominio del registro de mantenimiento.
  final Maintenance maintenance;

  const MaintenanceViewModel(this.maintenance);

  /// ID del registro.
  int get id => maintenance.id;

  /// ID del vehículo relacionado.
  int get vehicleId => maintenance.vehicleId;

  /// Fecha del servicio.
  DateTime get date => maintenance.date;

  /// Descripción original del servicio.
  String get description => maintenance.description;

  /// Costo total incurrido.
  double get cost => maintenance.cost;

  /// Kilometraje registrado en ese momento.
  int get mileage => maintenance.mileage;

  /// Título parseado a partir de la descripción (extrae la primera línea).
  String get title => MaintenanceMapper.getTitle(description);

  /// Notas adicionales (todo lo que no sea el título en la descripción).
  String? get notes => MaintenanceMapper.getNotes(description);

  /// Categoría del servicio.
  String get category => maintenance.category;

  /// Icono visual basado en la categoría.
  IconData get computedIcon => MaintenanceMapper.getIcon(category);

  /// Color de énfasis basado en la categoría.
  Color get computedAccent => MaintenanceMapper.getAccent(category);

  /// Calcula cuánto tiempo ha pasado desde el servicio en un formato legible.
  /// 
  /// Ejemplos: "Hoy", "Hace 3 días", "Hace 2 meses".
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

  /// Placeholder para el nombre del vehículo si fuese necesario inyectarlo.
  String vehicleName(String nameFallback) => nameFallback;
}
