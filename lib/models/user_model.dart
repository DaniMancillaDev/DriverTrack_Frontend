class User {
  final int id;
  final String email;
  final String fullName;
  final bool isActive;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.isActive,
    required this.createdAt,
  });

  /// Crea un objeto `User` a partir del JSON recibido de la API.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Convierte el objeto a un mapa JSON (opcional, por si necesitas mandarlo)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
