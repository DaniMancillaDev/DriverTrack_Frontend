import 'package:flutter/material.dart';
import '../models/maintenance_model.dart';
import '../features/maintenance/domain/mappers/maintenance_mapper.dart';
import '../core/i18n/translations.g.dart';

/// Transformador de registros de mantenimiento para la interfaz de usuario.
///
/// Su responsabilidad es enriquecer los datos planos del dominio [Maintenance]
/// mediante mappers que determinan iconos, colores y formato de fechas 
/// relativo al contexto temporal del usuario.
class MaintenanceViewModel {
  /// Objeto de dominio que contiene los datos base del servicio.
  final Maintenance maintenance;

  const MaintenanceViewModel(this.maintenance);

  /// Identificador único del registro.
  int get id => maintenance.id;

  /// Referencia al vehículo asociado.
  int get vehicleId => maintenance.vehicleId;

  /// Fecha cronológica del servicio.
  DateTime get date => maintenance.date;

  /// Descripción original ingresada por el usuario o sistema.
  String get description => maintenance.description;

  /// Inversión económica en el servicio.
  double get cost => maintenance.cost;

  /// Kilometraje del odómetro registrado al momento del servicio.
  int get mileage => maintenance.mileage;

  /// Título sintético extraído de la descripción (normalmente la primera línea).
  String get title => MaintenanceMapper.getTitle(description);

  /// Notas descriptivas adicionales.
  String? get notes => MaintenanceMapper.getNotes(description);

  /// Clasificación técnica del mantenimiento.
  String get category => maintenance.category;

  /// Icono representativo basado en la [category].
  IconData get computedIcon => MaintenanceMapper.getIcon(category);

  /// Color de énfasis visual basado en la [category].
  Color get computedAccent => MaintenanceMapper.getAccent(category);

  /// Calcula la antigüedad relativa del servicio en un formato humano y localizado.
  /// 
  /// Ejemplos: "Hoy", "Hace 3 días", "Hace 2 meses".
  String getTimeAgo(Translations t) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) return t.time.today;
    if (difference.inDays < 30) {
      return t.time.daysAgo(n: difference.inDays);
    }
    if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return t.time.monthsAgo(n: months);
    }
    final years = (difference.inDays / 365).floor();
    return t.time.yearsAgo(n: years);
  }

  /// Provee el nombre del vehículo asociado (usualmente inyectado desde el contexto).
  String vehicleName(String nameFallback) => nameFallback;
}
