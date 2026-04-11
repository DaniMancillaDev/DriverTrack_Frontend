import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_client.dart';
import 'app_providers.dart';

enum ForgotPasswordStep {
  requestEmail,
  verifyOtp,
  resetPassword,
  success,
}

class ForgotPasswordState {
  final ForgotPasswordStep step;
  final bool isLoading;
  final String? error;
  final String email;
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

class ForgotPasswordNotifier extends Notifier<ForgotPasswordState> {
  late ApiClient _api;

  @override
  ForgotPasswordState build() {
    _api = ref.watch(apiClientProvider);
    return const ForgotPasswordState();
  }

  Future<bool> requestOtp(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _api.post('/auth/forgot-password', {'email': email});
      
      state = state.copyWith(
        isLoading: false,
        step: ForgotPasswordStep.verifyOtp,
        email: email, // Guardamos el email para los siguientes pasos
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
        otp: otp, // Guardamos el otp válido para el paso final
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

  void reset() {
    state = const ForgotPasswordState();
  }
}

final forgotPasswordProvider = NotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>(
  () => ForgotPasswordNotifier(),
);
