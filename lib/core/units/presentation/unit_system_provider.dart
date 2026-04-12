import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/unit_system.dart';
import '../data/preferences_service.dart';

/// Proveedores centrales para la inyección de dependencias de unidades.
/// 
/// Gestiona el ciclo de vida de [SharedPreferences] y del servicio de preferencias,
/// permitiendo una arquitectura desacoplada y fácilmente testeable.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'Se debe sobreescribir sharedPreferencesProvider en el runApp() mediante el método ProviderScope.overrides',
  );
});

/// Orquestador del acceso a datos persistentes de configuración física.
final unitPreferencesServiceProvider = Provider<PreferencesService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PreferencesService(prefs);
});

/// Notificador global que orquesta el sistema de medición activo.
/// 
/// Garantiza que el cambio de unidades (ej. KM a Mi) se propague de forma reactiva
/// a toda la aplicación de manera instantánea.
final unitSystemProvider = NotifierProvider<UnitSystemNotifier, UnitSystem>(() {
  return UnitSystemNotifier();
});

/// Coordinador reactivo del estado del sistema de unidades.
/// 
/// Sus responsabilidades incluyen:
/// * **Inicialización**: Sincroniza el estado inicial con las preferencias guardadas.
/// * **Actualización Proactiva**: Modifica el estado de la UI antes de persistir (optimista).
/// * **Persistencia**: Delegar en el servicio de datos la grabación de cambios.
class UnitSystemNotifier extends Notifier<UnitSystem> {
  late final PreferencesService _preferencesService;

  @override
  UnitSystem build() {
    _preferencesService = ref.watch(unitPreferencesServiceProvider);
    return _preferencesService.getUnitSystem();
  }

  /// Establece un sistema de medida específico de forma persistente.
  /// 
  /// Realiza una actualización inmediata del estado para asegurar fluidez en la UI.
  Future<void> setSystem(UnitSystem system) async {
    state = system;
    await _preferencesService.saveUnitSystem(system);
  }

  /// Alterna cíclicamente entre el sistema Métrico e Imperial.
  Future<void> toggleSystem() async {
    final newSystem = state == UnitSystem.metric
        ? UnitSystem.imperial
        : UnitSystem.metric;
    await setSystem(newSystem);
  }
}
