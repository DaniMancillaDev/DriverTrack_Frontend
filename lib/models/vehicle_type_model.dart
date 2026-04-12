class VehicleType {
  final int id;
  final String slug;
  final String label;
  final String icon;
  final String imageUrl;

  VehicleType({
    required this.id,
    required this.slug,
    required this.label,
    required this.icon,
    required this.imageUrl,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) {
    return VehicleType(
      id: json['id'],
      slug: json['slug'] ?? '',
      label: json['label'] ?? '',
      icon: json['icon'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'slug': slug,
    'label': label,
    'icon': icon,
    'image_url': imageUrl,
  };

  /// Determina si este tipo corresponde a una motocicleta.
  ///
  /// Usa múltiples criterios para ser robusto ante variaciones en los datos
  /// devueltos por la API (diferentes convenciones de slug/icon).
  bool get isMotorcycle {
    final s = slug.toLowerCase();
    final i = icon.toLowerCase();
    return i == 'motorcycle_rounded' ||
        s.contains('moto') ||
        s.contains('motorcycle') ||
        s.contains('bike') ||
        i.contains('motorcycle') ||
        i.contains('moto');
  }

  /// Determina si este tipo corresponde a un carro/automóvil.
  bool get isCar {
    final s = slug.toLowerCase();
    final i = icon.toLowerCase();
    return i == 'directions_car_filled_rounded' ||
        s.contains('car') ||
        s.contains('auto') ||
        i.contains('car') ||
        i.contains('auto');
  }

  @override
  String toString() =>
      'VehicleType(id: $id, slug: $slug, label: $label, icon: $icon)';
}
