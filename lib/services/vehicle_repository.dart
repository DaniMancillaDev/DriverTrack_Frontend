import '../models/vehicle_model.dart';
import '../models/vehicle_type_model.dart';
import 'api_client.dart';

class VehicleRepository {
  final ApiClient _apiClient;

  VehicleRepository(this._apiClient);

  /// Fetch the catalogue of vehicle types
  Future<List<VehicleType>> getVehicleTypes() async {
    final response = await _apiClient.get('/vehicles/types');
    if (response is List) {
      return response.map((data) => VehicleType.fromJson(data)).toList();
    }
    return [];
  }

  /// Fetch all vehicles from the API
  Future<List<Vehicle>> getVehicles() async {
    final response = await _apiClient.get('/vehicles/');
    if (response is List) {
      return response.map((data) => Vehicle.fromJson(data)).toList();
    }
    return [];
  }

  /// Create a new vehicle
  Future<Vehicle> createVehicle(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/vehicles/', data);
    return Vehicle.fromJson(response);
  }

  /// Update an existing vehicle
  Future<Vehicle> updateVehicle(int id, Map<String, dynamic> data) async {
    final response = await _apiClient.put('/vehicles/$id', data);
    return Vehicle.fromJson(response);
  }

  /// Delete a vehicle and its maintenance records
  Future<void> deleteVehicle(int id) async {
    await _apiClient.delete('/vehicles/$id');
  }

  /// Pide la URL pre-firmada para subir foto del vehículo
  Future<Map<String, dynamic>> getVehiclePhotoPresignedUrl(int id) async {
    final response = await _apiClient.post('/vehicles/$id/photo/presigned-url', {});
    return response as Map<String, dynamic>;
  }

  /// Confirma la subida y guarda la URL en el vehículo
  Future<Vehicle> confirmVehiclePhotoUpload(int id, String photoUrl) async {
    final response = await _apiClient.put(
      '/vehicles/$id/photo/confirm?photo_url=${Uri.encodeComponent(photoUrl)}',
      {},
    );
    // Podría venir un wrapper o el objeto directo
    final vehicleData = response['vehicle'] ?? response;
    return Vehicle.fromJson(vehicleData);
  }
}
