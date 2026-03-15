import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/ui/custom_list_card.dart';

enum AlertType { warning, success, weather, info }

class NotificationModel {
  final String id;
  final AlertType type;
  final String title;
  final String body;
  final String time;
  bool read;
  final String? vehicle;
  final String? actionLabel;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    this.read = false,
    this.vehicle,
    this.actionLabel,
  });
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: "n1",
      type: AlertType.warning,
      title: "Oil change due soon",
      body: "Oil change due in 200 km on your Toyota Camry. Schedule service now to avoid engine wear.",
      time: "2 min ago",
      read: false,
      vehicle: "Toyota Camry",
      actionLabel: "Book Service",
    ),
    NotificationModel(
      id: "n2",
      type: AlertType.weather,
      title: "Heavy rain tomorrow",
      body: "Heavy rain forecast for tomorrow. Check your tires and windshield wipers before driving.",
      time: "1 hr ago",
      read: false,
      actionLabel: "View Forecast",
    ),
    NotificationModel(
      id: "n3",
      type: AlertType.success,
      title: "Monthly report ready",
      body: "Your February 2026 vehicle health report is ready. Total maintenance cost: \$89.99.",
      time: "3 hr ago",
      read: false,
      actionLabel: "View Report",
    ),
    NotificationModel(
      id: "n4",
      type: AlertType.warning,
      title: "Tire rotation overdue",
      body: "Ford Explorer tire rotation is 800 km overdue. Uneven wear may affect handling.",
      time: "Yesterday",
      read: true,
      vehicle: "Ford Explorer",
      actionLabel: "Schedule",
    ),
    NotificationModel(
      id: "n5",
      type: AlertType.success,
      title: "Service completed",
      body: "Air filter replacement on Honda CBR 600RR marked as complete. Great job keeping up!",
      time: "2 days ago",
      read: true,
      vehicle: "Honda CBR 600RR",
    ),
    NotificationModel(
      id: "n6",
      type: AlertType.info,
      title: "DriveTrack tip",
      body: "Regular coolant checks every 30,000 km extend your engine life by up to 40%.",
      time: "3 days ago",
      read: true,
    ),
    NotificationModel(
      id: "n7",
      type: AlertType.warning,
      title: "Battery health low",
      body: "Toyota Camry battery is showing signs of degradation. Cold weather may cause issues.",
      time: "4 days ago",
      read: true,
      vehicle: "Toyota Camry",
      actionLabel: "Check Battery",
    ),
    NotificationModel(
      id: "n8",
      type: AlertType.success,
      title: "Mileage milestone reached",
      body: "🎉 Your Honda CBR 600RR just hit 12,500 km. Time for a full inspection!",
      time: "1 week ago",
      read: true,
      vehicle: "Honda CBR 600RR",
    ),
  ];

  String _currentFilter = 'all';

  void _markAllRead() {
    setState(() {
      for (var n in _notifications) {
        n.read = true;
      }
    });
  }

  void _markRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index].read = true;
      }
    });
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((n) => n.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotifs = _notifications.where((n) {
      if (_currentFilter == 'unread') return !n.read;
      if (_currentFilter == 'warning') return n.type == AlertType.warning;
      if (_currentFilter == 'success') return n.type == AlertType.success;
      if (_currentFilter == 'weather') return n.type == AlertType.weather;
      return true;
    }).toList();

    final unreadCount = _notifications.where((n) => !n.read).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context, unreadCount, _notifications.length),
          _buildSummaryBar(),
          _buildFilterTabs(unreadCount),
          Expanded(
            child: filteredNotifs.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: filteredNotifs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final notif = filteredNotifs[index];
                      return _NotificationCard(
                        notif: notif,
                        onTap: () => _markRead(notif.id),
                        onDelete: () => _deleteNotification(notif.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int unread, int total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -1.5),
          radius: 1.5,
          colors: [
            AppColors.cyan.withOpacity(0.1),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, color: AppColors.textMuted, size: 18),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                  if (unread > 0)
                    Text(
                      '$unread unread · $total total',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                ],
              ),
            ],
          ),
          if (unread > 0)
            TextButton(
              onPressed: _markAllRead,
              style: TextButton.styleFrom(
                backgroundColor: AppColors.cyan.withOpacity(0.08),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: AppColors.cyan.withOpacity(0.2)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: const Text(
                'Mark all read',
                style: TextStyle(color: AppColors.cyan, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryBar() {
    final counts = [
      {'label': 'All', 'value': _notifications.length, 'color': AppColors.textMuted},
      {'label': 'Warnings', 'value': _notifications.where((n) => n.type == AlertType.warning).length, 'color': AppColors.orangeSecondary},
      {'label': 'Success', 'value': _notifications.where((n) => n.type == AlertType.success).length, 'color': AppColors.green},
      {'label': 'Weather', 'value': _notifications.where((n) => n.type == AlertType.weather).length, 'color': AppColors.cyan},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: counts.map((c) {
            return Column(
              children: [
                Text(
                  '${c['value']}',
                  style: TextStyle(color: c['color'] as Color, fontSize: 17, fontWeight: FontWeight.w800),
                ),
                Text(
                  c['label'] as String,
                  style: const TextStyle(color: AppColors.textDim, fontSize: 9, fontWeight: FontWeight.w500),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFilterTabs(int unread) {
    final filters = [
      {'key': 'all', 'label': 'All'},
      {'key': 'unread', 'label': 'Unread'},
      {'key': 'warning', 'label': 'Warnings'},
      {'key': 'success', 'label': 'Success'},
      {'key': 'weather', 'label': 'Weather'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: filters.map((f) {
          final isSelected = _currentFilter == f['key'];
          return GestureDetector(
            onTap: () => setState(() => _currentFilter = f['key'] as String),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.orangePrimary.withOpacity(0.12) : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.orangePrimary.withOpacity(0.35) : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    f['label'] as String,
                    style: TextStyle(
                      color: isSelected ? AppColors.orangePrimary : AppColors.textMuted,
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                  if (f['key'] == 'unread' && unread > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.orangePrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$unread',
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Icon(Icons.notifications_off_outlined, size: 48, color: AppColors.textDim),
          ),
          const SizedBox(height: 16),
          const Text(
            'All caught up!',
            style: TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            'No notifications in this category',
            style: TextStyle(color: AppColors.textDim, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notif;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationCard({
    required this.notif,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cfg = _getTypeConfig(notif.type);

    return CustomListCard(
      onTap: onTap,
      isSelected: !notif.read,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: cfg.accent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cfg.accent.withOpacity(0.18), width: 1.5),
                  ),
                  child: Icon(cfg.icon, color: cfg.accent, size: 20),
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: cfg.accent.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              cfg.label.toUpperCase(),
                              style: TextStyle(
                                color: cfg.accent,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          if (notif.vehicle != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              notif.vehicle!,
                              style: const TextStyle(color: AppColors.textDim, fontSize: 10),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notif.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: notif.read ? FontWeight.w500 : FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notif.body,
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 12, height: 1.5),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notif.time,
                            style: const TextStyle(color: AppColors.textDim, fontSize: 11),
                          ),
                          Row(
                            children: [
                              if (notif.actionLabel != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: cfg.accent.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: cfg.accent.withOpacity(0.18)),
                                  ),
                                  child: Text(
                                    notif.actionLabel!,
                                    style: TextStyle(color: cfg.accent, fontSize: 11, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: onDelete,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: AppColors.red.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.delete_outline, color: AppColors.red, size: 14),
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
          if (!notif.read)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: cfg.accent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: cfg.accent,
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  _TypeConfig _getTypeConfig(AlertType type) {
    switch (type) {
      case AlertType.warning:
        return _TypeConfig(Icons.warning_amber_rounded, AppColors.orangeSecondary, 'Warning');
      case AlertType.success:
        return _TypeConfig(Icons.check_circle_outline_rounded, AppColors.green, 'Success');
      case AlertType.weather:
        return _TypeConfig(Icons.cloud_outlined, AppColors.cyan, 'Weather');
      case AlertType.info:
        return _TypeConfig(Icons.info_outline_rounded, AppColors.accent, 'Info');
    }
  }
}

class _TypeConfig {
  final IconData icon;
  final Color accent;
  final String label;

  _TypeConfig(this.icon, this.accent, this.label);
}
