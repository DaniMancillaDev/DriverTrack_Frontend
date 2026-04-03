import 'vehicle_type_model.dart';

class Vehicle {
  final int id;
  final int userId;
  final int typeId;
  final String brand;
  final String model;
  final String plate;
  final int year;
  final int mileage;
  final int maxMileage;
  final String? imageUrl;
  final String? nextService;
  final bool isFavorite;
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

  String get displayName => '$brand $model';
}
