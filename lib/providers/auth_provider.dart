import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/units/presentation/unit_system_provider.dart' show sharedPreferencesProvider;
import '../models/user_model.dart';
import 'app_providers.dart';

/// Notifier que gestiona el usuario autenticado.
/// null = sin sesión activa (o cargando).
class AuthNotifier extends Notifier<User?> {
  static const _userKey = 'user_session';
  static const _tokenKey = 'user_token';
  static const _refreshTokenKey = 'user_refresh_token';

  @override
  User? build() {
    return _loadSessionSync();
  }

  // ─── Persistencia ──────────────────────────────────────────

  User? _loadSessionSync() {
    final prefs = ref.read(sharedPreferencesProvider);
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        final user = User.fromJson(jsonDecode(userJson));
        final token = prefs.getString(_tokenKey);
        if (token == null || token.isEmpty) {
          _log('Stale session without token, clearing.');
          prefs.remove(_userKey);
          prefs.remove(_tokenKey);
          prefs.remove(_refreshTokenKey);
          return null;
        }
        final restoredUser = user.copyWith(token: token);
        _log('Session loaded for ${restoredUser.email}');
        return restoredUser;
      } catch (e) {
        _log('Corrupted session, clearing.', isError: true);
        prefs.remove(_userKey);
        prefs.remove(_tokenKey);
        prefs.remove(_refreshTokenKey);
      }
    } else {
      _log('No session found.');
    }
    return null;
  }

  Future<void> _saveSession(User user, {String? refreshToken}) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    if (user.token != null) {
      await prefs.setString(_tokenKey, user.token!);
    }
    if (refreshToken != null) {
      await prefs.setString(_refreshTokenKey, refreshToken);
    }
  }

  Future<void> _clearSession() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  // ─── Token Refresh ─────────────────────────────────────────

  /// Llamado por ApiClient cuando recibe un 401.
  /// Intenta obtener un nuevo access token con el refresh token guardado.
  /// Devuelve el nuevo access token o null si el refresh también expiró.
  Future<String?> tryRefreshToken() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final refreshToken = prefs.getString(_refreshTokenKey);

    if (refreshToken == null || refreshToken.isEmpty) {
      _log('No refresh token stored — cannot refresh.', isError: true);
      return null;
    }

    _log('Attempting token refresh...');
    try {
      final repo = ref.read(authRepositoryProvider);
      final newAccessToken = await repo.refreshAccessToken(refreshToken);

      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        // Actualizar el access token en estado y en prefs
        final updatedUser = state?.copyWith(token: newAccessToken);
        if (updatedUser != null) {
          await prefs.setString(_tokenKey, newAccessToken);
          state = updatedUser;
          _log('Token refreshed successfully.');
        }
        return newAccessToken;
      }
    } catch (e) {
      _log('Token refresh failed: $e', isError: true);
    }

    return null;
  }

  // ─── Acciones públicas ─────────────────────────────────────

  Future<void> login(String email, String password) async {
    _log('Attempting login for $email');
    final repo = ref.read(authRepositoryProvider);
    final tokens = await repo.login(email: email, password: password);
    await _saveSession(tokens.user, refreshToken: tokens.refreshToken);
    state = tokens.user;
    _log('Login successful for ${tokens.user.email}');
  }

  Future<void> register(String email, String password, String fullName) async {
    _log('Attempting registration for $email');
    final repo = ref.read(authRepositoryProvider);
    final tokens = await repo.register(
      email: email,
      password: password,
      fullName: fullName,
    );
    await _saveSession(tokens.user, refreshToken: tokens.refreshToken);
    state = tokens.user;
    _log('Registration successful for ${tokens.user.email}');
  }

  /// Cierra sesión limpiamente.
  void logout() {
    _log('Logout initiated.');
    state = null;
    _clearSession();
  }

  /// Cierra sesión por expiración — la UI puede detectar que vino de un 401.
  void logoutDueToExpiry() {
    _log('Session expired — logging out.', isError: true);
    state = null;
    _clearSession();
  }

  Future<void> updateProfile(String fullName) async {
    final repo = ref.read(userRepositoryProvider);
    final updatedUser = await repo.updateProfile(fullName: fullName);
    final currentToken = state?.token;
    final mergedUser = updatedUser.copyWith(token: currentToken);
    await _saveSession(mergedUser);
    state = mergedUser;
    _log('Profile updated for ${mergedUser.fullName}');
  }

  void updatePhotoUrl(String photoUrl) {
    if (state == null) return;
    final updated = state!.copyWith(photoUrl: photoUrl);
    state = updated;
    _saveSession(updated);
    _log('Photo URL updated');
  }

  void updatePasswordChangedAt(DateTime timestamp) {
    if (state == null) return;
    final updated = state!.copyWith(passwordChangedAt: timestamp);
    state = updated;
    _saveSession(updated);
    _log('Password changed timestamp updated');
  }

  // ─── Logging ───────────────────────────────────────────────

  void _log(String message, {bool isError = false}) {
    if (!kDebugMode) return;
    dev.log(message, name: 'AuthNotifier', level: isError ? 1000 : 0);
  }
}

/// Provider global de Autenticación.
final authProvider = NotifierProvider<AuthNotifier, User?>(
  () => AuthNotifier(),
);
