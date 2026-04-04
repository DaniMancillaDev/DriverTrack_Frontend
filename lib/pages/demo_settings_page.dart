import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/units/domain/unit_formatter.dart';
import '../core/units/presentation/unit_system_provider.dart';
import '../core/units/presentation/widgets/unit_toggle_widget.dart';
import '../features/currency/presentation/widgets/currency_converter_widget.dart';

class DemoSettingsPage extends ConsumerWidget {
  const DemoSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchar el estado global del sistema de unidades para reaccionar en tiempo real
    final unitSystem = ref.watch(unitSystemProvider);

    // Valores simulados de la base de datos (guardados en métrico internamente)
    const double distanceKm = 150.0;
    const double tempCelsius = 25.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración y Unidades')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Componente Reutilizable que maneja el cambio de estado
          const UnitToggleWidget(),

          const Divider(height: 32),

          Text(
            'Ejemplos en tiempo real',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          // 2. Uso de UnitFormatter para formatear la distancia
          Card(
            child: ListTile(
              leading: const Icon(Icons.route),
              title: const Text('Distancia total'),
              trailing: Text(
                UnitFormatter.formatDistance(
                  distanceKm,
                  unitSystem,
                  fractionDigits: 1,
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // 3. Uso de UnitFormatter para formatear la temperatura
          Card(
            child: ListTile(
              leading: const Icon(Icons.thermostat),
              title: const Text('Temperatura de operación'),
              trailing: Text(
                UnitFormatter.formatTemperature(
                  tempCelsius,
                  unitSystem,
                  fractionDigits: 1,
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 4. Widget Real-Time de Conversión de Moneda (USD <-> MXN)
          const CurrencyConverterWidget(),
        ],
      ),
    );
  }
}
