import '../models/user_model.dart';
import 'api_client.dart';

class UserRepository {
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  /// Actualiza el nombre del usuario autenticado
  Future<User> updateProfile({required String fullName}) async {
    final response = await _apiClient.put('/users/me', {
      'full_name': fullName,
    });
    return User.fromJson(response);
  }

  /// Cambia la contraseña del usuario autenticado
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _apiClient.post('/users/me/change-password', {
      'current_password': currentPassword,
      'new_password': newPassword,
    });
  }

  /// Obtiene una URL pre-firmada para subir foto de perfil
  Future<Map<String, String>> getPhotoPresignedUrl() async {
    final response = await _apiClient.post('/users/me/photo/presigned-url', {});
    return {
      'upload_url': response['upload_url'] as String,
      'photo_url': response['photo_url'] as String,
      'object_key': response['object_key'] as String,
    };
  }

  /// Confirma la subida de foto y actualiza la URL en el perfil
  Future<User> confirmPhotoUpload({required String objectKey}) async {
    final response = await _apiClient.put(
      '/users/me/photo/confirm?object_key=${Uri.encodeComponent(objectKey)}',
      {},
    );
    return User.fromJson(response);
  }

  /// Obtiene el perfil del usuario autenticado
  Future<User> getCurrentUser() async {
    final response = await _apiClient.get('/users/me');
    return User.fromJson(response);
  }
}
