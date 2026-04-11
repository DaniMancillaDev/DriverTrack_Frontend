import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_providers.dart';
import '../../services/photo_upload_service.dart';

import 'profile_menu_widgets.dart';
import '../../core/i18n/translations.g.dart';
import '../../core/responsive/responsive.dart';
import '../../theme/app_color_scheme.dart';

/// Sección de impacto visual y encabezado del perfil de usuario.
/// 
/// Presenta la identidad del conductor mediante un avatar enriquecido 
/// (con soporte para carga de fotos e iniciales dinámicas), nombre, 
/// correo y distintivos de membresía. Sirve como punto de entrada para 
/// la gestión visual de la cuenta.
class ProfileHero extends ConsumerStatefulWidget {
  /// Callback opcional para navegar a la edición de datos textuales.
  final VoidCallback? onTapEdit;

  const ProfileHero({
    super.key,
    this.onTapEdit,
  });

  @override
  ConsumerState<ProfileHero> createState() => _ProfileHeroState();
}

class _ProfileHeroState extends ConsumerState<ProfileHero> {
  bool _isUploading = false;

  String _getInitials(String name) {
    if (name.isEmpty) return '??';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  void _showPhotoSourcePicker() {
    final t = Translations.of(context);
    final r = context.responsive;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.all(r.space(AppSpacing.lg)),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(r.r(AppRadius.xl)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: r.dim(40),
              height: r.dim(4),
              margin: EdgeInsets.only(bottom: r.space(AppSpacing.md)),
              decoration: BoxDecoration(
                color: context.colors.borderLight,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
            Text(
              t.profile.changePhoto,
              style: AppTextStyles.headline(context).copyWith(
                color: context.colors.textMain,
                fontSize: r.sp(18),
              ),
            ),
            SizedBox(height: r.space(AppSpacing.lg)),
            _buildSourceOption(
              icon: Icons.camera_alt_outlined,
              label: t.profile.camera,
              color: AppColors.orangePrimary,
              onTap: () {
                Navigator.pop(ctx);
                _uploadPhoto(ImageSource.camera);
              },
            ),
            SizedBox(height: r.space(AppSpacing.s)),
            _buildSourceOption(
              icon: Icons.photo_library_outlined,
              label: t.profile.gallery,
              color: AppColors.cyan,
              onTap: () {
                Navigator.pop(ctx);
                _uploadPhoto(ImageSource.gallery);
              },
            ),
            SizedBox(height: r.space(AppSpacing.md)),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final r = context.responsive;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: r.space(AppSpacing.md),
            vertical: r.space(AppSpacing.s),
          ),
          decoration: BoxDecoration(
            color: context.colors.surfaceLight,
            borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
          ),
          child: Row(
            children: [
              Container(
                width: r.dim(42),
                height: r.dim(42),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(r.r(AppRadius.s)),
                ),
                child: Icon(icon, color: color, size: AppIconSizes.md(context)),
              ),
              SizedBox(width: r.space(AppSpacing.md)),
              Text(
                label,
                style: AppTextStyles.bodyMedium(context).copyWith(
                  color: context.colors.textMain,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right,
                color: context.colors.textMuted,
                size: AppIconSizes.sm(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _uploadPhoto(ImageSource source) async {
    if (_isUploading) return;

    setState(() => _isUploading = true);

    try {
      final userRepo = ref.read(userRepositoryProvider);
      final service = PhotoUploadService(userRepo);

      final result = await service.pickAndUpload(source: source);
      if (result != null && mounted) {
        ref.read(authProvider.notifier).updatePhotoUrl(result.photoUrl);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Translations.of(context).profile.editProfileSuccess),
            backgroundColor: AppColors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final r = context.responsive;
    final user = ref.watch(authProvider);
    final fallbackName = user?.fullName ?? t.profile.driver;
    final fallbackEmail = user?.email ?? '-';
    final memberYear = user?.createdAt.year ?? DateTime.now().year;
    final photoUrl = user?.photoUrl;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        r.space(AppSpacing.lg),
        MediaQuery.of(context).padding.top + r.space(AppSpacing.md),
        r.space(AppSpacing.lg),
        r.space(AppSpacing.xl),
      ),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -1.2),
          radius: 1.2,
          colors: [
            AppColors.orangePrimary.withValues(alpha: 0.13),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.orangePrimary.withValues(alpha: 0.25),
                      blurRadius: 28,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: _buildAvatar(r, fallbackName, photoUrl),
              ),
              // Upload indicator overlay
              if (_isUploading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: r.dim(28),
                        height: r.dim(28),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              // Camera button
              Positioned(
                bottom: 0,
                right: 0,
                child: Semantics(
                  label: t.profile.changePhoto,
                  button: true,
                  child: InkWell(
                    onTap: _isUploading ? null : _showPhotoSourcePicker,
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: r.dim(30),
                      height: r.dim(30),
                      decoration: BoxDecoration(
                        color: context.colors.surfaceLight,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.colors.background,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: AppIconSizes.xs(context),
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: r.space(AppSpacing.md)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  fallbackName,
                  style: AppTextStyles.headline(context).copyWith(
                    color: context.colors.textMain,
                    fontSize: r.sp(23),
                    letterSpacing: -0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: r.space(AppSpacing.xs)),
              Semantics(
                label: t.profile.editProfile,
                button: true,
                child: InkWell(
                  onTap: widget.onTapEdit,
                  borderRadius: BorderRadius.circular(r.r(AppRadius.s)),
                  child: Container(
                    width: r.dim(28),
                    height: r.dim(28),
                    decoration: BoxDecoration(
                      color: context.colors.surfaceLight,
                      borderRadius: BorderRadius.circular(r.r(AppRadius.s)),
                    ),
                    child: Icon(
                      Icons.edit_outlined,
                      size: AppIconSizes.xs(context),
                      color: context.colors.textMuted,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: r.space(AppSpacing.xxs)),
          Text(
            fallbackEmail,
            style: AppTextStyles.bodySmall(
              context,
            ).copyWith(color: context.colors.textMuted),
          ),
          SizedBox(height: r.space(AppSpacing.md)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (user?.isActive == true)
                ProfileBadge(
                  icon: Icons.verified_user_outlined,
                  label: t.profile.activeStatus,
                  color: AppColors.green,
                ),
              if (user?.isActive == true)
                SizedBox(width: r.space(AppSpacing.xs)),
              ProfileBadge(
                icon: Icons.check_circle_outline,
                label: t.profile.memberSince.replaceAll(
                  '{year}',
                  '$memberYear',
                ),
                color: AppColors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(
    AppResponsive r,
    String fallbackName,
    String? photoUrl,
  ) {
    final size = r.dim(96);

    if (photoUrl != null && photoUrl.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: photoUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (_, __) => _buildInitialsAvatar(r, fallbackName),
          errorWidget: (_, __, ___) => _buildInitialsAvatar(r, fallbackName),
        ),
      );
    }

    return _buildInitialsAvatar(r, fallbackName);
  }

  Widget _buildInitialsAvatar(AppResponsive r, String name) {
    return Container(
      width: r.dim(96),
      height: r.dim(96),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 1.4,
          colors: [
            context.colors.surfaceLight,
            AppColors.orangePrimary.withValues(alpha: 0.85),
          ],
          stops: const [0.3, 1.0],
        ),
        border: Border.all(
          color: AppColors.orangePrimary.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          _getInitials(name),
          style: TextStyle(
            color: context.colors.textMain,
            fontSize: r.sp(22),
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
