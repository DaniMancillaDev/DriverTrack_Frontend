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
      slug: json['slug'],
      label: json['label'],
      icon: json['icon'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'slug': slug,
    'label': label,
    'icon': icon,
    'image_url': imageUrl,
  };
}
