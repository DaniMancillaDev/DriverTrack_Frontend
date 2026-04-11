import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vehicle_model.dart';
import '../models/vehicle_type_model.dart';
import '../models/maintenance_model.dart';
import '../services/api_client.dart';
import '../services/vehicle_repository.dart';
import '../services/maintenance_repository.dart';
import '../services/auth_repository.dart';
import '../services/user_repository.dart';
import '../config/app_config.dart';
import '../features/map/domain/repositories/map_repository.dart';
import '../features/map/data/repositories/map_repository_impl.dart';
import '../providers/auth_provider.dart';
import '../services/vehicle_photo_upload_service.dart';

// --- Core Providers ---

/// AppConfig provider
final appConfigProvider = Provider<AppConfig>((ref) {
  // Logic to switch between environments could go here
  return AppConfig.dev();
});

/// Global ApiClient provider
/// En 401: primero intenta refrescar el access token automáticamente.
/// Si el refresh también falla: hace logoutDueToExpiry() para distinguirlo de
/// un error normal y que la UI muestre el mensaje adecuado.
final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  return ApiClient(
    config,
    getToken: () => ref.read(authProvider)?.token,
    tryRefreshToken: () => ref.read(authProvider.notifier).tryRefreshToken(),
    onSessionExpired: () => ref.read(authProvider.notifier).logoutDueToExpiry(),
  );
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

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserRepository(apiClient);
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

  /// Toggles favorite status optimistically.
  /// Límite: máximo [maxFavorites] vehículos marcados como favoritos.
  /// Si se excede, lanza [FavoriteLimitException] sin tocar el backend.
  static const int maxFavorites = 3;

  Future<void> toggleFavorite(int id, bool isFavorite) async {
    if (isFavorite) {
      // Solo verificar al MARCAR (no al desmarcar)
      final currentFavorites = state.value?.where((v) => v.isFavorite).length ?? 0;
      if (currentFavorites >= maxFavorites) {
        throw FavoriteLimitException(maxFavorites);
      }
    }
    await updateVehicle(id, {'is_favorite': isFavorite});
  }


  /// Actualiza un vehículo directo en el estado local (ej. tras subir foto)
  void updateVehicleLocally(Vehicle updatedVehicle) {
    if (state.value == null) return;
    state = AsyncData(
      state.value!.map((v) => v.id == updatedVehicle.id ? updatedVehicle : v).toList(),
    );
  }

  /// Refreshes the list from the server
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

final vehiclePhotoUploadProvider = Provider<VehiclePhotoUploadService>((ref) {
  final repo = ref.watch(vehicleRepositoryProvider);
  return VehiclePhotoUploadService(repo);
});

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

class MaintenanceDocsNotifier extends AsyncNotifier<List<Maintenance>> {
  final MaintenanceParams arg;

  MaintenanceDocsNotifier(this.arg);

  @override
  Future<List<Maintenance>> build() async {
    final repository = ref.watch(maintenanceRepositoryProvider);
    List<Maintenance> docs;
    if (arg.vehicleId != null) {
      docs = await repository.getMaintenanceRecords(
        vehicleId: arg.vehicleId,
        skip: arg.skip,
        limit: arg.limit,
      );
    } else {
      docs = await repository.getMaintenanceRecords(
        skip: arg.skip,
        limit: arg.limit,
      );
      docs.sort((a, b) => b.date.compareTo(a.date));
    }
    return docs;
  }

  void updateLocal(Maintenance record) {
    if (state.hasValue && state.value != null) {
      final list = [...state.value!];
      final idx = list.indexWhere((m) => m.id == record.id);
      if (idx != -1) {
        list[idx] = record;
        state = AsyncData(list);
      } else {
        list.insert(0, record);
        state = AsyncData(list);
      }
    }
  }

  void deleteLocal(int id) {
    if (state.hasValue && state.value != null) {
      state = AsyncData(state.value!.where((m) => m.id != id).toList());
    }
  }
}

final maintenanceDocsProvider =
    AsyncNotifierProvider.family<MaintenanceDocsNotifier, List<Maintenance>, MaintenanceParams>(
  (arg) => MaintenanceDocsNotifier(arg),
);

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

/// Lanzada cuando el usuario intenta agregar un vehículo a favoritos
/// pero ya alcanzó el límite permitido.
class FavoriteLimitException implements Exception {
  final int limit;
  const FavoriteLimitException(this.limit);

  @override
  String toString() => 'FavoriteLimitException: máximo $limit favoritos permitidos.';
}
