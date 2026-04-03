import 'distance_unit.dart';
import 'temperature_unit.dart';

enum UnitSystem {
  metric,
  imperial;

  DistanceUnit get distanceUnit {
    switch (this) {
      case UnitSystem.metric:
        return DistanceUnit.kilometers;
      case UnitSystem.imperial:
        return DistanceUnit.miles;
    }
  }

  TemperatureUnit get temperatureUnit {
    switch (this) {
      case UnitSystem.metric:
        return TemperatureUnit.celsius;
      case UnitSystem.imperial:
        return TemperatureUnit.fahrenheit;
    }
  }
}
