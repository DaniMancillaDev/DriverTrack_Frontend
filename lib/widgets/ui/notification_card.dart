import 'dart:convert';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/responsive/responsive.dart';
import '../../core/i18n/translations.g.dart';
import '../../features/notifications/domain/entities/notification_entity.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../theme/app_color_scheme.dart';

/// Un componente de tarjeta interactiva para mostrar notificaciones del sistema.
/// 
/// Soporta payloads dinámicos en formato JSON para interpolar datos (vehículo, días, etc.)
/// en mensajes localizados. Incluye acciones de deslizamiento ([Slidable]) para 
/// eliminar notificaciones de forma intuitiva.
class NotificationCard extends StatelessWidget {
  /// Entidad que contiene los datos de la notificación.
  final NotificationEntity notif;
  /// Callback disparado al presionar la tarjeta.
  final VoidCallback onTap;
  /// Callback disparado al confirmar la eliminación mediante el gesto slidable.
  final VoidCallback onDelete;

  const NotificationCard({
    super.key,
    required this.notif,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // ... (logic follows in the build method)
    final r = context.responsive;
    final cfg = _getTypeConfig(notif.type, context);

    String displayTitle = notif.title;
    String displayMessage = notif.message;
    bool isDynamic = notif.message.trim().startsWith('{');
    
    if (isDynamic) {
      try {
        final payload = jsonDecode(notif.message) as Map<String, dynamic>;
        final currentLang = Translations.of(context).notifications;
        
        switch (notif.title) {
          case 'mileage_warning':
            displayTitle = currentLang.rules.mileage_warning.title(
                brand: payload['brand']?.toString() ?? '',
                model: payload['model']?.toString() ?? '');
            displayMessage = currentLang.rules.mileage_warning.message(
                brand: payload['brand']?.toString() ?? '',
                model: payload['model']?.toString() ?? '',
                plate: payload['plate']?.toString() ?? '',
                percent: payload['percent']?.toString() ?? '',
                mileage: payload['mileage']?.toString() ?? '',
                max_mileage: payload['max_mileage']?.toString() ?? '');
            break;
          case 'mileage_critical':
            displayTitle = currentLang.rules.mileage_critical.title(
                brand: payload['brand']?.toString() ?? '',
                model: payload['model']?.toString() ?? '');
            displayMessage = currentLang.rules.mileage_critical.message(
                brand: payload['brand']?.toString() ?? '',
                model: payload['model']?.toString() ?? '',
                plate: payload['plate']?.toString() ?? '',
                percent: payload['percent']?.toString() ?? '',
                mileage: payload['mileage']?.toString() ?? '',
                max_mileage: payload['max_mileage']?.toString() ?? '');
            break;
          case 'maintenance_overdue':
            displayTitle = currentLang.rules.maintenance_overdue.title(
                brand: payload['brand']?.toString() ?? '',
                model: payload['model']?.toString() ?? '');
            displayMessage = currentLang.rules.maintenance_overdue.message(
                brand: payload['brand']?.toString() ?? '',
                model: payload['model']?.toString() ?? '',
                plate: payload['plate']?.toString() ?? '',
                days: payload['days']?.toString() ?? '',
                last_date: payload['last_date']?.toString() ?? '');
            break;
          case 'no_maintenance':
            displayTitle = currentLang.rules.no_maintenance.title(
                brand: payload['brand']?.toString() ?? '',
                model: payload['model']?.toString() ?? '');
            displayMessage = currentLang.rules.no_maintenance.message(
                brand: payload['brand']?.toString() ?? '',
                model: payload['model']?.toString() ?? '',
                plate: payload['plate']?.toString() ?? '');
            break;
        }
      } catch (_) {
        // Fallback to raw text if JSON is malformed
      }
    }

    // Wrap unread cards with a left accent strip — mobile pattern, no full border
    Widget card = Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: !notif.isRead
            ? Border(left: BorderSide(color: cfg.accent, width: 3))
            : null,
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(r.space(AppSpacing.lg)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon — compact 38×38
                Container(
                  width: r.dim(38),
                  height: r.dim(38),
                  decoration: BoxDecoration(
                    color: cfg.accent.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(r.r(12)),
                  ),
                  child: Icon(
                    cfg.icon,
                    color: cfg.accent,
                    size: AppIconSizes.md(context),
                  ),
                ),
                SizedBox(width: r.space(AppSpacing.s)),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title only — icon color already communicates type
                      Text(
                        displayTitle,
                        style: AppTextStyles.bodyMedium(context).copyWith(
                          color: context.colors.textMain,
                          fontWeight: notif.isRead
                              ? FontWeight.w500
                              : FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: r.space(3)),
                      Text(
                        displayMessage,
                        style: AppTextStyles.caption(
                          context,
                        ).copyWith(color: context.colors.textMuted, height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: r.space(AppSpacing.xs)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              if (!notif.isRead) ...[
                                Container(
                                  width: r.dim(5),
                                  height: r.dim(5),
                                  decoration: BoxDecoration(
                                    color: cfg.accent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: r.space(4)),
                              ],
                              Text(
                                _formatTimestamp(notif.createdAt, context),
                                style: AppTextStyles.label(context).copyWith(
                                  color: context.colors.textMuted,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return Slidable(
      key: ValueKey(notif.id),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        extentRatio: 0.25,
        children: [
          CustomSlidableAction(
            onPressed: (context) => onDelete(),
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.red,
            autoClose: true,
            padding: EdgeInsets.only(left: r.space(AppSpacing.md)),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: const Center(
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.red,
                ),
              ),
            ),
          ),
        ],
      ),
      child: GestureDetector(onTap: onTap, child: card),
    );
  }

  String _formatTimestamp(DateTime timestamp, BuildContext context) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    // #7 fix: timestamp strings are locale-neutral (numbers + short units).
    // Full i18n would require plural keys in slang — using compact format as fallback.
    if (diff.inMinutes < 1) return Translations.of(context).time.now;
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }

  _TypeConfig _getTypeConfig(NotificationType type, BuildContext context) {
    final t = Translations.of(context);
    switch (type) {
      case NotificationType.warning:
        return _TypeConfig(
          Icons.warning_amber_rounded,
          AppColors.orangeSecondary,
          t.notifications.typeWarning,
        );
      case NotificationType.success:
        return _TypeConfig(
          Icons.check_circle_outline_rounded,
          AppColors.green,
          t.notifications.typeSuccess,
        );
      case NotificationType.info:
        return _TypeConfig(
          Icons.info_outline_rounded,
          AppColors.accent,
          t.notifications.typeInfo,
        );
      case NotificationType.error:
        return _TypeConfig(Icons.error_outline_rounded, AppColors.red, t.notifications.typeError);
      case NotificationType.weather:
        return _TypeConfig(
          Icons.thermostat_rounded,
          AppColors.cyan,
          t.notifications.typeInfo,
        );
    }
  }
}

class _TypeConfig {
  final IconData icon;
  final Color accent;
  final String label;

  _TypeConfig(this.icon, this.accent, this.label);
}
