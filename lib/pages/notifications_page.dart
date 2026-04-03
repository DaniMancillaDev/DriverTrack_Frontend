import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../widgets/ui/custom_list_card.dart';
import '../core/i18n/translations.g.dart';
import '../core/responsive/responsive.dart';
import '../features/notifications/presentation/providers/notifications_provider.dart';
import '../features/notifications/domain/entities/notification_entity.dart';

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
      backgroundColor: AppColors.background,
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
            if (_currentFilter == 'warning') return n.type == NotificationType.warning;
            if (_currentFilter == 'success') return n.type == NotificationType.success;
            if (_currentFilter == 'info') return n.type == NotificationType.info;
            if (_currentFilter == 'error') return n.type == NotificationType.error;
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
                        onRefresh: () => ref.read(notificationsProvider.notifier).refresh(),
                        color: AppColors.orangePrimary,
                        backgroundColor: AppColors.surface,
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: r.space(AppSpacing.lg),
                            vertical: r.space(AppSpacing.xs),
                          ),
                          itemCount: filteredNotifs.length + (state.isLoadingMore ? 1 : 0),
                          separatorBuilder: (_, __) => SizedBox(height: r.space(AppSpacing.lg)),
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
                            return _NotificationCard(
                              notif: notif,
                              onTap: () {
                                if (!notif.isRead) {
                                  ref.read(notificationsProvider.notifier).markAsRead(notif.id);
                                }
                              },
                              onDelete: () {
                                ref.read(notificationsProvider.notifier).deleteNotification(notif.id);
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

  Widget _buildHeader(BuildContext context, int unread, int total, AppResponsive r) {
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
            AppColors.cyan.withValues(alpha: 0.1),
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
                  icon: Icon(Icons.arrow_back, color: AppColors.textMuted, size: AppIconSizes.md(context)),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surface,
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
                              color: Colors.white,
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
                          style: AppTextStyles.caption(context).copyWith(
                            color: AppColors.textMuted,
                          ),
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
                    Icon(Icons.done_all_rounded, color: AppColors.cyan, size: AppIconSizes.xs(context)),
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

  Widget _buildSummaryBar(List<NotificationEntity> notifications, AppResponsive r) {
    final t = Translations.of(context);
    final counts = [
      {'label': t.notifications.summaryAll, 'value': notifications.length, 'color': AppColors.textMuted},
      {'label': t.notifications.summaryWarnings, 'value': notifications.where((n) => n.type == NotificationType.warning).length, 'color': AppColors.orangeSecondary},
      {'label': t.notifications.summarySuccess, 'value': notifications.where((n) => n.type == NotificationType.success).length, 'color': AppColors.green},
      {'label': 'Info', 'value': notifications.where((n) => n.type == NotificationType.info).length, 'color': AppColors.cyan},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: r.space(AppSpacing.lg),
        vertical: r.space(AppSpacing.md),
      ),
      child: Container(
        padding: EdgeInsets.all(r.space(AppSpacing.md)),
        decoration: BoxDecoration(
          color: AppColors.surface,
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
                      color: AppColors.textMuted,
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

  Widget _buildFilterTabs(int unread, List<NotificationEntity> notifications, AppResponsive r) {
    final t = Translations.of(context);
    final filters = [
      {'key': 'all', 'label': t.notifications.filterAll},
      {'key': 'unread', 'label': t.notifications.filterUnread},
      {'key': 'warning', 'label': t.notifications.filterWarnings},
      {'key': 'success', 'label': t.notifications.filterSuccess},
      {'key': 'info', 'label': 'Info'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
        horizontal: r.space(AppSpacing.lg),
        vertical: r.space(AppSpacing.xs),
      ),
      child: Row(
        children: filters.map((f) {
          final isSelected = _currentFilter == f['key'];
          return GestureDetector(
            onTap: () => setState(() => _currentFilter = f['key'] as String),
            child: Container(
              margin: EdgeInsets.only(right: r.space(AppSpacing.xs)),
              padding: EdgeInsets.symmetric(
                horizontal: r.space(AppSpacing.md),
                vertical: r.space(AppSpacing.xs),
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.orangePrimary.withValues(alpha: 0.12) : AppColors.surface,
                borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
                border: Border.all(
                  color: isSelected ? AppColors.orangePrimary.withValues(alpha: 0.35) : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    f['label'] as String,
                    style: AppTextStyles.bodySmall(context).copyWith(
                      color: isSelected ? AppColors.orangePrimary : AppColors.textMuted,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
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
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(AppResponsive r) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(r.space(AppSpacing.lg)),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(r.r(AppRadius.xxl)),
            ),
            child: Icon(Icons.notifications_off_outlined, size: AppIconSizes.massive(context), color: AppColors.textDim),
          ),
          SizedBox(height: r.space(AppSpacing.md)),
          Text(
            Translations.of(context).notifications.emptyTitle,
            style: AppTextStyles.button(context).copyWith(
              color: Colors.white,
            ),
          ),
          SizedBox(height: r.space(AppSpacing.xxs)),
          Text(
            Translations.of(context).notifications.emptySubtitle,
            style: AppTextStyles.bodySmall(context).copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(AppResponsive r) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(r.space(AppSpacing.lg)),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(r.r(AppRadius.xxl)),
            ),
            child: Icon(Icons.cloud_off_rounded, size: AppIconSizes.massive(context), color: AppColors.textDim),
          ),
          SizedBox(height: r.space(AppSpacing.md)),
          Text(
            'Error al cargar notificaciones',
            style: AppTextStyles.button(context).copyWith(color: Colors.white),
          ),
          SizedBox(height: r.space(AppSpacing.lg)),
          FilledButton.icon(
            onPressed: () => ref.read(notificationsProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Reintentar'),
            style: FilledButton.styleFrom(backgroundColor: AppColors.orangePrimary),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationEntity notif;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationCard({
    required this.notif,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    final cfg = _getTypeConfig(notif.type, context);

    // Wrap unread cards with a left accent strip — mobile pattern, no full border
    Widget card = Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: !notif.isRead
            ? Border(
                left: BorderSide(color: cfg.accent, width: 3),
              )
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
                  child: Icon(cfg.icon, color: cfg.accent, size: AppIconSizes.md(context)),
                ),
                SizedBox(width: r.space(AppSpacing.s)),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title only — icon color already communicates type
                      Text(
                        notif.title,
                        style: AppTextStyles.bodyMedium(context).copyWith(
                          color: Colors.white,
                          fontWeight: notif.isRead ? FontWeight.w500 : FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: r.space(3)),
                      Text(
                        notif.message,
                        style: AppTextStyles.caption(context).copyWith(
                          color: AppColors.textMuted,
                          height: 1.4,
                        ),
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
                                _formatTimestamp(notif.createdAt),
                                style: AppTextStyles.label(context).copyWith(
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: onDelete,
                            child: Container(
                              width: r.dim(26),
                              height: r.dim(26),
                              decoration: BoxDecoration(
                                color: AppColors.red.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(r.r(8)),
                              ),
                              child: Icon(Icons.delete_outline, color: AppColors.red, size: AppIconSizes.xs(context)),
                            ),
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

    return GestureDetector(
      onTap: onTap,
      child: card,
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours}h';
    if (diff.inDays < 7) return 'Hace ${diff.inDays}d';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }

  _TypeConfig _getTypeConfig(NotificationType type, BuildContext context) {
    final t = Translations.of(context);
    switch (type) {
      case NotificationType.warning:
        return _TypeConfig(Icons.warning_amber_rounded, AppColors.orangeSecondary, t.notifications.typeWarning);
      case NotificationType.success:
        return _TypeConfig(Icons.check_circle_outline_rounded, AppColors.green, t.notifications.typeSuccess);
      case NotificationType.info:
        return _TypeConfig(Icons.info_outline_rounded, AppColors.accent, t.notifications.typeInfo);
      case NotificationType.error:
        return _TypeConfig(Icons.error_outline_rounded, AppColors.red, 'Error');
      case NotificationType.weather:
        return _TypeConfig(Icons.thermostat_rounded, AppColors.cyan, t.notifications.typeInfo);
    }
  }
}

class _TypeConfig {
  final IconData icon;
  final Color accent;
  final String label;

  _TypeConfig(this.icon, this.accent, this.label);
}
