import 'package:shared_preferences/shared_preferences.dart';
import '../domain/unit_system.dart';

/// Servicio encargado de la persistencia del sistema de unidades en SharedPreferences.
/// 
/// Actúa como la capa de datos para las preferencias de visualización del usuario,
/// permitiendo que la elección del sistema métrico o imperial se mantenga 
/// entre sesiones de la aplicación.
class PreferencesService {
  static const String _unitSystemKey = 'unit_system';
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  /// Obtiene el [UnitSystem] guardado en el almacenamiento local.
  /// 
  /// Si no hay un valor guardado, retorna [UnitSystem.metric] por defecto.
  UnitSystem getUnitSystem() {
    final value = _prefs.getString(_unitSystemKey);
    if (value != null) {
      return UnitSystem.values.firstWhere(
        (e) => e.name == value,
        orElse: () => UnitSystem.metric,
      );
    }
    return UnitSystem.metric;
  }

  /// Guarda de forma persistente la preferencia del [UnitSystem] del usuario.
  Future<void> saveUnitSystem(UnitSystem system) async {
    await _prefs.setString(_unitSystemKey, system.name);
  }
}
