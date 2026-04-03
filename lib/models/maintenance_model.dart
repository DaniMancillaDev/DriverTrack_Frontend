// lib/models/maintenance_model.dart

class Maintenance {
  final int id;
  final int vehicleId;
  final DateTime date;
  final String description;
  final double cost;
  final int mileage;
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

  factory Maintenance.fromJson(Map<String, dynamic> json) {
    return Maintenance(
      id: json['id'] as int,
      vehicleId: json['vehicle_id'] as int,
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String,
      // Manejar la posibilidad de que el Decimal de Python llegue como string o int
      cost: (json['cost'] is String)
          ? double.tryParse(json['cost']) ?? 0.0
          : (json['cost'] as num).toDouble(),
      mileage: json['mileage'] as int,
      category: json['category'] as String? ?? 'General',
    );
  }

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
