import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/units/presentation/unit_system_provider.dart' show sharedPreferencesProvider;
import '../features/auth/domain/user_model.dart';
import '../core/security/secure_storage_service.dart';
import 'app_providers.dart';

/// Notifier encargado de orquestar el estado de autenticación central.
/// 
/// Gestiona la persistencia de la sesión mediante una combinación de:
/// * **SharedPreferences**: Almacena el perfil básico del usuario ([User]) para acceso rápido.
/// * **Flutter Secure Storage**: Almacena de forma segura los tokens JWT (access y refresh).
/// 
/// El estado (`state`) es nulo si no hay una sesión activa o si la validación inicial falla.
class AuthNotifier extends Notifier<User?> {
  /// Clave para persistir el perfil serializado del usuario.
  static const _userKey = 'user_session';
  /// Clave para el token de acceso JWT.
  static const _tokenKey = 'user_token';
  /// Clave para el token de refresco JWT.
  static const _refreshTokenKey = 'user_refresh_token';

  @override
  User? build() {
    // Carga síncrona de la sesión al inicializar el notifier.
    return _loadSessionSync();
  }

  // ─── Persistencia ──────────────────────────────────────────

  /// Intenta reconstruir la sesión de usuario desde el almacenamiento local.
  User? _loadSessionSync() {
    final prefs = ref.read(sharedPreferencesProvider);
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        final user = User.fromJson(jsonDecode(userJson));
        final token = ref.read(initialAccessTokenProvider);
        if (token == null || token.isEmpty) {
          _log('Sesión huérfana (sin token), limpiando.');
          _clearSessionSync();
          return null;
        }
        final restoredUser = user.copyWith(token: token);
        _log('Sesión cargada para ${restoredUser.email}');
        return restoredUser;
      } catch (e) {
        _log('Datos de sesión corruptos, limpiando.', isError: true);
        _clearSessionSync();
      }
    } else {
      _log('No se encontró sesión previa.');
    }
    return null;
  }

  /// Persiste los datos de usuario y los tokens de seguridad.
  Future<void> _saveSession(User user, {String? refreshToken}) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final secureStorage = ref.read(secureStorageProvider);
    
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    if (user.token != null) {
      await secureStorage.write(key: _tokenKey, value: user.token!);
    }
    if (refreshToken != null) {
      await secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  /// Limpia todos los registros de sesión (Logout).
  Future<void> _clearSession() async {
    _clearSessionSync();
  }

  /// Operación síncrona de limpieza de almacenamiento.
  void _clearSessionSync() {
    final prefs = ref.read(sharedPreferencesProvider);
    final secureStorage = ref.read(secureStorageProvider);
    prefs.remove(_userKey);
    secureStorage.delete(key: _tokenKey);
    secureStorage.delete(key: _refreshTokenKey);
  }

  // ─── Token Refresh ─────────────────────────────────────────

  /// Proceso automático de renovación de credenciales.
  /// 
  /// Es invocado habitualmente por el [ApiClient] tras detectar un error 401.
  /// Intenta intercambiar el `refresh_token` persistido por un nuevo `access_token`.
  /// Retorna el nuevo token si la operación es exitosa, o null si el refresco falló o expiró.
  Future<String?> tryRefreshToken() async {
    final secureStorage = ref.read(secureStorageProvider);
    final refreshToken = await secureStorage.read(key: _refreshTokenKey) ?? ref.read(initialRefreshTokenProvider);

    if (refreshToken == null || refreshToken.isEmpty) {
      _log('No hay token de refresco disponible.', isError: true);
      return null;
    }

    _log('Iniciando refresco de token...');
    try {
      final repo = ref.read(authRepositoryProvider);
      final newAccessToken = await repo.refreshAccessToken(refreshToken);

      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        final updatedUser = state?.copyWith(token: newAccessToken);
        if (updatedUser != null) {
          await secureStorage.write(key: _tokenKey, value: newAccessToken);
          state = updatedUser;
          _log('Token refrescado exitosamente.');
        }
        return newAccessToken;
      }
    } catch (e) {
      _log('Fallo en el refresco de token: $e', isError: true);
    }

    return null;
  }

  // ─── Acciones públicas ─────────────────────────────────────

  /// Inicia el flujo de autenticación mediante correo y contraseña.
  Future<void> login(String email, String password) async {
    _log('Iniciando login para $email');
    final repo = ref.read(authRepositoryProvider);
    final tokens = await repo.login(email: email, password: password);
    await _saveSession(tokens.user, refreshToken: tokens.refreshToken);
    state = tokens.user;
    _log('Login exitoso para ${tokens.user.email}');
  }

  /// Crea una nueva cuenta de usuario y establece la sesión.
  Future<void> register(String email, String password, String fullName) async {
    _log('Iniciando registro para $email');
    final repo = ref.read(authRepositoryProvider);
    final tokens = await repo.register(
      email: email,
      password: password,
      fullName: fullName,
    );
    await _saveSession(tokens.user, refreshToken: tokens.refreshToken);
    state = tokens.user;
    _log('Registro exitoso para ${tokens.user.email}');
  }

  /// Cierra la sesión activa y borra las credenciales locales.
  void logout() {
    _log('Cierre de sesión iniciado por el usuario.');
    state = null;
    _clearSession();
  }

  /// Cierra la sesión forzosamente debido a la expiración de los secretos.
  /// Se usa para diferenciar la acción manual del usuario de un fallo de seguridad.
  void logoutDueToExpiry() {
    _log('Sesión expirada — forzando cierre.', isError: true);
    state = null;
    _clearSession();
  }

  /// Actualiza los metadatos de perfil del usuario sincronizándolos con el servidor.
  Future<void> updateProfile(String fullName) async {
    final repo = ref.read(userRepositoryProvider);
    final updatedUser = await repo.updateProfile(fullName: fullName);
    final currentToken = state?.token;
    final mergedUser = updatedUser.copyWith(token: currentToken);
    await _saveSession(mergedUser);
    state = mergedUser;
    _log('Perfil actualizado para ${mergedUser.fullName}');
  }

  /// Actualiza la URL de la foto de perfil en el estado reactivo y persistente.
  void updatePhotoUrl(String photoUrl) {
    if (state == null) return;
    final updated = state!.copyWith(photoUrl: photoUrl);
    state = updated;
    _saveSession(updated);
    _log('Foto de perfil actualizada');
  }

  /// Registra el cambio de contraseña en los metadatos de sesión.
  void updatePasswordChangedAt(DateTime timestamp) {
    if (state == null) return;
    final updated = state!.copyWith(passwordChangedAt: timestamp);
    state = updated;
    _saveSession(updated);
    _log('Timestamp de cambio de contraseña actualizado');
  }

  // ─── Logging ───────────────────────────────────────────────

  void _log(String message, {bool isError = false}) {
    if (!kDebugMode) return;
    dev.log(message, name: 'AuthNotifier', level: isError ? 1000 : 0);
  }
}

/// Provider global que expone el estado de autenticación a toda la aplicación.
final authProvider = NotifierProvider<AuthNotifier, User?>(
  () => AuthNotifier(),
);
