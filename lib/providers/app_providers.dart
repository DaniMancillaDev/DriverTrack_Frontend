import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vehicle_model.dart';
import '../models/vehicle_type_model.dart';
import '../models/maintenance_model.dart';
import '../services/api_client.dart';
import '../services/vehicle_repository.dart';
import '../services/maintenance_repository.dart';
import '../services/auth_repository.dart';
import '../config/app_config.dart';
import '../features/map/domain/repositories/map_repository.dart';
import '../features/map/data/repositories/map_repository_impl.dart';

// --- Core Providers ---

/// AppConfig provider
final appConfigProvider = Provider<AppConfig>((ref) {
  // Logic to switch between environments could go here
  return AppConfig.dev();
});

/// Global ApiClient provider
final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  return ApiClient(config);
});

/// Global repositories providers
final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return VehicleRepository(apiClient);
});

final maintenanceRepositoryProvider = Provider<MaintenanceRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MaintenanceRepository(apiClient);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepository(apiClient);
});

final mapRepositoryProvider = Provider<MapRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MapRepositoryImpl(apiClient);
});

// --- State Providers ---

// --- State Providers ---

/// Manages the list of vehicles with support for optimistic updates
class VehiclesNotifier extends AsyncNotifier<List<Vehicle>> {
  @override
  Future<List<Vehicle>> build() async {
    final repository = ref.watch(vehicleRepositoryProvider);
    return await repository.getVehicles();
  }

  /// Adds a new vehicle optimistically
  Future<void> addVehicle(Map<String, dynamic> vehicleData) async {
    final repository = ref.read(vehicleRepositoryProvider);
    final previousState = state;

    // Create a temporary vehicle for the optimistic update
    // We use a negative ID to identify it as temporary
    final tempVehicle = Vehicle(
      id: -1,
      userId: 0, // Will be set by backend
      typeId: vehicleData['type_id'],
      brand: vehicleData['brand'],
      model: vehicleData['model'],
      plate: vehicleData['plate'],
      year: vehicleData['year'],
      mileage: vehicleData['mileage'],
      maxMileage: 50000,
      vehicleType: (await ref.read(
        vehicleTypesProvider.future,
      )).firstWhere((t) => t.id == vehicleData['type_id']),
    );

    // Optimistic Update
    state = AsyncData([...state.value ?? [], tempVehicle]);

    try {
      final newVehicle = await repository.createVehicle(vehicleData);

      // Update state with the real vehicle from backend
      state = AsyncData([
        ...(state.value ?? []).where((v) => v.id != -1),
        newVehicle,
      ]);
    } catch (e) {
      // Rollback on error
      state = previousState;
      rethrow;
    }
  }

  /// Deletes a vehicle optimistically
  Future<void> deleteVehicle(int vehicleId) async {
    final repository = ref.read(vehicleRepositoryProvider);
    final previousState = state;

    // Optimistic Update
    state = AsyncData(
      (state.value ?? []).where((v) => v.id != vehicleId).toList(),
    );

    try {
      await repository.deleteVehicle(vehicleId);
    } catch (e) {
      // Rollback on error
      state = previousState;
      rethrow;
    }
  }

  /// Updates an existing vehicle optimistically
  Future<void> updateVehicle(int id, Map<String, dynamic> vehicleData) async {
    final repository = ref.read(vehicleRepositoryProvider);
    final previousState = state;

    if (state.value == null) return;

    // Optimistic Update: Replace the old vehicle with a patched version
    state = AsyncData(
      state.value!.map((v) {
        if (v.id == id) {
          return v.copyWith(
            brand: vehicleData['brand'],
            model: vehicleData['model'],
            year: vehicleData['year'],
            plate: vehicleData['plate'],
            mileage: vehicleData['mileage'],
            isFavorite: vehicleData['is_favorite'],
          );
        }
        return v;
      }).toList(),
    );

    try {
      final updatedVehicle = await repository.updateVehicle(id, vehicleData);

      // Confirm with the actual data from the backend
      state = AsyncData(
        state.value!.map((v) => v.id == id ? updatedVehicle : v).toList(),
      );
    } catch (e) {
      // Rollback on error
      state = previousState;
      rethrow;
    }
  }

  /// Toggles favorite status optimistically
  Future<void> toggleFavorite(int id, bool isFavorite) async {
    await updateVehicle(id, {'is_favorite': isFavorite});
  }

  /// Refreshes the list from the server
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

final vehiclesProvider = AsyncNotifierProvider<VehiclesNotifier, List<Vehicle>>(
  () {
    return VehiclesNotifier();
  },
);

/// Fetches the catalogue of vehicle types
final vehicleTypesProvider = FutureProvider<List<VehicleType>>((ref) async {
  final repository = ref.watch(vehicleRepositoryProvider);
  return await repository.getVehicleTypes();
});

/// Fetches and caches the maintenance records, grouped by an optional vehicle Id
/// We use autoDispose so it re-fetches when navigating back to avoid stale data,
/// or family to fetch specific vehicles.
class MaintenanceParams {
  final int? vehicleId;
  final int skip;
  final int limit;

  const MaintenanceParams({this.vehicleId, this.skip = 0, this.limit = 50});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaintenanceParams &&
          runtimeType == other.runtimeType &&
          vehicleId == other.vehicleId &&
          skip == other.skip &&
          limit == other.limit;

  @override
  int get hashCode => vehicleId.hashCode ^ skip.hashCode ^ limit.hashCode;
}

final maintenanceDocsProvider = FutureProvider.family<List<Maintenance>, MaintenanceParams>((ref, arg) async {
  final repository = ref.watch(maintenanceRepositoryProvider);
  
  if (arg.vehicleId != null) {
    return await repository.getMaintenanceRecords(
      vehicleId: arg.vehicleId,
      skip: arg.skip,
      limit: arg.limit,
    );
  } else {
    final allRecords = await repository.getMaintenanceRecords(
      skip: arg.skip,
      limit: arg.limit,
    );
    allRecords.sort((a, b) => b.date.compareTo(a.date));
    return allRecords;
  }
});

class ActiveFilterNotifier extends Notifier<String> {
  @override
  String build() => 'All Vehicles';

  void updateFilter(String newFilter) {
    state = newFilter;
  }
}

final activeFilterProvider = NotifierProvider<ActiveFilterNotifier, String>(() {
  return ActiveFilterNotifier();
});
