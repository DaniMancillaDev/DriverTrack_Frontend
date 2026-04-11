import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../services/user_repository.dart';

/// Servicio para manejar el flujo de selección y subida de foto de perfil.
class PhotoUploadService {
  final UserRepository _userRepo;
  final ImagePicker _picker = ImagePicker();

  PhotoUploadService(this._userRepo);

  /// Abre el picker y sube la foto via pre-signed URL.
  /// Retorna el URL de la foto ya subida, o null si se cancela.
  Future<PhotoUploadResult?> pickAndUpload({ImageSource? source}) async {
    // 1. Seleccionar imagen
    final XFile? image = await _picker.pickImage(
      source: source ?? ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );

    if (image == null) return null;

    // 2. Obtener pre-signed URL del backend
    final presignedData = await _userRepo.getPhotoPresignedUrl();
    final uploadUrl = presignedData['upload_url']!;
    final objectKey = presignedData['object_key']!;

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

    // 4. Confirmar la subida al backend (guarda URL en perfil)
    final updatedUser = await _userRepo.confirmPhotoUpload(objectKey: objectKey);

    return PhotoUploadResult(
      photoUrl: updatedUser.photoUrl ?? presignedData['photo_url']!,
      objectKey: objectKey,
    );
  }
}

class PhotoUploadResult {
  final String photoUrl;
  final String objectKey;

  PhotoUploadResult({required this.photoUrl, required this.objectKey});
}
