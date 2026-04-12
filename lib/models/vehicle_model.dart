import 'vehicle_type_model.dart';

/// Representa un vehículo registrado en la plataforma DriverTrack.
/// 
/// Contiene toda la información técnica, de kilometraje y estado 
/// necesaria para gestionar el mantenimiento y las alertas del conductor.
class Vehicle {
  /// Identificador único del vehículo en la base de datos.
  final int id;

  /// ID del usuario propietario del vehículo.
  final int userId;

  /// ID de la categoría de vehículo ([VehicleType]).
  final int typeId;

  /// Marca del vehículo (ej. Toyota, Ford).
  final String brand;

  /// Modelo o línea del vehículo (ej. Corolla, F-150).
  final String model;

  /// Placa o matrícula del vehículo.
  final String plate;

  /// Año de fabricación.
  final int year;

  /// Kilometraje actual acumulado.
  final int mileage;

  /// Kilometraje máximo de vida útil útil o umbral para alertas críticas.
  final int maxMileage;

  /// URL de la imagen del vehículo almacenada en el servidor (ej. MinIO).
  final String? imageUrl;

  /// Fecha sugerida o calculada para el próximo servicio de mantenimiento.
  final String? nextService;

  /// Indica si el vehículo ha sido marcado como favorito por el usuario.
  final bool isFavorite;

  /// Objeto detallado de la categoría del vehículo.
  final VehicleType vehicleType;

  Vehicle({
    required this.id,
    required this.userId,
    required this.typeId,
    required this.brand,
    required this.model,
    required this.plate,
    required this.year,
    required this.mileage,
    required this.maxMileage,
    this.imageUrl,
    this.nextService,
    this.isFavorite = false,
    required this.vehicleType,
  });

  /// Crea una instancia de [Vehicle] a partir de un mapa JSON del backend.
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      typeId: json['type_id'] as int,
      brand: json['brand'] as String,
      model: json['model'] as String,
      plate: json['plate'] as String,
      year: json['year'] as int,
      mileage: json['mileage'] as int? ?? 0,
      maxMileage: json['max_mileage'] as int? ?? 50000,
      imageUrl: json['image_url'] as String?,
      nextService: json['next_service'] as String?,
      isFavorite: json['is_favorite'] as bool? ?? false,
      vehicleType: VehicleType.fromJson(json['vehicle_type']),
    );
  }

  /// Convierte la instancia de [Vehicle] a un mapa JSON para enviar al servidor.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type_id': typeId,
      'brand': brand,
      'model': model,
      'plate': plate,
      'year': year,
      'mileage': mileage,
      'max_mileage': maxMileage,
      'image_url': imageUrl,
      'next_service': nextService,
      'is_favorite': isFavorite,
      'vehicle_type': vehicleType.toJson(),
    };
  }

  /// Crea una copia de este objeto con los campos proporcionados sobrescritos.
  Vehicle copyWith({
    int? id,
    int? userId,
    int? typeId,
    String? brand,
    String? model,
    String? plate,
    int? year,
    int? mileage,
    int? maxMileage,
    String? imageUrl,
    String? nextService,
    bool? isFavorite,
    VehicleType? vehicleType,
  }) {
    return Vehicle(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      typeId: typeId ?? this.typeId,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      plate: plate ?? this.plate,
      year: year ?? this.year,
      mileage: mileage ?? this.mileage,
      maxMileage: maxMileage ?? this.maxMileage,
      imageUrl: imageUrl ?? this.imageUrl,
      nextService: nextService ?? this.nextService,
      isFavorite: isFavorite ?? this.isFavorite,
      vehicleType: vehicleType ?? this.vehicleType,
    );
  }

  /// Nombre legible del vehículo combinando Marca y Modelo.
  String get displayName => '$brand $model';
}
