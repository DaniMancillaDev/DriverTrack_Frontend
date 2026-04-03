import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/unit_system.dart';
import '../data/preferences_service.dart';

/// Provider que debe sobrescribirse en el main.dart con el valor real
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Se debe sobreescribir sharedPreferencesProvider en el runApp()');
});

/// Provider para inyectar el servicio de preferencias
final unitPreferencesServiceProvider = Provider<PreferencesService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PreferencesService(prefs);
});

/// Notifier global que expone el UnitSystem activo de forma síncrona en la UI
final unitSystemProvider = NotifierProvider<UnitSystemNotifier, UnitSystem>(() {
  return UnitSystemNotifier();
});

class UnitSystemNotifier extends Notifier<UnitSystem> {
  late final PreferencesService _preferencesService;

  @override
  UnitSystem build() {
    _preferencesService = ref.watch(unitPreferencesServiceProvider);
    return _preferencesService.getUnitSystem(); 
  }

  /// Cambia el sistema a uno en específico
  Future<void> setSystem(UnitSystem system) async {
    state = system; // Optimistic update para UI súper rápida
    await _preferencesService.saveUnitSystem(system);
  }

  /// Alterna automáticamente el sistema actual
  Future<void> toggleSystem() async {
    final newSystem = state == UnitSystem.metric ? UnitSystem.imperial : UnitSystem.metric;
    await setSystem(newSystem);
  }
}
