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

// ─── Proveedores de Infraestructura Core ────────────────────────────

/// Provee la configuración global de la aplicación ([AppConfig]).
/// Determina el entorno de ejecución (desarrollo/producción) y las URLs base de la API.
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.dev();
});

/// Provee una instancia configurada de [ApiClient].
/// 
/// Esta instancia actúa como el cliente HTTP centralizado. Implementa lógica de 
/// interceptación para manejar errores 401 (No autorizado):
/// 1. Intenta refrescar el token automáticamente mediante [authProvider].
/// 2. Si el refresco falla, invoca [logoutDueToExpiry] para limpiar la sesión 
///    y redirigir al usuario al inicio de sesión.
final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  return ApiClient(
    config,
    getToken: () => ref.read(authProvider)?.token,
    tryRefreshToken: () => ref.read(authProvider.notifier).tryRefreshToken(),
    onSessionExpired: () => ref.read(authProvider.notifier).logoutDueToExpiry(),
  );
});

// ─── Proveedores de Repositorios Globales ───────────────────────────

/// Punto de acceso a la gestión de datos de vehículos.
final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return VehicleRepository(apiClient);
});

/// Punto de acceso a la gestión de registros de mantenimiento.
final maintenanceRepositoryProvider = Provider<MaintenanceRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MaintenanceRepository(apiClient);
});

/// Punto de acceso a los servicios de autenticación y sesiones.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepository(apiClient);
});

/// Punto de acceso a la gestión de perfiles de usuario.
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserRepository(apiClient);
});

/// Punto de acceso a los servicios de mapas y geolocalización de servicios.
final mapRepositoryProvider = Provider<MapRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MapRepositoryImpl(apiClient);
});

// ─── Notificadores de Estado (State Management) ──────────────────────

/// Gestiona la colección de vehículos del usuario con soporte para **Actualizaciones Optimistas**.
/// 
/// Este notificador permite que la interfaz de usuario responda instantáneamente a cambios 
/// (agregar/borrar) mientras las peticiones al servidor se procesan en segundo plano, 
/// realizando una reversión automática (rollback) si ocurre algún error.
class VehiclesNotifier extends AsyncNotifier<List<Vehicle>> {
  @override
  Future<List<Vehicle>> build() async {
    final repository = ref.watch(vehicleRepositoryProvider);
    return await repository.getVehicles();
  }

  /// Registra un nuevo vehículo. Utiliza actualización optimista insertando 
  /// un elemento temporal con un identificador negativo.
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

    // Actualización Optimista: El vehículo aparece de inmediato en la lista.
    state = AsyncData([...state.value ?? [], tempVehicle]);

    try {
      final newVehicle = await repository.createVehicle(vehicleData);

      // Sincronizar con el dato real retornado por el servidor.
      state = AsyncData([
        ...(state.value ?? []).where((v) => v.id != -1),
        newVehicle,
      ]);
    } catch (e) {
      // Revertir estado si el servidor falla.
      state = previousState;
      rethrow;
    }
  }

  /// Elimina un vehículo de forma permanente.
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

  /// Límite máximo de vehículos favoritos por usuario.
  static const int maxFavorites = 3;

  /// Alterna el estado de "favorito" validando el límite localmente.
  Future<void> toggleFavorite(int id, bool isFavorite) async {
    if (isFavorite) {
      final currentFavorites = state.value?.where((v) => v.isFavorite).length ?? 0;
      if (currentFavorites >= maxFavorites) {
        throw FavoriteLimitException(maxFavorites);
      }
    }
    await updateVehicle(id, {'is_favorite': isFavorite});
  }

  /// Actualiza un vehículo de forma puramente local en el estado reactivo.
  void updateVehicleLocally(Vehicle updatedVehicle) {
    if (state.value == null) return;
    state = AsyncData(
      state.value!.map((v) => v.id == updatedVehicle.id ? updatedVehicle : v).toList(),
    );
  }

  /// Fuerza el refresco completo de la flota desde el servidor.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

/// Punto de acceso al servicio de carga de fotografías de vehículos.
final vehiclePhotoUploadProvider = Provider<VehiclePhotoUploadService>((ref) {
  final repo = ref.watch(vehicleRepositoryProvider);
  return VehiclePhotoUploadService(repo);
});

/// Proveedor global reactivo para la lista de vehículos del usuario.
final vehiclesProvider = AsyncNotifierProvider<VehiclesNotifier, List<Vehicle>>(
  () {
    return VehiclesNotifier();
  },
);

/// Obtiene el catálogo de tipos de vehículos disponibles desde el servidor.
final vehicleTypesProvider = FutureProvider<List<VehicleType>>((ref) async {
  final repository = ref.watch(vehicleRepositoryProvider);
  return await repository.getVehicleTypes();
});

// ─── Gestión de Registros de Mantenimiento ───────────────────────────

/// Parámetros para la consulta filtrada de registros de mantenimiento.
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
/// Utiliza [family] para permitir múltiples instancias del historial 
/// (ej. uno global para el historial y uno específico para el detalle de un coche).
class MaintenanceDocsNotifier extends AsyncNotifier<List<Maintenance>> {
  final MaintenanceParams arg;

  MaintenanceDocsNotifier(this.arg);

  @override
  Future<List<Maintenance>> build() async {
    // Si el ID es negativo (vehículo temporal optimista), no consultamos al servidor
    if (arg.vehicleId != null && arg.vehicleId! < 0) return [];

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

  /// Sincroniza o inserta un registro directamente en la lista local.
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

  /// Elimina un registro del estado local de forma inmediata.
  void deleteLocal(int id) {
    if (state.hasValue && state.value != null) {
      state = AsyncData(state.value!.where((m) => m.id != id).toList());
    }
  }
}

/// Proveedor parametrizado del historial de mantenimiento.
final maintenanceDocsProvider =
    AsyncNotifierProvider.family<MaintenanceDocsNotifier, List<Maintenance>, MaintenanceParams>(
  (arg) => MaintenanceDocsNotifier(arg),
);

// ─── Control de Filtros de Visualización ───────────────────────────

/// Gestiona la categoría de filtro seleccionada en la galería de vehículos.
class ActiveFilterNotifier extends Notifier<String> {
  @override
  String build() => 'Todos';

  /// Actualiza el filtro activo (ej. 'Autos', 'Motos', 'Todos').
  void updateFilter(String newFilter) {
    state = newFilter;
  }
}

/// Proveedor global para el filtro de navegación superior.
final activeFilterProvider = NotifierProvider<ActiveFilterNotifier, String>(() {
  return ActiveFilterNotifier();
});

/// Excepción lanzada cuando se intenta exceder el límite de vehículos favoritos.
class FavoriteLimitException implements Exception {
  /// Límite máximo permitido.
  final int limit;
  const FavoriteLimitException(this.limit);

  @override
  String toString() => 'FavoriteLimitException: máximo $limit favoritos permitidos.';
}
