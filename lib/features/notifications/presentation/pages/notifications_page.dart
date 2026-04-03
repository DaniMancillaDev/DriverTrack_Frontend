/// Página principal de notificaciones.
///
/// Implementa:
/// - Lista con infinite scroll
/// - Pull to refresh
/// - Estados de carga, error y vacío
/// - Acción "Marcar todas como leídas"

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../theme/app_theme.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/i18n/translations.g.dart';
import '../providers/notifications_provider.dart';
import '../widgets/notification_tile.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(notificationsProvider.notifier).fetchMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    final t = Translations.of(context);
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          t.notifications.title,
          style: AppTextStyles.headline(context).copyWith(
            color: AppColors.textMain,
          ),
        ),
        actions: [
          // Botón marcar todas como leídas
          notificationsAsync.when(
            data: (state) {
              if (state.unreadCount > 0) {
                return TextButton.icon(
                  onPressed: () {
                    ref.read(notificationsProvider.notifier).markAllAsRead();
                  },
                  icon: Icon(
                    Icons.done_all_rounded,
                    size: AppIconSizes.sm(context),
                    color: AppColors.cyan,
                  ),
                  label: Text(
                    t.notifications.markAllReadButton,
                    style: AppTextStyles.caption(context).copyWith(
                      color: AppColors.cyan,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          SizedBox(width: r.space(AppSpacing.xs)),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => _buildLoadingState(context),
        error: (error, stack) => _buildErrorState(context),
        data: (state) {
          if (state.notifications.isEmpty) {
            return _buildEmptyState(context);
          }
          return _buildNotificationsList(context, state);
        },
      ),
    );
  }

  Widget _buildNotificationsList(
    BuildContext context,
    NotificationsState state,
  ) {
    final r = context.responsive;

    return RefreshIndicator(
      onRefresh: () => ref.read(notificationsProvider.notifier).refresh(),
      color: AppColors.orangePrimary,
      backgroundColor: AppColors.surface,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: r.space(AppSpacing.md),
          vertical: r.space(AppSpacing.xs),
        ),
        itemCount: state.notifications.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          // Loader al final para infinite scroll
          if (index == state.notifications.length) {
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

          final notification = state.notifications[index];
          return Padding(
            padding: EdgeInsets.only(bottom: r.space(AppSpacing.xs)),
            child: NotificationTile(
              notification: notification,
              onTap: () {
                if (!notification.isRead) {
                  ref
                      .read(notificationsProvider.notifier)
                      .markAsRead(notification.id);
                }
              },
              onDismiss: () {
                ref
                    .read(notificationsProvider.notifier)
                    .deleteNotification(notification.id);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.orangePrimary,
        strokeWidth: 2,
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final r = context.responsive;
    final t = Translations.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(r.space(AppSpacing.xl)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: AppIconSizes.massive(context),
              color: AppColors.textMuted,
            ),
            SizedBox(height: r.space(AppSpacing.md)),
            Text(
              t.notifications.errorLoading,
              style: AppTextStyles.title(context).copyWith(
                color: AppColors.textMain,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: r.space(AppSpacing.xs)),
            Text(
              t.notifications.errorHint,
              style: AppTextStyles.bodySmall(context).copyWith(
                color: AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: r.space(AppSpacing.lg)),
            FilledButton.icon(
              onPressed: () {
                ref.read(notificationsProvider.notifier).refresh();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: Text(t.notifications.retryButton),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.orangePrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final r = context.responsive;
    final t = Translations.of(context);

    return RefreshIndicator(
      onRefresh: () => ref.read(notificationsProvider.notifier).refresh(),
      color: AppColors.orangePrimary,
      backgroundColor: AppColors.surface,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: r.hp(25)),
          Icon(
            Icons.notifications_off_outlined,
            size: AppIconSizes.massive(context),
            color: AppColors.textDark,
          ),
          SizedBox(height: r.space(AppSpacing.md)),
          Text(
            t.notifications.emptyPageTitle,
            style: AppTextStyles.title(context).copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: r.space(AppSpacing.xs)),
          Text(
            t.notifications.emptyPageSubtitle,
            style: AppTextStyles.bodySmall(context).copyWith(
              color: AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
