import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import 'app_providers.dart';

/// Notifier that handles the logged-in user state.
/// Null means no active session or still loading.
class AuthNotifier extends Notifier<User?> {
  static const _userKey = 'user_session';

  @override
  User? build() {
    // Intentar cargar la sesión de forma asíncrona
    _loadSession();
    return null; // El estado inicial es nulo mientras se carga
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        state = User.fromJson(jsonDecode(userJson));
        print('DEBUG [AuthNotifier]: Session loaded for ${state?.email}');
      } catch (e) {
        print('DEBUG [AuthNotifier]: Corrupted session found, clearing.');
        await prefs.remove(_userKey);
      }
    } else {
      print('DEBUG [AuthNotifier]: No session found in local storage.');
    }
  }

  Future<void> _saveSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  /// Inicia sesión y muta el estado
  Future<void> login(String email, String password) async {
    print('DEBUG [AuthNotifier]: Attempting login for $email');
    final repo = ref.read(authRepositoryProvider);
    final user = await repo.login(email: email, password: password);
    await _saveSession(user);
    state = user;
    print('DEBUG [AuthNotifier]: Login successful for ${user.email}');
  }

  /// Registra una nueva cuenta y la deja iniciada
  Future<void> register(String email, String password, String fullName) async {
    print('DEBUG [AuthNotifier]: Attempting registration for $email');
    final repo = ref.read(authRepositoryProvider);
    final user = await repo.register(
      email: email,
      password: password,
      fullName: fullName,
    );
    await _saveSession(user);
    state = user;
    print('DEBUG [AuthNotifier]: Registration successful for ${user.email}');
  }

  /// Cierra sesión
  void logout() {
    print('DEBUG [AuthNotifier]: Initiating logout...');
    // Primero mutamos el estado síncronamente para que la UI reaccione ya
    state = null;
    // Luego limpiamos la persistencia en "background"
    _clearSession();
    print('DEBUG [AuthNotifier]: State set to null (logged out).');
  }
}

/// Provider global de Autenticación
final authProvider = NotifierProvider<AuthNotifier, User?>(
  () => AuthNotifier(),
);
