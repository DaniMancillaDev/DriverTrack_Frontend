import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';

import 'profile_menu_widgets.dart';
import '../../core/i18n/translations.g.dart';
import '../../core/responsive/responsive.dart';
import '../../theme/app_color_scheme.dart';

class ProfileHero extends ConsumerWidget {
  const ProfileHero({super.key});

  String _getInitials(String name) {
    if (name.isEmpty) return '??';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final r = context.responsive;
    final user = ref.watch(authProvider);
    final fallbackName = user?.fullName ?? t.profile.driver;
    final fallbackEmail = user?.email ?? '-';
    final memberYear = user?.createdAt.year ?? DateTime.now().year;

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
                child: Container(
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
                      _getInitials(fallbackName),
                      style: TextStyle(
                        color: context.colors.textMain,
                        fontSize: r.sp(22),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: r.dim(30),
                  height: r.dim(30),
                  decoration: BoxDecoration(
                    color: context.colors.surfaceLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: context.colors.background, width: 2),
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: AppIconSizes.xs(context),
                    color: context.colors.textSecondary,
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
              Container(
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
}
