import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/vehicle_view_model.dart';
import '../../providers/app_providers.dart';
import '../../viewmodels/maintenance_view_model.dart';
import '../ui/summary_stats.dart';
import '../ui/sheet_container.dart';
import '../ui/sheet_header.dart';
import '../maintenance/service_detail_sheet.dart';
import '../ui/confirmation_dialog.dart';
import '../../models/maintenance_model.dart';
import '../../core/i18n/translations.g.dart';
import '../../features/currency/presentation/widgets/currency_display.dart';

class VehicleDetailSheet extends ConsumerStatefulWidget {
  final VehicleViewModel vehicle;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onClose;
  final VoidCallback? onLogService;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;
  final Function(int)? onRemoveService;
  final Function(Maintenance)? onEditService; // Added

  const VehicleDetailSheet({
    super.key,
    required this.vehicle,
    required this.isExpanded,
    required this.onToggle,
    required this.onClose,
    this.onLogService,
    this.onEdit,
    this.onRemove,
    this.onRemoveService,
    this.onEditService, // Added
  });

  @override
  ConsumerState<VehicleDetailSheet> createState() => _VehicleDetailSheetState();
}

class _VehicleDetailSheetState extends ConsumerState<VehicleDetailSheet> {
  int? _selectedServiceId;
  bool _serviceDetailExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Watch for maintenance records for this specific vehicle
    final maintenanceAsync = ref.watch(maintenanceDocsProvider(
      MaintenanceParams(vehicleId: widget.vehicle.id),
    ));

    return maintenanceAsync.maybeWhen(
      data: (records) {
        // Calculate "Real Mileage" based on history
        int realMileage = widget.vehicle.mileage;
        if (records.isNotEmpty) {
          final maxRecorded = records
              .map((r) => r.mileage)
              .reduce((a, b) => a > b ? a : b);
          if (maxRecorded > realMileage) {
            realMileage = maxRecorded;
          }
        }

        // Create a synchronized ViewModel with the real mileage
        final syncedVehicle = VehicleViewModel(
          widget.vehicle.vehicle,
          realMileage,
        );
        return _buildSheet(context, syncedVehicle, records);
      },
      orElse: () => _buildSheet(context, widget.vehicle, []),
    );
  }

  Widget _buildSheet(
    BuildContext context,
    VehicleViewModel vehicle,
    List<dynamic> records,
  ) {
    final Color accentColor = vehicle.statusColor;
    final double healthPct = vehicle.healthPercentage;
    final List<MaintenanceViewModel> maintenanceViewModels = records
        .map((r) => MaintenanceViewModel(r))
        .toList();

    return SheetContainer(
      height: widget.isExpanded
          ? MediaQuery.of(context).size.height * 0.85
          : 420,
      showDragHandle: false,
      child: Stack(
        children: [
          Column(
            children: [
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy < -10 && !widget.isExpanded) {
                    widget.onToggle();
                  }
                  if (details.delta.dy > 10 && widget.isExpanded) {
                    widget.onToggle();
                  }
                },
                onTap: widget.onToggle,
                child: _buildHandle(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.xl,
                  ),
                  physics: widget.isExpanded
                      ? const BouncingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SheetHeader(
                        title: vehicle.displayName,
                        subtitle:
                            '${(vehicle.type.toLowerCase().contains('moto') ? Translations.of(context).garage.vehicleTypes.motorcycle : (vehicle.type.toLowerCase().contains('car') ? Translations.of(context).garage.vehicleTypes.car : vehicle.type)).toUpperCase()} • ${vehicle.plate}',
                        onClose: widget.onClose,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildHeroImage(vehicle, healthPct, accentColor),
                      const SizedBox(height: AppSpacing.xl),
                      _buildStatsSection(accentColor, maintenanceViewModels),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildMaintenanceSection(maintenanceViewModels),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_selectedServiceId != null)
            _buildServiceDetailOverlay(vehicle, maintenanceViewModels),
        ],
      ),
    );
  }

  Widget _buildServiceDetailOverlay(
    VehicleViewModel vehicle,
    List<MaintenanceViewModel> records,
  ) {
    final vm = records.firstWhere((r) => r.id == _selectedServiceId);

    return Positioned.fill(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => setState(() => _selectedServiceId = null),
            child: Container(color: Colors.black.withValues(alpha: 0.6)),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ServiceDetailSheet(
              serviceTitle: vm.title,
              vehicleName: vehicle.displayName,
              date: vm.date,
              cost: vm.cost,
              mileage: vm.mileage,
              accentColor: vm.computedAccent,
              category: vm.category,
              notes: vm.notes,
              isExpanded: _serviceDetailExpanded,
              onToggle: () => setState(
                () => _serviceDetailExpanded = !_serviceDetailExpanded,
              ),
              onClose: () => setState(() => _selectedServiceId = null),
              onEdit: () => widget.onEditService?.call(vm.maintenance),
              onRemove: () {
                ConfirmationDialog.show(
                  context,
                  title: Translations.of(context).garage.deleteServiceTitle,
                  message:
                      Translations.of(context).garage.deleteServiceMessage.replaceAll('{title}', vm.title),
                  onConfirm: () {
                    final id = vm.id;
                    setState(() => _selectedServiceId = null);
                    widget.onRemoveService?.call(id);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      child: Center(
        child: Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
        ),
      ),
    );
  }

  Widget _buildTrailingActions(VehicleViewModel vehicle, {bool isOverlay = false}) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') {
          widget.onEdit?.call();
        } else if (value == 'remove') {
          ConfirmationDialog.show(
            context,
            title: Translations.of(context).garage.removeVehicle,
            message:
                Translations.of(context).garage.removeVehicleMessage.replaceAll('{vehicleName}', vehicle.displayName),
            onConfirm: () => widget.onRemove?.call(),
          );
        }
      },
      color: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      icon: Icon(
        Icons.more_vert_rounded, 
        color: isOverlay ? Colors.white : AppColors.textMuted,
        size: isOverlay ? 20 : 24,
      ),
      itemBuilder: (context) => [
        if (widget.onEdit != null)
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: AppSpacing.md),
                Text(
                  Translations.of(context).garage.editVehicle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
        if (widget.onRemove != null)
          PopupMenuItem(
            value: 'remove',
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: AppColors.red,
                ),
                SizedBox(width: AppSpacing.md),
                Text(
                  Translations.of(context).garage.removeVehicle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.red,
                      ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildHeroImage(
    VehicleViewModel vehicle,
    double healthPct,
    Color accent,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xl), // Updated to xl for consistency
      child: Stack(
        children: [
          Image.network(
            vehicle.displayImageUrl,
            height: 220, // Increased height for better hero presence
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 220,
              color: AppColors.surfaceLight,
              child: Icon(
                vehicle.type.toLowerCase().contains('moto') ? Icons.motorcycle : Icons.directions_car,
                size: 64, color: AppColors.borderLight,
              ),
            ),
          ),
          // Gradient: subtle bottom-only fade for readability
          Container(
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.65),
                ],
              ),
            ),
          ),
          // Top Right: Floating Actions (Favorite & More)
          Positioned(
            top: AppSpacing.md,
            right: AppSpacing.md,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final notifier = ref.read(vehiclesProvider.notifier);
                    await notifier.toggleFavorite(vehicle.id, !vehicle.isFavorite);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3), // Glassy feel
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Icon(
                      vehicle.isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                      color: vehicle.isFavorite ? AppColors.red : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                if (widget.onEdit != null || widget.onRemove != null) ...[
                  const SizedBox(width: AppSpacing.s),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    // Use a wrapper to prevent the native PopupMenu from breaking the circular shape visually
                    child: _buildTrailingActions(vehicle, isOverlay: true),
                  )
                ],
              ],
            ),
          ),
          // Bottom Left: Health Pill
          Positioned(
            bottom: AppSpacing.md,
            left: AppSpacing.md,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(vehicle.statusIcon, color: accent, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '${healthPct.round()}%',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
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

  Widget _buildStatsSection(Color accent, List<MaintenanceViewModel> records) {
    final double totalSpent = records.fold(0, (sum, vm) => sum + vm.cost);
    final int servicesCount = records.length;
    String lastServiceText = Translations.of(context).common.none;

    if (records.isNotEmpty) {
      lastServiceText = records.first.getTimeAgo(Translations.of(context));
    }

    final stats = [
      StatItem(
        label: Translations.of(context).garage.totalSpent,
        customValue: CurrencyDisplay(
          amount: totalSpent,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.green,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            fontSize: 22,
          ),
        ),
        accent: AppColors.green,
      ),
      StatItem(
        label: Translations.of(context).garage.services,
        value: servicesCount.toString(),
        accent: AppColors.orangePrimary,
      ),
      StatItem(
        label: Translations.of(context).garage.recentServiceLabel,
        value: lastServiceText,
        accent: AppColors.cyan,
      ),
    ];

    return SummaryStats(stats: stats);
  }

  Widget _buildMaintenanceSection(List<MaintenanceViewModel> records) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Translations.of(context).garage.recentMaintenance,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
            ),
            if (records.isNotEmpty)
              Text(
                Translations.of(context).garage.recordsCount(n: records.length),
                style: const TextStyle(
                  color: AppColors.textMain,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (records.isEmpty)
          _buildEmptyHistory()
        else
          ...records.take(5).map((vm) {
            return _buildHistoryItem(
              vm.title,
              DateFormat('dd MMM yyyy').format(vm.date),
              vm.cost,
              vm.computedIcon,
              vm.computedAccent,
              onTap: () => setState(() {
                _selectedServiceId = vm.id;
                _serviceDetailExpanded = false;
              }),
            );
          }),
      ],
    );
  }

  Widget _buildEmptyHistory() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxl,
        horizontal: AppSpacing.lg,
      ),
      child: Column(
        children: [
          Icon(
            Icons.history_outlined,
            size: 40,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            Translations.of(context).garage.noRecordsFound,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            Translations.of(context).garage.noRecordsMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
    String title,
    String date,
    double costValue,
    IconData icon,
    Color accent, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, color: accent, size: 18),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      date,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              costValue > 0
                  ? CurrencyDisplay(
                      amount: costValue,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: accent,
                            fontWeight: FontWeight.w700,
                          ),
                    )
                  : Text(
                      Translations.of(context).common.free,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: accent,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
