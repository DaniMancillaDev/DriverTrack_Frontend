// lib/models/maintenance_model.dart

/// Entidad de dominio representativa de una intervención técnica vehicular.
/// 
/// Su responsabilidad es encapsular los datos históricos de un servicio, 
/// incluyendo la trazabilidad cronológica, económica y técnica (kilometraje) 
/// del mantenimiento realizado.
class Maintenance {
  /// Identificador único del registro de mantenimiento.
  final int id;

  /// ID del vehículo asociado a este mantenimiento.
  final int vehicleId;

  /// Fecha en la que se realizó el mantenimiento.
  final DateTime date;

  /// Descripción detallada de las tareas realizadas (ej. Cambio de aceite).
  final String description;

  /// Costo total del servicio realizado.
  final double cost;

  /// Kilometraje del vehículo al momento de realizar el servicio.
  final int mileage;

  /// Categoría del mantenimiento (ej. Motor, Llantas, General).
  final String category;

  Maintenance({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.description,
    required this.cost,
    required this.mileage,
    this.category = 'General',
  });

  /// Crea una instancia de [Maintenance] a partir de un mapa JSON del servidor.
  factory Maintenance.fromJson(Map<String, dynamic> json) {
    return Maintenance(
      id: json['id'] as int,
      vehicleId: json['vehicle_id'] as int,
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String,
      // Manejar la posibilidad de que el Decimal de Python llegue como string o num
      cost: (json['cost'] is String)
          ? double.tryParse(json['cost']) ?? 0.0
          : (json['cost'] as num).toDouble(),
      mileage: json['mileage'] as int,
      category: json['category'] as String? ?? 'General',
    );
  }

  /// Convierte la instancia de [Maintenance] a un mapa JSON para enviar al API.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_id': vehicleId,
      'date':
          "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      'description': description,
      'cost': cost,
      'mileage': mileage,
      'category': category,
    };
  }

  /// Crea una copia de este objeto con los campos proporcionados sobrescritos.
  Maintenance copyWith({
    int? id,
    int? vehicleId,
    DateTime? date,
    String? description,
    double? cost,
    int? mileage,
    String? category,
  }) {
    return Maintenance(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      date: date ?? this.date,
      description: description ?? this.description,
      cost: cost ?? this.cost,
      mileage: mileage ?? this.mileage,
      category: category ?? this.category,
    );
  }
}
