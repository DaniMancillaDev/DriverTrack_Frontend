import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vehicle_model.dart';
import '../models/vehicle_type_model.dart';
import '../models/maintenance_model.dart';
import '../core/network/api_client.dart';
import '../services/vehicle_repository.dart';
import '../services/maintenance_repository.dart';
import '../features/auth/data/auth_repository.dart';
import '../services/user_repository.dart';
import '../config/app_config.dart';
import '../features/map/domain/repositories/map_repository.dart';
import '../features/map/data/repositories/map_repository_impl.dart';
import '../providers/auth_provider.dart';
import '../services/vehicle_photo_upload_service.dart';

// --- Core Providers ---

/// Provee la configuración global de la aplicación ([AppConfig]).
/// Determina el entorno de ejecución (dev/prod) y las URLs base de la API.
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.dev();
});

/// Provee una instancia configurada de [ApiClient].
/// 
/// Esta instancia actúa como el cliente HTTP centralizado. Implementa lógica de 
/// interceptación para manejar errores 401 (Unauthorized):
/// 1. Intenta refrescar el token automáticamente mediante [authProvider].
/// 2. Si el refresco falla, invoca [logoutDueToExpiry] para limpiar la sesión 
///    y redirigir al usuario al login.
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

/// Gestiona la colección de vehículos del usuario con soporte para **Actualizaciones Optimistas**.
/// 
/// Este notifier permite que la UI responda instantáneamente a cambios (agregar/borrar)
/// mientras las peticiones al servidor se procesan en segundo plano, realizando un rollback 
/// automático si ocurre algún error.
class VehiclesNotifier extends AsyncNotifier<List<Vehicle>> {
  @override
  Future<List<Vehicle>> build() async {
    final repository = ref.watch(vehicleRepositoryProvider);
    return await repository.getVehicles();
  }

  /// Registra un nuevo vehículo. Utiliza actualización optimista insertando 
  /// un elemento temporal con ID negativo.
  Future<void> addVehicle(Map<String, dynamic> vehicleData) async {
    final repository = ref.read(vehicleRepositoryProvider);
    final previousState = state;

    final tempVehicle = Vehicle(
      id: -1,
      userId: 0,
      typeId: vehicleData['type_id'],
      brand: vehicleData['brand'],
      model: vehicleData['model'],
      plate: vehicleData['plate'],
      year: vehicleData['year'],
      mileage: vehicleData['mileage'],
      maxMileage: vehicleData['max_mileage'] ?? 50000,
      vehicleType: (await ref.read(
        vehicleTypesProvider.future,
      )).firstWhere((t) => t.id == vehicleData['type_id']),
    );

    // Actualización Optimista: El vehículo aparece de inmediato en la lista
    state = AsyncData([...state.value ?? [], tempVehicle]);

    try {
      final newVehicle = await repository.createVehicle(vehicleData);

      // Sincronizar con el dato real del backend
      state = AsyncData([
        ...(state.value ?? []).where((v) => v.id != -1),
        newVehicle,
      ]);
    } catch (e) {
      // Revertir estado si el servidor falla
      state = previousState;
      rethrow;
    }
  }

  /// Elimina un vehículo. Oculta el elemento de la lista antes de recibir confirmación del servidor.
  Future<void> deleteVehicle(int vehicleId) async {
    final repository = ref.read(vehicleRepositoryProvider);
    final previousState = state;

    state = AsyncData(
      (state.value ?? []).where((v) => v.id != vehicleId).toList(),
    );

    try {
      await repository.deleteVehicle(vehicleId);
    } catch (e) {
      state = previousState;
      rethrow;
    }
  }

  /// Actualiza los datos de un vehículo optimísticamente.
  Future<void> updateVehicle(int id, Map<String, dynamic> vehicleData) async {
    final repository = ref.read(vehicleRepositoryProvider);
    final previousState = state;

    if (state.value == null) return;

    state = AsyncData(
      state.value!.map((v) {
        if (v.id == id) {
          return v.copyWith(
            brand: vehicleData['brand'],
            model: vehicleData['model'],
            year: vehicleData['year'],
            plate: vehicleData['plate'],
            mileage: vehicleData['mileage'],
            maxMileage: vehicleData['max_mileage'],
            isFavorite: vehicleData['is_favorite'],
          );
        }
        return v;
      }).toList(),
    );

    try {
      final updatedVehicle = await repository.updateVehicle(id, vehicleData);
      state = AsyncData(
        state.value!.map((v) => v.id == id ? updatedVehicle : v).toList(),
      );
    } catch (e) {
      state = previousState;
      rethrow;
    }
  }

  /// Limite de favoritos por usuario.
  static const int maxFavorites = 3;

  /// Alterna el estado de favorito de un vehículo.
  /// Valida el límite de favoritos localmente antes de proceder.
  Future<void> toggleFavorite(int id, bool isFavorite) async {
    if (isFavorite) {
      final currentFavorites = state.value?.where((v) => v.isFavorite).length ?? 0;
      if (currentFavorites >= maxFavorites) {
        throw FavoriteLimitException(maxFavorites);
      }
    }
    await updateVehicle(id, {'is_favorite': isFavorite});
  }

  /// Actualiza un vehículo de forma puramente local en el estado Reactivo.
  void updateVehicleLocally(Vehicle updatedVehicle) {
    if (state.value == null) return;
    state = AsyncData(
      state.value!.map((v) => v.id == updatedVehicle.id ? updatedVehicle : v).toList(),
    );
  }

  /// Fuerza una recarga completa de la lista desde el servidor.
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

/// Gestiona el historial de registros de mantenimiento con soporte para filtrado por vehículo.
/// 
/// Utiliza [AsyncNotifierProvider.family] para permitir múltiples instancias del 
/// historial (ej: uno general y otro específico para un coche en particular).
class MaintenanceDocsNotifier extends AsyncNotifier<List<Maintenance>> {
  final MaintenanceParams arg;

  MaintenanceDocsNotifier(this.arg);

  @override
  Future<List<Maintenance>> build() async {
    final repository = ref.watch(maintenanceRepositoryProvider);
    List<Maintenance> docs;
    if (arg.vehicleId != null) {
      // Carga registros específicos de un vehículo.
      docs = await repository.getMaintenanceRecords(
        vehicleId: arg.vehicleId,
        skip: arg.skip,
        limit: arg.limit,
      );
    } else {
      // Carga el historial global y lo ordena cronológicamente (más reciente primero).
      docs = await repository.getMaintenanceRecords(
        skip: arg.skip,
        limit: arg.limit,
      );
      docs.sort((a, b) => b.date.compareTo(a.date));
    }
    return docs;
  }

  /// Inyecta o actualiza un registro directamente en la lista local sin recargar de red.
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

  /// Elimina un registro del estado local.
  void deleteLocal(int id) {
    if (state.hasValue && state.value != null) {
      state = AsyncData(state.value!.where((m) => m.id != id).toList());
    }
  }
}

/// Provider que expone el historial de mantenimiento parametrizado.
final maintenanceDocsProvider =
    AsyncNotifierProvider.family<MaintenanceDocsNotifier, List<Maintenance>, MaintenanceParams>(
  (arg) => MaintenanceDocsNotifier(arg),
);

/// Notifier para gestionar el filtro de visualización activo en la galería de vehículos.
class ActiveFilterNotifier extends Notifier<String> {
  @override
  String build() => 'All Vehicles';

  /// Actualiza la categoría de filtro seleccionada.
  void updateFilter(String newFilter) {
    state = newFilter;
  }
}

/// Provider global para el filtro de navegación.
final activeFilterProvider = NotifierProvider<ActiveFilterNotifier, String>(() {
  return ActiveFilterNotifier();
});

/// Excepción lanzada cuando el usuario intenta exceder el tope de vehículos favoritos.
class FavoriteLimitException implements Exception {
  /// Límite máximo configurado.
  final int limit;
  const FavoriteLimitException(this.limit);

  @override
  String toString() => 'FavoriteLimitException: máximo $limit favoritos permitidos.';
}
