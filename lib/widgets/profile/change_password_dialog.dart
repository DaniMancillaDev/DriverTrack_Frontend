import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_providers.dart';
import '../../providers/auth_provider.dart';
import '../../core/network/api_client.dart';
import '../../core/responsive/responsive.dart';
import '../../theme/app_color_scheme.dart';
import '../../core/i18n/translations.g.dart';
import '../ui/custom_button.dart';

class ChangePasswordDialog extends ConsumerStatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  ConsumerState<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends ConsumerState<ChangePasswordDialog> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final t = Translations.of(context);
    final currentPwd = _currentPasswordController.text;
    final newPwd = _newPasswordController.text;
    final confirmPwd = _confirmPasswordController.text;

    // Validaciones
    if (currentPwd.isEmpty || newPwd.isEmpty || confirmPwd.isEmpty) {
      setState(() => _errorMessage = 'All fields are required');
      return;
    }
    if (newPwd.length < 8) {
      setState(() => _errorMessage = 'New password must be at least 8 characters');
      return;
    }
    if (newPwd != confirmPwd) {
      setState(() => _errorMessage = t.profile.passwordsMismatch);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repo = ref.read(userRepositoryProvider);
      await repo.changePassword(
        currentPassword: currentPwd,
        newPassword: newPwd,
      );
      
      // Actualiza el estado local para que la UI lo refleje inmediatamente
      ref.read(authProvider.notifier).updatePasswordChangedAt(DateTime.now());

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.profile.changePasswordSuccess),
            backgroundColor: AppColors.green,
          ),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.statusCode == 401
              ? t.profile.changePasswordError
              : e.message;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final r = context.responsive;

    return Container(
      padding: EdgeInsets.fromLTRB(
        r.space(AppSpacing.lg),
        r.space(AppSpacing.md),
        r.space(AppSpacing.lg),
        MediaQuery.of(context).viewInsets.bottom + r.space(AppSpacing.lg),
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(r.r(AppRadius.xl)),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Asa de arrastre
            Center(
              child: Container(
                width: r.dim(40),
                height: r.dim(4),
                margin: EdgeInsets.only(bottom: r.space(AppSpacing.md)),
                decoration: BoxDecoration(
                  color: context.colors.borderLight,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            ),

            // Título
            Row(
              children: [
                Icon(
                  Icons.lock_outline,
                  color: AppColors.green,
                  size: AppIconSizes.md(context),
                ),
                SizedBox(width: r.space(AppSpacing.xs)),
                Text(
                  t.profile.changePassword,
                  style: AppTextStyles.headline(context).copyWith(
                    color: context.colors.textMain,
                    fontSize: r.sp(20),
                  ),
                ),
              ],
            ),
            SizedBox(height: r.space(AppSpacing.lg)),

            // Contraseña actual
            _buildPasswordField(
              label: t.profile.currentPassword,
              controller: _currentPasswordController,
              obscure: _obscureCurrent,
              onToggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
            ),
            SizedBox(height: r.space(AppSpacing.md)),

            // Nueva contraseña
            _buildPasswordField(
              label: t.profile.newPassword,
              controller: _newPasswordController,
              obscure: _obscureNew,
              onToggle: () => setState(() => _obscureNew = !_obscureNew),
            ),
            SizedBox(height: r.space(AppSpacing.md)),

            // Confirmar contraseña
            _buildPasswordField(
              label: t.profile.confirmNewPassword,
              controller: _confirmPasswordController,
              obscure: _obscureConfirm,
              onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),

            if (_errorMessage != null) ...[
              SizedBox(height: r.space(AppSpacing.s)),
              Container(
                padding: EdgeInsets.all(r.space(AppSpacing.s)),
                decoration: BoxDecoration(
                  color: AppColors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(r.r(AppRadius.s)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: AppColors.red, size: AppIconSizes.xs(context)),
                    SizedBox(width: r.space(AppSpacing.xs)),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: AppTextStyles.caption(context).copyWith(
                          color: AppColors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: r.space(AppSpacing.lg)),

            // Botón de guardar
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: _isLoading ? null : _changePassword,
                child: _isLoading
                    ? SizedBox(
                        width: r.dim(20),
                        height: r.dim(20),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(t.profile.changePassword),
              ),
            ),
            SizedBox(height: r.space(AppSpacing.s)),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    final r = context.responsive;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.label(context).copyWith(
            color: context.colors.textMuted,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: r.space(AppSpacing.xxs)),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: AppTextStyles.body(context).copyWith(
            color: context.colors.textMain,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: context.colors.surfaceLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
              borderSide: BorderSide(color: context.colors.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
              borderSide: BorderSide(color: context.colors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
              borderSide: const BorderSide(color: AppColors.green, width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: r.space(AppSpacing.md),
              vertical: r.space(AppSpacing.s),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: context.colors.textMuted,
                size: AppIconSizes.sm(context),
              ),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }
}
