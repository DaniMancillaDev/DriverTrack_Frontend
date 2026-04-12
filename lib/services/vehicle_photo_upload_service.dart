import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../services/vehicle_repository.dart';
import '../models/vehicle_model.dart';

/// Servicio para manejar el flujo de selección y subida de foto de vehículo.
class VehiclePhotoUploadService {
  final VehicleRepository _vehicleRepo;
  final ImagePicker _picker = ImagePicker();

  VehiclePhotoUploadService(this._vehicleRepo);

  /// Abre el picker y sube la foto via pre-signed URL.
  /// Retorna el Vehículo actualizado, o null si se cancela.
  Future<Vehicle?> pickAndUpload({
    required int vehicleId,
    ImageSource? source,
  }) async {
    // 1. Seleccionar imagen (Aspect ratio distinto o similar, mantenemos 512x512 para performance)
    final XFile? image = await _picker.pickImage(
      source: source ?? ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (image == null) return null;

    // 2. Obtener pre-signed URL del backend
    final presignedData = await _vehicleRepo.getVehiclePhotoPresignedUrl(vehicleId);
    final uploadUrl = presignedData['upload_url']!;

    // 3. Subir la imagen via HTTP PUT al pre-signed URL
    final file = File(image.path);
    final bytes = await file.readAsBytes();

    final response = await http.put(
      Uri.parse(uploadUrl),
      headers: {
        'Content-Type': 'image/jpeg',
      },
      body: bytes,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Upload failed with status ${response.statusCode}: ${response.body}',
      );
    }

    // 4. Confirmar la subida al backend (guarda URL en vehículo)
    // El 'photo_url' decodificado ya viene seguro para el DB
    final updatedVehicle = await _vehicleRepo.confirmVehiclePhotoUpload(
      vehicleId,
      presignedData['object_key']!,
    );

    return updatedVehicle;
  }
}
