import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_providers.dart';
// ─────────────────────────────────────────────────────────────
// Model — Immutable state for all user profile preferences
// ─────────────────────────────────────────────────────────────

class ProfilePreferences {
  final bool pushNotifications;
  final bool serviceReminders;
  final bool criticalAlerts;
  final bool twoFactorAuth;

  const ProfilePreferences({
    this.pushNotifications = true,
    this.serviceReminders = true,
    this.criticalAlerts = true,
    this.twoFactorAuth = false,
  });

  ProfilePreferences copyWith({
    bool? pushNotifications,
    bool? serviceReminders,
    bool? criticalAlerts,
    bool? twoFactorAuth,
  }) {
    return ProfilePreferences(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      serviceReminders: serviceReminders ?? this.serviceReminders,
      criticalAlerts: criticalAlerts ?? this.criticalAlerts,
      twoFactorAuth: twoFactorAuth ?? this.twoFactorAuth,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Keys — Centralizadas para evitar typos
// ─────────────────────────────────────────────────────────────

class _PrefKeys {
  static const pushNotifications = 'pref_push_notifications';
  static const serviceReminders = 'pref_service_reminders';
  static const criticalAlerts = 'pref_critical_alerts';
  static const twoFactorAuth = 'pref_two_factor_auth';
}

// ─────────────────────────────────────────────────────────────
// Notifier — Carga desde SharedPreferences y persiste cambios
// ─────────────────────────────────────────────────────────────

class ProfilePreferencesNotifier extends AsyncNotifier<ProfilePreferences> {
  late SharedPreferences _prefs;

  @override
  Future<ProfilePreferences> build() async {
    _prefs = await SharedPreferences.getInstance();
    return _load();
  }

  /// Lee todas las preferencias del disco.
  ProfilePreferences _load() {
    return ProfilePreferences(
      pushNotifications: _prefs.getBool(_PrefKeys.pushNotifications) ?? true,
      serviceReminders: _prefs.getBool(_PrefKeys.serviceReminders) ?? true,
      criticalAlerts: _prefs.getBool(_PrefKeys.criticalAlerts) ?? true,
      twoFactorAuth: _prefs.getBool(_PrefKeys.twoFactorAuth) ?? false,
    );
  }

  // ─── Mutators — cada uno persiste inmediatamente ───────────

  Future<void> setPushNotifications(bool value) async {
    await _prefs.setBool(_PrefKeys.pushNotifications, value);
    state = AsyncData(state.requireValue.copyWith(pushNotifications: value));
    try {
      await ref.read(userRepositoryProvider).updatePreferences(pushNotifications: value);
    } catch (_) {}
  }

  Future<void> setServiceReminders(bool value) async {
    await _prefs.setBool(_PrefKeys.serviceReminders, value);
    state = AsyncData(state.requireValue.copyWith(serviceReminders: value));
    try {
      await ref.read(userRepositoryProvider).updatePreferences(serviceReminders: value);
    } catch (_) {}
  }

  Future<void> setCriticalAlerts(bool value) async {
    await _prefs.setBool(_PrefKeys.criticalAlerts, value);
    state = AsyncData(state.requireValue.copyWith(criticalAlerts: value));
    try {
      await ref.read(userRepositoryProvider).updatePreferences(criticalAlerts: value);
    } catch (_) {}
  }

  Future<void> setTwoFactorAuth(bool value) async {
    await _prefs.setBool(_PrefKeys.twoFactorAuth, value);
    state = AsyncData(state.requireValue.copyWith(twoFactorAuth: value));
  }
}

/// Provider global de preferencias del perfil.
/// Usa AsyncNotifier para manejar la carga inicial desde disco.
final profilePreferencesProvider =
    AsyncNotifierProvider<ProfilePreferencesNotifier, ProfilePreferences>(
      ProfilePreferencesNotifier.new,
    );
