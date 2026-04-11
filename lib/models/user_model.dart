class User {
  final int id;
  final String email;
  final String fullName;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? passwordChangedAt;
  final String? photoUrl;

  /// JWT o token de sesión devuelto por el backend. Puede ser null
  /// si el backend usa cookies en vez de Bearer tokens.
  final String? token;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.isActive,
    required this.createdAt,
    this.passwordChangedAt,
    this.photoUrl,
    this.token,
  });

  /// Crea un objeto `User` a partir del JSON recibido de la API.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      passwordChangedAt: json['password_changed_at'] != null 
          ? DateTime.parse(json['password_changed_at'] as String).toLocal() 
          : null,
      photoUrl: json['photo_url'] as String?,
      token: json['token'] as String?,
    );
  }

  User copyWith({
    int? id,
    String? email,
    String? fullName,
    bool? isActive,
    DateTime? createdAt,
    DateTime? passwordChangedAt,
    String? photoUrl,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      passwordChangedAt: passwordChangedAt ?? this.passwordChangedAt,
      photoUrl: photoUrl ?? this.photoUrl,
      token: token ?? this.token,
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
      if (passwordChangedAt != null) 'password_changed_at': passwordChangedAt!.toUtc().toIso8601String(),
      if (photoUrl != null) 'photo_url': photoUrl,
      if (token != null) 'token': token,
    };
  }
}
