import '../features/auth/domain/user_model.dart';
import '../core/network/api_client.dart';

/// Repositorio para la gestión de la identidad y preferencias del usuario.
/// 
/// Centraliza las operaciones de perfil, incluyendo la edición de datos 
/// personales, configuración de privacidad/notificaciones y seguridad de cuenta.
class UserRepository {
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  /// Actualiza los datos básicos del perfil (nombre completo).
  Future<User> updateProfile({required String fullName}) async {
    final response = await _apiClient.put('/users/me', {
      'full_name': fullName,
    });
    return User.fromJson(response);
  }

  /// Sincroniza las preferencias de usuario para distintos tipos de alertas.
  /// 
  /// Permite activar/desactivar notificaciones push, recordatorios de 
  /// servicio y alertas críticas de forma independiente.
  Future<User> updatePreferences({
    bool? pushNotifications,
    bool? serviceReminders,
    bool? criticalAlerts,
  }) async {
    final Map<String, dynamic> body = {};
    if (pushNotifications != null) body['push_notifications'] = pushNotifications;
    if (serviceReminders != null) body['service_reminders'] = serviceReminders;
    if (criticalAlerts != null) body['critical_alerts'] = criticalAlerts;

    final response = await _apiClient.patch('/users/me/preferences', body);
    return User.fromJson(response);
  }

  /// Gestiona de forma segura el cambio de contraseña del usuario autenticado.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _apiClient.post('/users/me/change-password', {
      'current_password': currentPassword,
      'new_password': newPassword,
    });
  }

  /// Genera un set de metadatos y URL pre-firmada para la carga de avatar.
  /// 
  /// Retorna un mapa con la 'upload_url' (para la subida) y la 'photo_url' 
  /// final que representará al usuario.
  Future<Map<String, String>> getPhotoPresignedUrl() async {
    final response = await _apiClient.post('/users/me/photo/presigned-url', {});
    return {
      'upload_url': response['upload_url'] as String,
      'photo_url': response['photo_url'] as String,
      'object_key': response['object_key'] as String,
    };
  }

  /// Finaliza el proceso de actualización de foto tras la carga exitosa al bucket.
  Future<User> confirmPhotoUpload({required String objectKey}) async {
    final response = await _apiClient.put(
      '/users/me/photo/confirm?object_key=${Uri.encodeComponent(objectKey)}',
      {},
    );
    return User.fromJson(response);
  }

  /// Recupera la última versión del perfil del usuario desde el servidor.
  Future<User> getCurrentUser() async {
    final response = await _apiClient.get('/users/me');
    return User.fromJson(response);
  }
}
