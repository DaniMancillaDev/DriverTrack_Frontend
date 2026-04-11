import '../models/maintenance_model.dart';
import '../core/network/api_client.dart';

/// Repositorio para la gestión del historial de mantenimiento preventivo y correctivo.
/// 
/// Permite el seguimiento detallado de intervenciones mecánicas, costos 
/// y kilometraje, vinculando cada registro con un vehículo de la flota.
class MaintenanceRepository {
  final ApiClient _apiClient;

  MaintenanceRepository(this._apiClient);

  /// Recupera registros de mantenimiento con soporte para paginación y filtrado.
  /// 
  /// Si se proporciona [vehicleId], se obtienen los registros exclusivos de ese 
  /// vehículo. Si no, se obtienen todos los registros del usuario (útil para 
  /// dashboards globales).
  Future<List<Maintenance>> getMaintenanceRecords({
    int? vehicleId,
    int skip = 0,
    int limit = 50,
  }) async {
    final queryParams = {'skip': skip.toString(), 'limit': limit.toString()};

    final path = vehicleId != null
        ? '/vehicles/$vehicleId/maintenance'
        : '/maintenance';

    final uri = Uri(path: path, queryParameters: queryParams);

    final response = await _apiClient.get(uri.toString());

    if (response is List) {
      return response.map((data) => Maintenance.fromJson(data)).toList();
    }
    return [];
  }

  /// Registra una nueva intervención de mantenimiento para un vehículo.
  Future<Maintenance> addMaintenanceRecord(Map<String, dynamic> data) async {
    final vehicleId = data['vehicle_id'];
    final response = await _apiClient.post(
      '/vehicles/$vehicleId/maintenance',
      data,
    );
    return Maintenance.fromJson(response);
  }

  /// Actualiza los detalles de un registro de mantenimiento existente.
  Future<Maintenance> updateMaintenanceRecord(
    int id,
    Map<String, dynamic> data,
  ) async {
    final response = await _apiClient.put('/maintenance/$id', data);
    return Maintenance.fromJson(response);
  }

  /// Elimina de forma permanente un registro de mantenimiento.
  Future<void> deleteMaintenanceRecord(int id) async {
    await _apiClient.delete('/maintenance/$id');
  }
}
