import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/api_client.dart';
import 'app_providers.dart';

/// Pasos lógicos del flujo de recuperación de cuenta.
enum ForgotPasswordStep {
  /// Ingreso de correo electrónico para solicitar el código.
  requestEmail,
  /// Validación del código OTP enviado por correo.
  verifyOtp,
  /// Ingreso y confirmación de la nueva contraseña.
  resetPassword,
  /// Finalización exitosa del proceso.
  success,
}

/// Estado de UI para la pantalla de recuperación de contraseña.
/// 
/// Centraliza la información recolectada durante el asistente de restauración de cuenta.
class ForgotPasswordState {
  /// Paso actual del asistente que determina qué UI mostrar.
  final ForgotPasswordStep step;
  /// Indicador global de carga para operaciones asíncronas.
  final bool isLoading;
  /// Mensaje de error para feedback visual.
  final String? error;
  /// Email recolectado en la primera etapa.
  final String email;
  /// Código OTP verificado y necesario para la etapa final.
  final String otp;

  const ForgotPasswordState({
    this.step = ForgotPasswordStep.requestEmail,
    this.isLoading = false,
    this.error,
    this.email = '',
    this.otp = '',
  });

  ForgotPasswordState copyWith({
    ForgotPasswordStep? step,
    bool? isLoading,
    String? error,
    bool clearError = false,
    String? email,
    String? otp,
  }) {
    return ForgotPasswordState(
      step: step ?? this.step,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      email: email ?? this.email,
      otp: otp ?? this.otp,
    );
  }
}

/// Notifier encargado de gestionar el flujo de recuperación de contraseña.
/// 
/// Orquesta la comunicación con el servidor mediante el [ApiClient] y gestiona 
/// la transición entre las etapas (Request -> Verify -> Reset).
class ForgotPasswordNotifier extends Notifier<ForgotPasswordState> {
  late ApiClient _api;

  @override
  ForgotPasswordState build() {
    _api = ref.watch(apiClientProvider);
    return const ForgotPasswordState();
  }

  /// 1. Solicita el envío de un código OTP al [email] proporcionado.
  /// Si tiene éxito, transacciona al estado [ForgotPasswordStep.verifyOtp].
  Future<bool> requestOtp(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _api.post('/auth/forgot-password', {'email': email});
      
      state = state.copyWith(
        isLoading: false,
        step: ForgotPasswordStep.verifyOtp,
        email: email, 
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// 2. Valida el código [otp] ingresado por el usuario contra el servidor.
  /// Si es correcto, transacciona al estado [ForgotPasswordStep.resetPassword].
  Future<bool> verifyOtp(String otp) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _api.post('/auth/verify-otp', {
        'email': state.email,
        'otp_code': otp,
      });

      state = state.copyWith(
        isLoading: false,
        step: ForgotPasswordStep.resetPassword,
        otp: otp, 
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// 3. Ejecuta el cambio final de contraseña usando el token OTP validado previamente.
  /// Si tiene éxito, transacciona al estado de victoria [ForgotPasswordStep.success].
  Future<bool> resetPassword(String newPassword) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _api.post('/auth/reset-password', {
        'email': state.email,
        'otp_code': state.otp,
        'new_password': newPassword,
      });

      state = state.copyWith(
        isLoading: false,
        step: ForgotPasswordStep.success,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Reinicia el flujo al estado inicial (útil al reintentar o cerrar el flujo).
  void reset() {
    state = const ForgotPasswordState();
  }
}

/// Provider global que expone el estado de recuperación de contraseña.
final forgotPasswordProvider = NotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>(
  () => ForgotPasswordNotifier(),
);
