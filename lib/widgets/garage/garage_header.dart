import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../core/i18n/translations.g.dart';
import '../../core/responsive/responsive.dart';
import '../../features/notifications/presentation/providers/notifications_provider.dart';

class GarageHeader extends ConsumerWidget {
  final VoidCallback onNotificationTap;

  const GarageHeader({super.key, required this.onNotificationTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final r = context.responsive;
    final unreadCount = ref.watch(unreadCountProvider);

    return ClipRRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor.withValues(alpha: 0.4),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: r.value(mobile: 600, tablet: 700)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  r.space(AppSpacing.lg),
                  MediaQuery.of(context).padding.top + r.space(AppSpacing.xs),
                  r.space(AppSpacing.lg),
                  r.space(AppSpacing.md),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Translations.of(context).garage.goodMorning,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textDim,
                            ),
                          ),
                          Text(
                            Translations.of(context).garage.myGarage,
                            style: textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _NotificationIconButton(count: unreadCount, onTap: onNotificationTap),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationIconButton extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _NotificationIconButton({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: r.dim(42),
            height: r.dim(42),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
            ),
            child: Icon(
              count > 0 ? Icons.notifications_rounded : Icons.notifications_none_rounded,
              color: count > 0 ? Colors.white : AppColors.textSecondary,
              size: AppIconSizes.lg(context),
            ),
          ),
          if (count > 0)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: r.space(3)),
                constraints: BoxConstraints(
                  minWidth: r.dim(16),
                  minHeight: r.dim(16),
                ),
                decoration: BoxDecoration(
                  color: AppColors.red, // Flat limited palette (Tip 2)
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  // Removed heavy 2px background border
                ),
                child: Center(
                  child: Text(
                    count > 99 ? '99+' : count.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: r.sp(8),
                      fontWeight: FontWeight.w800,
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
