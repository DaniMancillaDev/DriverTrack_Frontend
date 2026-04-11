// Removed dart:ui
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../core/i18n/translations.g.dart';
import '../../core/responsive/responsive.dart';
import '../../features/notifications/presentation/providers/notifications_provider.dart';
import '../../theme/app_color_scheme.dart';

class GarageHeader extends ConsumerWidget {
  final VoidCallback onNotificationTap;

  const GarageHeader({super.key, required this.onNotificationTap});

  /// Devuelve el saludo apropiado según la hora local del dispositivo.
  String _greeting(BuildContext context) {
    final hour = DateTime.now().hour;
    final t = Translations.of(context).garage;
    if (hour >= 6 && hour < 12) return t.goodMorning;
    if (hour >= 12 && hour < 18) return t.goodAfternoon;
    return t.goodEvening;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final r = context.responsive;
    final unreadCount = ref.watch(unreadCountProvider);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
      ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: r.value(mobile: 600, tablet: 700),
              ),
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
                            _greeting(context),
                            style: textTheme.bodySmall?.copyWith(
                              color: context.colors.textDim,
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
                    _NotificationIconButton(
                      count: unreadCount,
                      onTap: onNotificationTap,
                    ),
                  ],
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
    return Semantics(
      button: true,
      label: count > 0 
          ? Translations.of(context).garage.notificationsUnread.replaceAll('{count}', count.toString())
          : Translations.of(context).garage.notificationsNone,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          // Ensure a minimum tap target of 48x48 (Material accessibility guidelines)
          width: r.dim(48),
          height: r.dim(48),
          alignment: Alignment.center,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: r.dim(42),
                height: r.dim(42),
                decoration: BoxDecoration(
                  color: context.colors.surfaceLight,
                  borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
                ),
                child: Icon(
                  count > 0
                      ? Icons.notifications_rounded
                      : Icons.notifications_none_rounded,
                  color: count > 0
                      ? (context.colors.isDark ? Colors.white : AppColors.orangePrimary)
                      : context.colors.textSecondary,
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
        ),
      ),
    );
  }
}
