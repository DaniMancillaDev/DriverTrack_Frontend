class MapLocation {
  final String id;
  final String name;
  final String type; // 'workshop' | 'gasstation'
  final String address;
  final double rating;
  final int reviews;
  final String distance;
  final bool open;
  final String hours;
  final String phone;
  final double latitude;
  final double longitude;
  final List<String>? specialties;
  final String priceLevel;

  const MapLocation({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.rating,
    required this.reviews,
    required this.distance,
    required this.open,
    required this.hours,
    required this.phone,
    required this.latitude,
    required this.longitude,
    this.specialties,
    required this.priceLevel,
  });

  MapLocation copyWith({String? distance, bool? open}) {
    return MapLocation(
      id: id,
      name: name,
      type: type,
      address: address,
      rating: rating,
      reviews: reviews,
      distance: distance ?? this.distance,
      open: open ?? this.open,
      hours: hours,
      phone: phone,
      latitude: latitude,
      longitude: longitude,
      specialties: specialties,
      priceLevel: priceLevel,
    );
  }
}
