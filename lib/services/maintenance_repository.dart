import '../models/maintenance_model.dart';
import 'api_client.dart';

class MaintenanceRepository {
  final ApiClient _apiClient;

  MaintenanceRepository(this._apiClient);

  /// Fetch maintenance records, optionally filtered by vehicleId, with pagination
  Future<List<Maintenance>> getMaintenanceRecords({
    int? vehicleId,
    int skip = 0,
    int limit = 50,
  }) async {
    final queryParams = {'skip': skip.toString(), 'limit': limit.toString()};
    
    // If vehicleId is provided, use the vehicle-specific endpoint.
    // Otherwise, use the global maintenance endpoint (optimizing N+1).
    final path = vehicleId != null 
        ? '/vehicles/$vehicleId/maintenance' 
        : '/maintenance';

    final uri = Uri(
      path: path,
      queryParameters: queryParams,
    );

    final response = await _apiClient.get(uri.toString());

    if (response is List) {
      return response.map((data) => Maintenance.fromJson(data)).toList();
    }
    return [];
  }

  /// Add a new maintenance record
  Future<Maintenance> addMaintenanceRecord(Map<String, dynamic> data) async {
    final vehicleId = data['vehicle_id'];
    final response = await _apiClient.post(
      '/vehicles/$vehicleId/maintenance',
      data,
    );
    return Maintenance.fromJson(response);
  }

  /// Update an existing maintenance record
  Future<Maintenance> updateMaintenanceRecord(
    int id,
    Map<String, dynamic> data,
  ) async {
    final response = await _apiClient.put('/maintenance/$id', data);
    return Maintenance.fromJson(response);
  }

  /// Delete a maintenance record
  Future<void> deleteMaintenanceRecord(int id) async {
    await _apiClient.delete('/maintenance/$id');
  }
}
