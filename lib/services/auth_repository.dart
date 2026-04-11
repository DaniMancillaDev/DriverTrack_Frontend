import '../models/user_model.dart';
import 'api_client.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  /// Registra un nuevo usuario en la base de datos
  Future<AuthTokens> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final response = await _apiClient.post('/auth/register', {
      'email': email,
      'password': password,
      'full_name': fullName,
    });

    // Responde: { "access_token": "...", "refresh_token": "...", "user": { ... } }
    final accessToken = response['access_token'] as String;
    final refreshToken = response['refresh_token'] as String;
    final userData = response['user'] ?? response;
    final user = User.fromJson(userData).copyWith(token: accessToken);
    return AuthTokens(user: user, refreshToken: refreshToken);
  }

  /// Inicia sesión con credenciales existentes
  Future<AuthTokens> login({required String email, required String password}) async {
    final response = await _apiClient.post('/auth/login', {
      'email': email,
      'password': password,
    });

    // Responde: { "access_token": "...", "refresh_token": "...", "user": { ... } }
    final accessToken = response['access_token'] as String;
    final refreshToken = response['refresh_token'] as String;
    final userData = response['user'];
    if (userData == null) {
      throw Exception('Estructura de respuesta inválida desde el backend.');
    }
    final user = User.fromJson(userData).copyWith(token: accessToken);
    return AuthTokens(user: user, refreshToken: refreshToken);
  }

  /// Solicita un nuevo access token usando el refresh token guardado.
  /// Devuelve el nuevo access token, o null si el refresh token también expiró.
  Future<String?> refreshAccessToken(String refreshToken) async {
    try {
      final response = await _apiClient.post('/auth/refresh', {
        'refresh_token': refreshToken,
      });
      return response['access_token'] as String?;
    } catch (_) {
      return null;
    }
  }
}

/// Contenedor de tokens devueltos por login/register.
class AuthTokens {
  final User user;
  final String refreshToken;

  const AuthTokens({required this.user, required this.refreshToken});
}
