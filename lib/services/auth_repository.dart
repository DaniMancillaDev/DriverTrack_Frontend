import '../models/user_model.dart';
import 'api_client.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  /// Registra un nuevo usuario en la base de datos
  Future<User> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final response = await _apiClient.post('/auth/register', {
      'email': email,
      'password': password,
      'full_name': fullName,
    });

    // El endpoint /auth/register responde con el objeto UserResponse directamente
    return User.fromJson(response);
  }

  /// Inicia sesión con credenciales existentes
  Future<User> login({required String email, required String password}) async {
    final response = await _apiClient.post('/auth/login', {
      'email': email,
      'password': password,
    });

    // El endpoint /auth/login devuelve { "message": "...", "user": { ... } }
    if (response['user'] != null) {
      return User.fromJson(response['user']);
    } else {
      throw Exception('Estructura de respuesta inválida desde el backend.');
    }
  }
}
