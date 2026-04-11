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
import '../../theme/app_color_scheme.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/responsive/responsive.dart';

/// Orquestador visual del perfil detallado de un vehículo.
/// 
/// Consolida estados de salud, estadísticas financieras de mantenimiento y el 
/// historial cronológico de servicios. Permite realizar acciones de gestión 
/// como editar el vehículo, marcarlo como favorito o actualizar su fotografía.
class VehicleDetailSheet extends ConsumerStatefulWidget {
  /// ViewModel que encapsula la lógica de presentación del vehículo.
  final VehicleViewModel vehicle;
  /// Callback para cerrar la hoja detallada.
  final VoidCallback onClose;
  /// Callback opcional para navegar al formulario de nuevo servicio.
  final VoidCallback? onLogService;
  /// Callback opcional para editar los datos básicos del vehículo.
  final VoidCallback? onEdit;
  /// Callback opcional para eliminar el vehículo de la flota.
  final VoidCallback? onRemove;
  /// Callback para eliminar un registro de mantenimiento específico.
  final Function(int)? onRemoveService;
  /// Callback para editar un registro de mantenimiento existente.
  final Function(Maintenance)? onEditService;

  const VehicleDetailSheet({
    super.key,
    required this.vehicle,
    required this.onClose,
    this.onLogService,
    this.onEdit,
    this.onRemove,
    this.onRemoveService,
    this.onEditService,
  });

  @override
  ConsumerState<VehicleDetailSheet> createState() => _VehicleDetailSheetState();
}

class _VehicleDetailSheetState extends ConsumerState<VehicleDetailSheet> {
  int? _selectedServiceId;
  bool _serviceDetailExpanded = false;
  bool _isUploading = false;

  void _showPhotoSourcePicker() {
    final t = Translations.of(context);
    final r = context.responsive;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.all(r.space(AppSpacing.lg)),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(r.r(AppRadius.xl)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: r.dim(40),
              height: r.dim(4),
              margin: EdgeInsets.only(bottom: r.space(AppSpacing.md)),
              decoration: BoxDecoration(
                color: context.colors.borderLight,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
            Text(
              t.profile.changePhoto,
              style: AppTextStyles.headline(context).copyWith(
                color: context.colors.textMain,
                fontSize: r.sp(18),
              ),
            ),
            SizedBox(height: r.space(AppSpacing.lg)),
            _buildSourceOption(
              icon: Icons.camera_alt,
              label: t.profile.camera,
              color: AppColors.orangePrimary,
              onTap: () {
                Navigator.pop(ctx);
                _uploadPhoto(ImageSource.camera);
              },
            ),
            SizedBox(height: r.space(AppSpacing.s)),
            _buildSourceOption(
              icon: Icons.photo_library,
              label: t.profile.gallery,
              color: AppColors.cyan,
              onTap: () {
                Navigator.pop(ctx);
                _uploadPhoto(ImageSource.gallery);
              },
            ),
            SizedBox(height: r.space(AppSpacing.md)),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final r = context.responsive;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: r.space(AppSpacing.md),
            vertical: r.space(AppSpacing.s),
          ),
          decoration: BoxDecoration(
            color: context.colors.surfaceLight,
            borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
          ),
          child: Row(
            children: [
              Container(
                width: r.dim(42),
                height: r.dim(42),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(r.r(AppRadius.s)),
                ),
                child: Icon(icon, color: color, size: AppIconSizes.md(context)),
              ),
              SizedBox(width: r.space(AppSpacing.md)),
              Text(
                label,
                style: AppTextStyles.bodyMedium(context).copyWith(
                  color: context.colors.textMain,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right,
                color: context.colors.textMuted,
                size: AppIconSizes.sm(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _uploadPhoto(ImageSource source) async {
    if (_isUploading) return;
    setState(() => _isUploading = true);

    try {
      final service = ref.read(vehiclePhotoUploadProvider);
      final updatedVehicle = await service.pickAndUpload(
        vehicleId: widget.vehicle.id,
        source: source,
      );

      if (updatedVehicle != null && mounted) {
        // Actualizamos localmente para no hacer full refresh del garaje entero
        ref.read(vehiclesProvider.notifier).updateVehicleLocally(updatedVehicle);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Translations.of(context).profile.editProfileSuccess),
            backgroundColor: AppColors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch for maintenance records for this specific vehicle
    final maintenanceAsync = ref.watch(
      maintenanceDocsProvider(MaintenanceParams(vehicleId: widget.vehicle.id)),
    );

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

        // Obtener el vehículo más actualizado desde vehiclesProvider para reflejar subida de foto sin cerrar el sheet
        final vehiclesState = ref.watch(vehiclesProvider).value ?? [];
        final latestCoreVehicle = vehiclesState.firstWhere(
          (v) => v.id == widget.vehicle.id,
          orElse: () => widget.vehicle.vehicle,
        );

        // Create a synchronized ViewModel with the real mileage
        final syncedVehicle = VehicleViewModel(
          latestCoreVehicle,
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
      showDragHandle: true,
      onClose: widget.onClose,
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SheetHeader(
                        title: vehicle.displayName,
                        subtitle:
                            '${(vehicle.typeIcon == Icons.motorcycle || vehicle.typeIcon == Icons.motorcycle ? Translations.of(context).garage.vehicleTypes.motorcycle : Translations.of(context).garage.vehicleTypes.car).toUpperCase()} • ${vehicle.plate}',
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
              onClose: () => setState(() => _selectedServiceId = null),
              onEdit: () => widget.onEditService?.call(vm.maintenance),
              onRemove: () {
                ConfirmationDialog.show(
                  context,
                  title: Translations.of(context).garage.deleteServiceTitle,
                  message: Translations.of(
                    context,
                  ).garage.deleteServiceMessage.replaceAll('{title}', vm.title),
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

  Widget _buildTrailingActions(
    VehicleViewModel vehicle, {
    bool isOverlay = false,
  }) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') {
          widget.onEdit?.call();
        } else if (value == 'remove') {
          ConfirmationDialog.show(
            context,
            title: Translations.of(context).garage.removeVehicle,
            message: Translations.of(context).garage.removeVehicleMessage
                .replaceAll('{vehicleName}', vehicle.displayName),
            onConfirm: () => widget.onRemove?.call(),
          );
        }
      },
      color: context.colors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      icon: Icon(
        Icons.more_vert,
        color: isOverlay ? Colors.white : context.colors.textMuted,
        size: isOverlay ? 20 : 24,
      ),
      itemBuilder: (context) => [
        if (widget.onEdit != null)
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(
                  Icons.edit,
                  size: 18,
                  color: context.colors.textSecondary,
                ),
                SizedBox(width: AppSpacing.md),
                Text(
                  Translations.of(context).garage.editVehicle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: context.colors.textMain),
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
                  Icons.delete_outline,
                  size: 18,
                  color: AppColors.red,
                ),
                SizedBox(width: AppSpacing.md),
                Text(
                  Translations.of(context).garage.removeVehicle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.red),
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
      borderRadius: BorderRadius.circular(
        AppRadius.xl,
      ), // Updated to xl for consistency
      child: Stack(
        children: [
          vehicle.displayImageUrl.startsWith('http')
              ? Image.network(
                  vehicle.displayImageUrl,
                  height: 220, // Increased height for better hero presence
                  width: double.infinity,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0.0, -0.6), // Encuadre ligeramente hacia arriba para ilustraciones
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 220,
                    width: double.infinity,
                    color: context.colors.surfaceLight,
                    child: Icon(
                      vehicle.typeIcon,
                      size: 64,
                      color: context.colors.borderLight,
                    ),
                  ),
                )
              : Image.asset(
                  vehicle.displayImageUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0.0, -0.6),
                ),
          // Loading overlay si está subiendo
          if (_isUploading)
            Container(
              height: 220,
              width: double.infinity,
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.orangePrimary),
              ),
            ),
          // Gradient: subtle bottom-only fade for readability
          Container(
            height: 220,
            width: double.infinity,
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
          // Edit Photo Button (Center overlay)
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _showPhotoSourcePicker,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white.withValues(alpha: 0.8),
                      size: 28,
                    ),
                  ),
                ),
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
                    if (vehicle.isFavorite) {
                      final notifier = ref.read(vehiclesProvider.notifier);
                      await notifier.toggleFavorite(vehicle.id, false);
                      return;
                    }
                    final currentFavs = ref.read(vehiclesProvider).value
                            ?.where((v) => v.isFavorite).length ??
                        0;
                    if (currentFavs >= VehiclesNotifier.maxFavorites) {
                      if (mounted) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: context.colors.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.xl),
                            ),
                            icon: Icon(
                              Icons.favorite_border,
                              color: AppColors.orangeSecondary,
                              size: 36,
                            ),
                            title: Text(
                              'Límite de favoritos',
                              style: AppTextStyles.sheetTitle(context),
                              textAlign: TextAlign.center,
                            ),
                            content: Text(
                              'Ya tienes ${VehiclesNotifier.maxFavorites} favoritos guardados. Quita uno para poder agregar este vehículo.',
                              style: AppTextStyles.bodySmall(context).copyWith(
                                color: context.colors.textMuted,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.orangePrimary,
                                  textStyle: AppTextStyles.bodyMedium(context).copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                child: const Text('Entendido'),
                              ),
                            ],
                          ),
                        );
                      }
                      return;

                    }
                    final notifier = ref.read(vehiclesProvider.notifier);
                    await notifier.toggleFavorite(vehicle.id, true);
                  },
                  child: Opacity(
                    opacity: () {
                      if (vehicle.isFavorite) return 1.0;
                      final favs = ref.watch(vehiclesProvider).value
                              ?.where((v) => v.isFavorite).length ??
                          0;
                      return favs >= VehiclesNotifier.maxFavorites ? 0.4 : 1.0;
                    }(),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Icon(
                        vehicle.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: vehicle.isFavorite ? AppColors.red : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                if (widget.onEdit != null || widget.onRemove != null) ...[
                  const SizedBox(width: AppSpacing.s),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: _buildTrailingActions(vehicle, isOverlay: true),
                  ),
                ],
              ],
            ),
          ),
          // Bottom Left: Health Pill
          Positioned(
            bottom: AppSpacing.md,
            left: AppSpacing.md,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s,
                vertical: 6,
              ),
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
                      color: context.colors.textMain,
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
                color: context.colors.textMuted,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            if (records.isNotEmpty)
              Text(
                Translations.of(context).garage.recordsCount(n: records.length).replaceAll('{count}', records.length.toString()),
                style: TextStyle(
                  color: context.colors.textMain,
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
              DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(vm.date),
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
            Icons.history,
            size: 40,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            Translations.of(context).garage.noRecordsFound,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: context.colors.textMain,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            Translations.of(context).garage.noRecordsMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.colors.textMuted,
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
            color: context.colors.surface,
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
                        color: context.colors.textMain,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      date,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.colors.textMuted,
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
