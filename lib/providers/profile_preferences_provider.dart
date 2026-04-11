import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_providers.dart';

/// Modelo de datos inmutable para las preferencias de perfil del usuario.
/// 
/// Centraliza los flags de configuración de la experiencia de usuario, 
/// principalmente enfocados en el sistema de alertas y seguridad.
class ProfilePreferences {
  /// Habilitar/Deshabilitar todas las notificaciones push.
  final bool pushNotifications;
  /// Alertas sobre mantenimientos programados o atrasados.
  final bool serviceReminders;
  /// Notificaciones críticas del sistema o de seguridad.
  final bool criticalAlerts;
  /// Estado de la autenticación de dos factores.
  final bool twoFactorAuth;

  const ProfilePreferences({
    this.pushNotifications = true,
    this.serviceReminders = true,
    this.criticalAlerts = true,
    this.twoFactorAuth = false,
  });

  /// Crea una copia de las preferencias con campos actualizados.
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

/// Claves de almacenamiento centralizadas para evitar errores de tipado en [SharedPreferences].
class _PrefKeys {
  static const pushNotifications = 'pref_push_notifications';
  static const serviceReminders = 'pref_service_reminders';
  static const criticalAlerts = 'pref_critical_alerts';
  static const twoFactorAuth = 'pref_two_factor_auth';
}

/// Notifier que orquesta la carga, persistencia local y sincronización remota de preferencias.
/// 
/// Sigue una estrategia de **Persistencia en Cascada**:
/// 1. Actualiza el disco local ([SharedPreferences]) para feedback instantáneo y uso offline.
/// 2. Actualiza el estado reactivo de Riverpod para refrescar la UI globalmente.
/// 3. Notifica al backend de forma asíncrona mediante el [UserRepository] para sincronizar la cuenta.
class ProfilePreferencesNotifier extends AsyncNotifier<ProfilePreferences> {
  late SharedPreferences _prefs;

  @override
  Future<ProfilePreferences> build() async {
    _prefs = await SharedPreferences.getInstance();
    // Carga inicial asíncrona desde disco al instanciar el provider
    return _load();
  }

  /// Lee todas las preferencias guardadas físicamente.
  ProfilePreferences _load() {
    return ProfilePreferences(
      pushNotifications: _prefs.getBool(_PrefKeys.pushNotifications) ?? true,
      serviceReminders: _prefs.getBool(_PrefKeys.serviceReminders) ?? true,
      criticalAlerts: _prefs.getBool(_PrefKeys.criticalAlerts) ?? true,
      twoFactorAuth: _prefs.getBool(_PrefKeys.twoFactorAuth) ?? false,
    );
  }

  // ─── Mutadores — Cada uno persiste y sincroniza automáticamente ───────────

  /// Establece el permiso global de notificaciones push.
  Future<void> setPushNotifications(bool value) async {
    await _prefs.setBool(_PrefKeys.pushNotifications, value);
    state = AsyncData(state.requireValue.copyWith(pushNotifications: value));
    try {
      await ref.read(userRepositoryProvider).updatePreferences(pushNotifications: value);
    } catch (_) {
      // Los fallos de red aquí se ignoran silenciosamente para no bloquear la UI,
      // confiando en la próxima sincronización global.
    }
  }

  /// Establece si el usuario desea recibir recordatorios de servicios de mantenimiento.
  Future<void> setServiceReminders(bool value) async {
    await _prefs.setBool(_PrefKeys.serviceReminders, value);
    state = AsyncData(state.requireValue.copyWith(serviceReminders: value));
    try {
      await ref.read(userRepositoryProvider).updatePreferences(serviceReminders: value);
    } catch (_) {}
  }

  /// Establece si el usuario desea recibir alertas de severidad crítica.
  Future<void> setCriticalAlerts(bool value) async {
    await _prefs.setBool(_PrefKeys.criticalAlerts, value);
    state = AsyncData(state.requireValue.copyWith(criticalAlerts: value));
    try {
      await ref.read(userRepositoryProvider).updatePreferences(criticalAlerts: value);
    } catch (_) {}
  }

  /// Activa o desactiva de forma puramente local la visibilidad de seguridad 2FA.
  Future<void> setTwoFactorAuth(bool value) async {
    await _prefs.setBool(_PrefKeys.twoFactorAuth, value);
    state = AsyncData(state.requireValue.copyWith(twoFactorAuth: value));
  }
}

/// Provider global de preferencias del perfil.
/// Gestiona el ciclo de vida de la configuración del usuario y su persistencia.
final profilePreferencesProvider =
    AsyncNotifierProvider<ProfilePreferencesNotifier, ProfilePreferences>(
      ProfilePreferencesNotifier.new,
    );
