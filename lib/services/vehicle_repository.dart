import '../models/vehicle_model.dart';
import '../models/vehicle_type_model.dart';
import '../core/network/api_client.dart';

/// Repositorio encargado de la gestión de la flota de vehículos.
/// 
/// Actúa como mediador entre la capa de presentación y el backend, 
/// facilitando operaciones de catálogo, CRUD de vehículos y procesos 
/// de carga de contenido multimedia (fotos).
class VehicleRepository {
  final ApiClient _apiClient;

  VehicleRepository(this._apiClient);

  /// Recupera el catálogo maestro de tipos de vehículos soportados.
  Future<List<VehicleType>> getVehicleTypes() async {
    final response = await _apiClient.get('/vehicles/types');
    if (response is List) {
      return response.map((data) => VehicleType.fromJson(data)).toList();
    }
    return [];
  }

  /// Obtiene la lista completa de vehículos asociados al usuario actual.
  Future<List<Vehicle>> getVehicles() async {
    final response = await _apiClient.get('/vehicles/');
    if (response is List) {
      return response.map((data) => Vehicle.fromJson(data)).toList();
    }
    return [];
  }

  /// Registra un nuevo vehículo en el sistema.
  Future<Vehicle> createVehicle(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/vehicles/', data);
    return Vehicle.fromJson(response);
  }

  /// Actualiza los datos parciales o totales de un vehículo existente.
  Future<Vehicle> updateVehicle(int id, Map<String, dynamic> data) async {
    final response = await _apiClient.put('/vehicles/$id', data);
    return Vehicle.fromJson(response);
  }

  /// Elimina un vehículo y todos sus registros históricos asociados (mantenimiento).
  Future<void> deleteVehicle(int id) async {
    await _apiClient.delete('/vehicles/$id');
  }

  /// Solicita una URL pre-firmada al servidor para subir una foto de forma segura.
  /// 
  /// Este flujo delega la carga directa al almacenamiento (ej. S3/MinIO) 
  /// evitando saturar la memoria del servidor de aplicaciones.
  Future<Map<String, dynamic>> getVehiclePhotoPresignedUrl(int id) async {
    final response = await _apiClient.post('/vehicles/$id/photo/presigned-url', {});
    return response as Map<String, dynamic>;
  }

  /// Confirma la subida exitosa de la imagen y vincula la URL final al vehículo.
  Future<Vehicle> confirmVehiclePhotoUpload(int id, String objectKey) async {
    final response = await _apiClient.put(
      '/vehicles/$id/photo/confirm',
      {'object_key': objectKey},
    );
    // El backend puede retornar el vehículo directamente o envuelto en un mapa
    final vehicleData = response['vehicle'] ?? response;
    return Vehicle.fromJson(vehicleData);
  }
}
