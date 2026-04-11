import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';

import '../../services/api_client.dart';
import '../i18n/translations.g.dart';

/// Convierte cualquier excepción en un mensaje legible para el usuario.
///
/// Reglas:
/// - Nunca expone URLs, nombres de clase ni stack traces.
/// - Usa claves i18n cuando están disponibles.
/// - Requiere [BuildContext] para acceder a las traducciones activas.
abstract final class ErrorMapper {
  ErrorMapper._();

  static String toUserMessage(Object error, BuildContext context) {
    final t = Translations.of(context);

    // ── Red / conectividad ─────────────────────────────────────────────────
    if (error is SocketException ||
        _isClientConnectionError(error)) {
      return t.common.networkError;
    }

    if (error is TimeoutException) {
      return t.common.timeoutError;
    }

    // ── Respuestas del servidor (ApiException) ─────────────────────────────
    if (error is ApiException) {
      final status = error.statusCode;

      if (status == 401 || status == 403) {
        return t.common.unauthorizedError;
      }

      if (status == 404) {
        return t.common.notFoundError;
      }

      if (status == 422) {
        return t.common.validationError;
      }

      if (status >= 500) {
        return t.common.serverError;
      }

      // 4xx genérico
      return t.common.requestError;
    }

    // ── Fallback genérico ──────────────────────────────────────────────────
    return t.common.error;
  }

  /// Detecta errores de conexión lanzados por el paquete `http`
  /// (ClientException) sin importar el tipo concreto de la plataforma.
  static bool _isClientConnectionError(Object error) {
    // El paquete http lanza ClientException cuyo mensaje contiene la URL.
    // En web lanza un objeto distinto pero con el mismo mensaje.
    final msg = error.toString().toLowerCase();
    return msg.contains('failed to fetch') ||
        msg.contains('clientexception') ||
        msg.contains('connection refused') ||
        msg.contains('network is unreachable') ||
        msg.contains('software caused connection abort');
  }
}
