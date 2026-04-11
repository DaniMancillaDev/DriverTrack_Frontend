import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../models/notification_model.dart';
import '../widgets/notifications/notification_card.dart';
import '../core/i18n/translations.g.dart';
import '../core/responsive/responsive.dart';
import '../theme/app_color_scheme.dart';

/// Centro de gestión de alertas y notificaciones del sistema.
/// 
/// Monitoriza y presenta eventos críticos en tiempo real. Sus funciones son:
/// * **Central de Alertas**: Agregación de avisos de mantenimiento, seguridad 
///   y actualizaciones del sistema.
/// * **Segregación por Gravedad**: Clasificación visual y filtrado por niveles 
///   (Crítico, Advertencia, Info, éxito).
/// * **Gestión de Flujos**: Acciones para marcar lecturas masivas o eliminación 
///   de historial irrelevante.
/// * **Sincronización Proactiva**: Integración con el motor de notificaciones 
///   para actualizaciones instantáneas.
class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  String _currentFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: notificationsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.orangePrimary,
            strokeWidth: 2,
          ),
        ),
        error: (error, _) => _buildErrorState(r),
        data: (state) {
          final allNotifications = state.notifications;

          final filteredNotifs = allNotifications.where((n) {
            if (_currentFilter == 'unread') return !n.isRead;
            if (_currentFilter == 'warning')
              return n.type == NotificationType.warning;
            if (_currentFilter == 'success')
              return n.type == NotificationType.success;
            if (_currentFilter == 'info')
              return n.type == NotificationType.info;
            if (_currentFilter == 'error')
              return n.type == NotificationType.error;
            return true;
          }).toList();

          return Column(
            children: [
              _buildHeader(context, state.unreadCount, state.totalCount, r),
              _buildSummaryBar(allNotifications, r),
              _buildFilterTabs(state.unreadCount, allNotifications, r),
              Expanded(
                child: filteredNotifs.isEmpty
                    ? _buildEmptyState(r)
                    : RefreshIndicator(
                        onRefresh: () =>
                            ref.read(notificationsProvider.notifier).refresh(),
                        color: AppColors.orangePrimary,
                        backgroundColor: context.colors.surface,
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: r.space(AppSpacing.lg),
                            vertical: r.space(AppSpacing.xs),
                          ),
                          itemCount:
                              filteredNotifs.length +
                              (state.isLoadingMore ? 1 : 0),
                          separatorBuilder: (_, __) =>
                              SizedBox(height: r.space(AppSpacing.lg)),
                          itemBuilder: (context, index) {
                            if (index == filteredNotifs.length) {
                              return Padding(
                                padding: EdgeInsets.all(r.space(AppSpacing.lg)),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.orangePrimary,
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            }
                            final notif = filteredNotifs[index];
                            return NotificationCard(
                              notif: notif,
                              onTap: () {
                                if (!notif.isRead) {
                                  ref
                                      .read(notificationsProvider.notifier)
                                      .markAsRead(notif.id);
                                }
                              },
                              onDelete: () {
                                ref
                                    .read(notificationsProvider.notifier)
                                    .deleteNotification(notif.id);
                              },
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    int unread,
    int total,
    AppResponsive r,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        r.space(AppSpacing.lg),
        MediaQuery.of(context).padding.top + r.space(AppSpacing.md),
        r.space(AppSpacing.lg),
        r.space(AppSpacing.lg),
      ),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -1.5),
          radius: 1.5,
          colors: [
            AppColors.orangePrimary.withValues(alpha: 0.08),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: context.colors.textMain,
                      size: AppIconSizes.md(context),
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: context.colors.surfaceLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
                      ),
                    ),
                  ),
                SizedBox(width: r.space(AppSpacing.s)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Translations.of(context).notifications.title,
                        style: AppTextStyles.headlineMedium(context).copyWith(
                          color: context.colors.textMain,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (unread > 0)
                        Text(
                          Translations.of(context).notifications.unreadSummary
                              .replaceAll('{unread}', '$unread')
                              .replaceAll('{total}', '$total'),
                          style: AppTextStyles.caption(
                            context,
                          ).copyWith(color: context.colors.textMuted),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (unread > 0)
            GestureDetector(
              onTap: () {
                ref.read(notificationsProvider.notifier).markAllAsRead();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: r.space(AppSpacing.s),
                  vertical: r.space(6),
                ),
                decoration: BoxDecoration(
                  color: AppColors.cyan.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.done_all_rounded,
                      color: AppColors.cyan,
                      size: AppIconSizes.xs(context),
                    ),
                    SizedBox(width: r.space(4)),
                    Text(
                      Translations.of(context).notifications.markAllRead,
                      style: AppTextStyles.caption(context).copyWith(
                        color: AppColors.cyan,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryBar(
    List<NotificationEntity> notifications,
    AppResponsive r,
  ) {
    final t = Translations.of(context);
    final counts = [
      {
        'label': t.notifications.summaryAll,
        'value': notifications.length,
        'color': context.colors.textMuted,
      },
      {
        'label': t.notifications.summaryWarnings,
        'value': notifications
            .where((n) => n.type == NotificationType.warning)
            .length,
        'color': AppColors.orangeSecondary,
      },
      {
        'label': t.notifications.summarySuccess,
        'value': notifications
            .where((n) => n.type == NotificationType.success)
            .length,
        'color': AppColors.green,
      },
      {
        'label': t.notifications.summaryInfo,
        'value': notifications
            .where((n) => n.type == NotificationType.info)
            .length,
        'color': AppColors.cyan,
      },
      {
        'label': 'Crítico',
        'value': notifications
            .where((n) => n.type == NotificationType.error)
            .length,
        'color': AppColors.red,
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: r.space(AppSpacing.lg),
        vertical: r.space(AppSpacing.md),
      ),
      child: Container(
        padding: EdgeInsets.all(r.space(AppSpacing.md)),
        decoration: BoxDecoration(
          color: context.colors.surfaceLight,
          border: Border.all(color: context.colors.borderLight, width: 1.0),
          borderRadius: BorderRadius.circular(r.r(AppRadius.xxl)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: counts.map((c) {
            return Flexible(
              child: Column(
                children: [
                  Text(
                    '${c['value']}',
                    style: AppTextStyles.title(context).copyWith(
                      color: c['color'] as Color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    c['label'] as String,
                    style: AppTextStyles.tiny(context).copyWith(
                      color: context.colors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFilterTabs(
    int unread,
    List<NotificationEntity> notifications,
    AppResponsive r,
  ) {
    final t = Translations.of(context);
    final filters = [
      {'key': 'all', 'label': t.notifications.filterAll},
      {'key': 'unread', 'label': t.notifications.filterUnread},
      {'key': 'warning', 'label': t.notifications.filterWarnings},
      {'key': 'error', 'label': 'Crítico'},
      {'key': 'success', 'label': t.notifications.filterSuccess},
      {'key': 'info', 'label': t.notifications.filterInfo},
    ];

    // Contar notificaciones críticas NO LEÍDAS para el badge
    final errorCount = notifications
        .where((n) => n.type == NotificationType.error && !n.isRead)
        .length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
        horizontal: r.space(AppSpacing.lg),
        vertical: r.space(AppSpacing.xs),
      ),
      child: Row(
        children: filters.map((f) {
          final isSelected = _currentFilter == f['key'];
          // Color semántico por tipo de tab
          final tabColor = switch (f['key']) {
            'error'   => AppColors.red,
            'warning' => AppColors.orangeSecondary,
            'success' => AppColors.green,
            'info'    => AppColors.cyan,
            _         => AppColors.orangePrimary,
          };

          return GestureDetector(
            onTap: () => setState(() => _currentFilter = f['key'] as String),
            child: Container(
              margin: EdgeInsets.only(right: r.space(AppSpacing.xs)),
              padding: EdgeInsets.symmetric(
                horizontal: r.space(AppSpacing.md),
                vertical: r.space(AppSpacing.xs),
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? tabColor.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
                border: Border.all(
                  color: isSelected
                      ? tabColor.withValues(alpha: 0.35)
                      : context.colors.borderLight,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    f['label'] as String,
                    style: AppTextStyles.bodySmall(context).copyWith(
                      color: isSelected ? tabColor : context.colors.textMain,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  // Badge para "No leídas"
                  if (f['key'] == 'unread' && unread > 0) ...[
                    SizedBox(width: r.space(6)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.space(5),
                        vertical: r.space(1),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.orangePrimary,
                        borderRadius: BorderRadius.circular(r.r(10)),
                      ),
                      child: Text(
                        '$unread',
                        style: AppTextStyles.tiny(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                  // Badge para "Crítico"
                  if (f['key'] == 'error' && errorCount > 0) ...[
                    SizedBox(width: r.space(6)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.space(5),
                        vertical: r.space(1),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(r.r(10)),
                      ),
                      child: Text(
                        '$errorCount',
                        style: AppTextStyles.tiny(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(AppResponsive r) {
    final t = Translations.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: r.space(AppSpacing.xl)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícono con halo y badge de check
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: EdgeInsets.all(r.space(AppSpacing.xl)),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        AppColors.green.withValues(alpha: 0.15),
                        AppColors.green.withValues(alpha: 0.03),
                        Colors.transparent,
                      ],
                      radius: 1.0,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(r.space(AppSpacing.lg)),
                    decoration: BoxDecoration(
                      color: AppColors.green.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.green.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.notifications_rounded,
                      size: AppIconSizes.massive(context),
                      color: AppColors.green,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: r.space(AppSpacing.lg)),
            Text(
              t.notifications.emptyTitle,
              style: AppTextStyles.button(context).copyWith(
                color: context.colors.textMain,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            SizedBox(height: r.space(AppSpacing.xs)),
            Text(
              t.notifications.emptySubtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall(context).copyWith(
                color: context.colors.textMuted,
                height: 1.5,
              ),
            ),
            SizedBox(height: r.space(AppSpacing.lg)),
            // Botón de acción — da agencia al usuario
            TextButton.icon(
              onPressed: () =>
                  ref.read(notificationsProvider.notifier).refresh(),
              icon: Icon(
                Icons.refresh_rounded,
                size: r.dim(16),
                color: context.colors.textDim,
              ),
              label: Text(
                t.notifications.retryButton,
                style: AppTextStyles.caption(context).copyWith(
                  color: context.colors.textDim,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(AppResponsive r) {
    // #7 fix: use i18n keys instead of hardcoded Spanish strings
    final t = Translations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(r.space(AppSpacing.lg)),
            decoration: BoxDecoration(
              color: context.colors.surfaceLight,
              borderRadius: BorderRadius.circular(r.r(AppRadius.xxl)),
            ),
            child: Icon(
              Icons.cloud_off_rounded,
              size: AppIconSizes.massive(context),
              color: context.colors.textDim,
            ),
          ),
          SizedBox(height: r.space(AppSpacing.md)),
          Text(
            t.notifications.errorLoading,
            style: AppTextStyles.button(context).copyWith(color: Colors.white),
          ),
          SizedBox(height: r.space(AppSpacing.lg)),
          FilledButton.icon(
            onPressed: () => ref.read(notificationsProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh_rounded),
            label: Text(t.notifications.retryButton),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.orangePrimary,
            ),
          ),
        ],
      ),
    );
  }
}
