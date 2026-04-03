/// Widget de badge para notificaciones no leídas.
///
/// Muestra un indicador circular con el conteo de
/// notificaciones no leídas sobre un ícono.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../theme/app_theme.dart';
import '../../../../core/responsive/responsive.dart';
import '../providers/notifications_provider.dart';

class NotificationBadge extends ConsumerWidget {
  final VoidCallback? onTap;
  final double? iconSize;

  const NotificationBadge({
    super.key,
    this.onTap,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadCountProvider);
    final r = context.responsive;

    return IconButton(
      onPressed: onTap,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            Icons.notifications_outlined,
            color: AppColors.textSecondary,
            size: iconSize ?? AppIconSizes.xl(context),
          ),
          if (unreadCount > 0)
            Positioned(
              right: -r.dim(4),
              top: -r.dim(4),
              child: AnimatedScale(
                scale: unreadCount > 0 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.elasticOut,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.space(AppSpacing.xxs),
                    vertical: r.space(1),
                  ),
                  constraints: BoxConstraints(
                    minWidth: r.dim(18),
                    minHeight: r.dim(18),
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.orangePrimary.withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      unreadCount > 99 ? '99+' : '$unreadCount',
                      style: AppTextStyles.micro(context).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
