/// Widget para una tarjeta de notificación individual.
///
/// Diferencia visual entre leída/no leída, muestra ícono
/// según tipo, y soporta swipe-to-dismiss.

import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/i18n/translations.g.dart';
import '../../domain/entities/notification_entity.dart';
import '../../../../theme/app_color_scheme.dart';

class NotificationTile extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    final isRead = notification.isRead;

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: r.space(AppSpacing.lg)),
        decoration: BoxDecoration(
          color: AppColors.red.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          color: AppColors.red,
          size: AppIconSizes.xl(context),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            padding: EdgeInsets.all(r.space(AppSpacing.md)),
            decoration: BoxDecoration(
              color: isRead
                  ? context.colors.surface
                  : context.colors.surfaceLight.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
              border: Border.all(
                color: isRead
                    ? context.colors.border
                    : _typeColor(notification.type).withValues(alpha: 0.3),
                width: isRead ? 1 : 1.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ícono de tipo
                _TypeIcon(type: notification.type, isRead: isRead),
                SizedBox(width: r.space(AppSpacing.s)),

                // Contenido
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título + indicador de no leída
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: AppTextStyles.body(context).copyWith(
                                color: isRead
                                    ? context.colors.textSecondary
                                    : context.colors.textMain,
                                fontWeight: isRead
                                    ? FontWeight.w400
                                    : FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: r.dim(8),
                              height: r.dim(8),
                              margin: EdgeInsets.only(
                                left: r.space(AppSpacing.xs),
                              ),
                              decoration: BoxDecoration(
                                color: _typeColor(notification.type),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: r.space(AppSpacing.xxs)),

                      // Mensaje
                      Text(
                        notification.message,
                        style: AppTextStyles.bodySmall(context).copyWith(
                          color: isRead
                              ? context.colors.textMuted
                              : context.colors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: r.space(AppSpacing.xs)),

                      // Timestamp
                      Text(
                        _formatTimestamp(
                          notification.createdAt,
                          Translations.of(context),
                        ),
                        style: AppTextStyles.caption(
                          context,
                        ).copyWith(color: context.colors.textDark),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Formatea el timestamp de forma relativa usando i18n.
  String _formatTimestamp(DateTime timestamp, Translations t) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) return t.time.now;
    if (diff.inMinutes < 60)
      return t.time.minutesAgo(n: diff.inMinutes);
    if (diff.inHours < 24)
      return t.time.hoursAgo(n: diff.inHours);
    if (diff.inDays < 7)
      return t.time.daysAgo(n: diff.inDays);
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }

  /// Retorna el color según el tipo de notificación.
  static Color _typeColor(NotificationType type) {
    switch (type) {
      case NotificationType.info:
        return AppColors.cyan;
      case NotificationType.warning:
        return AppColors.yellow;
      case NotificationType.success:
        return AppColors.green;
      case NotificationType.error:
        return AppColors.red;
      case NotificationType.weather:
        return AppColors.cyan;
    }
  }
}

/// Ícono con fondo circular según el tipo de notificación.
class _TypeIcon extends StatelessWidget {
  final NotificationType type;
  final bool isRead;

  const _TypeIcon({required this.type, required this.isRead});

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    final color = NotificationTile._typeColor(type);
    final icon = _iconForType(type);

    return Container(
      width: r.dim(40),
      height: r.dim(40),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isRead ? 0.08 : 0.15),
        borderRadius: BorderRadius.circular(r.r(AppRadius.s)),
      ),
      child: Icon(
        icon,
        color: isRead ? color.withValues(alpha: 0.5) : color,
        size: AppIconSizes.lg(context),
      ),
    );
  }

  IconData _iconForType(NotificationType type) {
    switch (type) {
      case NotificationType.info:
        return Icons.info_outline_rounded;
      case NotificationType.warning:
        return Icons.warning_amber_rounded;
      case NotificationType.success:
        return Icons.check_circle_outline_rounded;
      case NotificationType.error:
        return Icons.error_outline_rounded;
      case NotificationType.weather:
        return Icons.cloud_outlined;
    }
  }
}
