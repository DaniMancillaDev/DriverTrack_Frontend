import '../../domain/entities/map_location.dart';

class MapLocationModel extends MapLocation {
  const MapLocationModel({
    required super.id,
    required super.name,
    required super.type,
    required super.address,
    required super.rating,
    required super.reviews,
    required super.distance,
    required super.open,
    required super.hours,
    required super.phone,
    required super.latitude,
    required super.longitude,
    super.specialties,
    required super.priceLevel,
  });

  factory MapLocationModel.fromJson(Map<String, dynamic> json) {
    return MapLocationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      address: json['address'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviews: json['reviews'] as int,
      distance: json['distance'] as String,
      open: json['open'] as bool,
      hours: json['hours'] as String,
      phone: json['phone'] as String,
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
      specialties: json['specialties'] != null
          ? List<String>.from(json['specialties'] as List)
          : null,
      priceLevel: json['price_level'] as String,
    );
  }
}
