import 'package:shared_preferences/shared_preferences.dart';
import '../domain/unit_system.dart';

/// Servicio encargado de la persistencia del sistema de unidades en SharedPreferences.
class PreferencesService {
  static const String _unitSystemKey = 'unit_system';
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  /// Obtiene el UnitSystem guardado; de lo contrario por defecto Metric.
  UnitSystem getUnitSystem() {
    final value = _prefs.getString(_unitSystemKey);
    if (value != null) {
      return UnitSystem.values.firstWhere(
        (e) => e.name == value,
        orElse: () => UnitSystem.metric,
      );
    }
    return UnitSystem.metric; // Default a sistema métrico
  }

  /// Guarda el UnitSystem en SharedPreferences.
  Future<void> saveUnitSystem(UnitSystem system) async {
    await _prefs.setString(_unitSystemKey, system.name);
  }
}
