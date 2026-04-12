/// Entidad de dominio que representa un punto de interés en el mapa.
/// 
/// Consolida información de talleres, gasolineras y otros servicios automotrices,
/// incluyendo metadatos de contacto, horarios y ubicación geográfica.
class MapLocation {
  /// Identificador único del punto (usualmente del proveedor de mapas).
  final String id;

  /// Nombre comercial o descriptivo del lugar.
  final String name;

  /// Tipo de lugar (ej: 'workshop', 'gasstation').
  final String type;

  /// Dirección física completa.
  final String address;

  /// Calificación promedio de usuarios (0.0 a 5.0).
  final double rating;

  /// Cantidad total de reseñas recibidas.
  final int reviews;

  /// Distancia relativa al usuario (ej: "2.5 km").
  final String distance;

  /// Indica si el establecimiento está abierto al público actualmente.
  final bool open;

  /// Horario de atención formateado para humanos.
  final String hours;

  /// Número telefónico de contacto.
  final String phone;

  /// Latitud geográfica.
  final double latitude;

  /// Longitud geográfica.
  final double longitude;

  /// Lista de servicios especializados (ej: 'frenos', 'pintura').
  final List<String>? specialties;

  /// Nivel de precio estimado (ej: '$$').
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

  /// Crea una copia de la ubicación con campos específicos actualizados.
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
