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

  @override
  User? build() {
    return _loadSessionSync();
  }

  // ─── Persistencia ─────────────────────────────────────────

  User? _loadSessionSync() {
    final prefs = ref.read(sharedPreferencesProvider);
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        final user = User.fromJson(jsonDecode(userJson));
        // Restaurar token
        final token = prefs.getString(_tokenKey);
        final restoredUser = token != null ? user.copyWith(token: token) : user;
        _log('Session loaded for ${restoredUser.email}');
        return restoredUser;
      } catch (e) {
        _log('Corrupted session, clearing.', isError: true);
        prefs.remove(_userKey);
        prefs.remove(_tokenKey);
      }
    } else {
      _log('No session found.');
    }
    return null;
  }

  Future<void> _saveSession(User user) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    if (user.token != null) {
      await prefs.setString(_tokenKey, user.token!);
    }
  }

  Future<void> _clearSession() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }

  // ─── Acciones públicas ────────────────────────────────────

  /// Inicia sesión y persiste la sesión.
  Future<void> login(String email, String password) async {
    _log('Attempting login for $email');
    final repo = ref.read(authRepositoryProvider);
    final user = await repo.login(email: email, password: password);
    await _saveSession(user);
    state = user;
    _log('Login successful for ${user.email}');
  }

  /// Registra una cuenta nueva y la deja activa.
  Future<void> register(String email, String password, String fullName) async {
    _log('Attempting registration for $email');
    final repo = ref.read(authRepositoryProvider);
    final user = await repo.register(
      email: email,
      password: password,
      fullName: fullName,
    );
    await _saveSession(user);
    state = user;
    _log('Registration successful for ${user.email}');
  }

  /// Cierra sesión — muta el estado síncronamente para que la UI reaccione.
  void logout() {
    _log('Logout initiated.');
    state = null;
    _clearSession(); // Fire-and-forget en background
  }

  // ─── Logging condicional ──────────────────────────────────

  void _log(String message, {bool isError = false}) {
    if (!kDebugMode) return;
    dev.log(message, name: 'AuthNotifier', level: isError ? 1000 : 0);
  }
}

/// Provider global de Autenticación.
final authProvider = NotifierProvider<AuthNotifier, User?>(
  () => AuthNotifier(),
);
