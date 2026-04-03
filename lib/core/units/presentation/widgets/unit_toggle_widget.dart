import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../unit_system_provider.dart';
import '../../domain/unit_system.dart';

/// Un widget reutilizable que permite alternar entre sistema Métrico e Imperial.
class UnitToggleWidget extends ConsumerWidget {
  const UnitToggleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSystem = ref.watch(unitSystemProvider);

    return SwitchListTile(
      title: const Text('Sistema de unidades'),
      subtitle: Text(
        currentSystem == UnitSystem.metric 
            ? 'Métrico (km, °C)' 
            : 'Imperial (mi, °F)',
      ),
      value: currentSystem == UnitSystem.imperial,
      onChanged: (bool isImperial) {
        ref.read(unitSystemProvider.notifier).setSystem(
              isImperial ? UnitSystem.imperial : UnitSystem.metric,
            );
      },
    );
  }
}
