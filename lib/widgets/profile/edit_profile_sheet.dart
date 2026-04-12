import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../core/responsive/responsive.dart';
import '../../theme/app_color_scheme.dart';
import '../../core/i18n/translations.g.dart';
import '../ui/custom_button.dart';

/// Hoja modal para la edición de la información básica del perfil.
/// 
/// Permite al usuario actualizar su nombre completo, validando que cumpla 
/// con los requisitos mínimos de longitud antes de persistir los cambios 
/// en el servidor a través del estado global de autenticación.
class EditProfileSheet extends ConsumerStatefulWidget {
  const EditProfileSheet({super.key});

  @override
  ConsumerState<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<EditProfileSheet> {
  late TextEditingController _nameController;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider);
    _nameController = TextEditingController(text: user?.fullName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    if (name.length < 3) {
      setState(() => _errorMessage = 'Name must be at least 3 characters');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authProvider.notifier).updateProfile(name);
      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Translations.of(context).profile.editProfileSuccess),
            backgroundColor: AppColors.green,
          ),
        );
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
    final user = ref.watch(authProvider);

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
          Text(
            t.profile.editProfile,
            style: AppTextStyles.headline(context).copyWith(
              color: context.colors.textMain,
              fontSize: r.sp(20),
            ),
          ),
          SizedBox(height: r.space(AppSpacing.xs)),
          Text(
            user?.email ?? '',
            style: AppTextStyles.caption(context).copyWith(
              color: context.colors.textMuted,
            ),
          ),
          SizedBox(height: r.space(AppSpacing.lg)),

          // Campo de nombre
          Text(
            t.profile.editProfileName.toUpperCase(),
            style: AppTextStyles.label(context).copyWith(
              color: context.colors.textMuted,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: r.space(AppSpacing.xs)),
          TextField(
            controller: _nameController,
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
                borderSide: const BorderSide(color: AppColors.orangePrimary, width: 1.5),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: r.space(AppSpacing.md),
                vertical: r.space(AppSpacing.s),
              ),
            ),
          ),
          if (_errorMessage != null) ...[
            SizedBox(height: r.space(AppSpacing.xs)),
            Text(
              _errorMessage!,
              style: AppTextStyles.caption(context).copyWith(
                color: AppColors.red,
              ),
            ),
          ],
          SizedBox(height: r.space(AppSpacing.lg)),

          // Botón de guardar
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              onPressed: _isLoading ? null : _saveProfile,
              child: _isLoading
                  ? SizedBox(
                      width: r.dim(20),
                      height: r.dim(20),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(t.profile.editProfileSave),
            ),
          ),
        ],
      ),
    );
  }
}
