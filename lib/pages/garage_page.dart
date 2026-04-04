import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../providers/auth_provider.dart';
import '../viewmodels/vehicle_view_model.dart';
import '../widgets/garage/add_vehicle_sheet.dart';
import '../widgets/garage/vehicle_detail_sheet.dart';
import '../widgets/maintenance/add_service_sheet.dart';
import '../widgets/ui/premium_fab.dart';
import '../models/vehicle_model.dart';
import '../models/maintenance_model.dart';
import '../widgets/ui/confirmation_dialog.dart';
import '../core/i18n/translations.g.dart';
import '../core/responsive/responsive.dart';
import '../theme/app_color_scheme.dart';

// Modular Widgets
import '../widgets/garage/garage_header.dart';
import '../widgets/garage/garage_stats.dart';
import '../widgets/garage/garage_empty_state.dart';
import '../widgets/garage/vehicle_card.dart';
import '../widgets/garage/vehicle_card_skeleton.dart';
import '../widgets/garage/weather_widget.dart';

class GaragePage extends ConsumerStatefulWidget {
  const GaragePage({super.key});

  @override
  ConsumerState<GaragePage> createState() => _GaragePageState();
}

class _GaragePageState extends ConsumerState<GaragePage> {
  late ScrollController _scrollController;
  bool _isFabExtended = true;
  int? _selectedVehicleId;
  bool _sheetExpanded = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        if (_scrollController.offset > 50 && _isFabExtended) {
          setState(() => _isFabExtended = false);
        } else if (_scrollController.offset <= 50 && !_isFabExtended) {
          setState(() => _isFabExtended = true);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleAddVehicle(Map<String, dynamic> data) async {
    try {
      final userId = ref.read(authProvider)?.id ?? 1;

      final newVehicleData = {
        'user_id': userId,
        'type_id': data['type_id'],
        'brand': data['brand'] ?? 'Unknown',
        'model': data['model'] ?? 'Unknown',
        'plate': data['plate'] ?? 'UNKNOWN',
        'year': data['year'],
        'mileage': data['mileage'] ?? 0,
      };

      await ref.read(vehiclesProvider.notifier).addVehicle(newVehicleData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Translations.of(context).garage.vehicleAdded),
            backgroundColor: AppColors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${Translations.of(context).garage.errorAddingVehicle.replaceAll('{error}', '$e')}',
            ),
            backgroundColor: AppColors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showAddVehicleSheet({Vehicle? initialVehicle}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddVehicleSheet(
        onSave: (data) {
          if (initialVehicle != null) {
            return _handleEditVehicle(initialVehicle.id, data);
          } else {
            return _handleAddVehicle(data);
          }
        },
        initialVehicle: initialVehicle,
      ),
    );
  }

  Future<void> _handleEditVehicle(int id, Map<String, dynamic> data) async {
    try {
      await ref.read(vehiclesProvider.notifier).updateVehicle(id, data);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Translations.of(context).garage.vehicleUpdated),
            backgroundColor: AppColors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${Translations.of(context).garage.errorUpdatingVehicle.replaceAll('{error}', '$e')}',
            ),
            backgroundColor: AppColors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      rethrow;
    }
  }

  void _handleLogService(Vehicle vehicle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddServiceSheet(
        vehicles: [vehicle],
        onSave: (data) async {
          final repository = ref.read(maintenanceRepositoryProvider);
          final params = MaintenanceParams(vehicleId: vehicle.id);

          final recordData = {
            'vehicle_id': vehicle.id,
            'date': data['date'] as String,
            'description':
                data['notes'] != null && data['notes'].toString().isNotEmpty
                ? '${data['description']} | ${data['notes']}'
                : data['description'],
            'cost': data['cost'].toString(),
            'mileage': data['mileage'],
            'category': data['category'],
          };

          final newRecord = await repository.addMaintenanceRecord(recordData);
          ref.read(maintenanceDocsProvider(params).notifier).updateLocal(newRecord);
          ref.read(maintenanceDocsProvider(const MaintenanceParams()).notifier).updateLocal(newRecord);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  Translations.of(context).garage.serviceLogged.replaceAll(
                    '{vehicleName}',
                    vehicle.displayName,
                  ),
                ),
                backgroundColor: AppColors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }

  void _showEditServiceSheet(Vehicle vehicle, Maintenance maintenance) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddServiceSheet(
        vehicles: [vehicle],
        initialMaintenance: maintenance,
        onSave: (data) async {
          final repository = ref.read(maintenanceRepositoryProvider);
          final params = MaintenanceParams(vehicleId: vehicle.id);

          final recordData = {
            'vehicle_id': vehicle.id,
            'date': data['date'] as String,
            'description':
                data['notes'] != null && data['notes'].toString().isNotEmpty
                ? '${data['description']} | ${data['notes']}'
                : data['description'],
            'cost': data['cost'].toString(),
            'mileage': data['mileage'],
            'category': data['category'],
          };

          final updatedRecord = await repository.updateMaintenanceRecord(maintenance.id, recordData);
          ref.read(maintenanceDocsProvider(params).notifier).updateLocal(updatedRecord);
          ref.read(maintenanceDocsProvider(const MaintenanceParams()).notifier).updateLocal(updatedRecord);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  Translations.of(context).garage.serviceRecordUpdated,
                ),
                backgroundColor: AppColors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }

  void _handleRemoveVehicle(int vehicleId, String vehicleName) {
    ConfirmationDialog.show(
      context,
      title: Translations.of(context).garage.removeVehicleTitle,
      message: Translations.of(
        context,
      ).garage.removeVehicleMessage.replaceAll('{vehicleName}', vehicleName),
      onConfirm: () async {
        try {
          await ref.read(vehiclesProvider.notifier).deleteVehicle(vehicleId);

          setState(() {
            _selectedVehicleId = null;
            _sheetExpanded = false;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(Translations.of(context).garage.vehicleRemoved),
                backgroundColor: AppColors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${Translations.of(context).garage.errorRemovingVehicle.replaceAll('{error}', '$e')}',
                ),
                backgroundColor: AppColors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehiclesAsyncValue = ref.watch(vehiclesProvider);
    final r = context.responsive;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: Stack(
        children: [
          vehiclesAsyncValue.when(
            data: (vehiclesList) => Stack(
              children: [
                Positioned.fill(
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + r.dim(80),
                          left: r.space(AppSpacing.lg),
                          right: r.space(AppSpacing.lg),
                          bottom: r.dim(120),
                        ),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: r.value(mobile: 600, tablet: 700),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    GarageStats(vehicles: vehiclesList),
                                    SizedBox(height: r.space(AppSpacing.xxl)),
                                    _buildVehiclesSection(vehiclesList, r),
                                    SizedBox(
                                      height: r.space(AppSpacing.massive),
                                    ),
                                    const WeatherWidget(),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: GarageHeader(
                    onNotificationTap: () =>
                        context.push('/notifications'),
                  ),
                ),
              ],
            ),
            loading: () => ListView.builder(
              padding: EdgeInsets.fromLTRB(
                r.space(AppSpacing.lg),
                r.dim(100),
                r.space(AppSpacing.lg),
                r.dim(100),
              ),
              itemCount: 3,
              itemBuilder: (context, _) => const VehicleCardSkeleton(),
            ),
            error: (err, stack) => _buildErrorState(r),
          ),
          if (_selectedVehicleId != null)
            _buildDetailSheetOverlay(vehiclesAsyncValue),
        ],
      ),
      floatingActionButton: _selectedVehicleId != null
          ? null
          : Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: r.value(mobile: 600, tablet: 700),
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: PremiumFAB(
                    onPressed: _showAddVehicleSheet,
                    label: Translations.of(context).garage.addVehicle,
                    icon: Icons.add,
                    isExtended: _isFabExtended,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildVehiclesSection(List<Vehicle> vehiclesList, AppResponsive r) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                Translations.of(context).garage.yourVehicles,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: context.colors.textMain,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildCountBadge(vehiclesList.length, r),
          ],
        ),
        SizedBox(height: r.space(AppSpacing.md)),
        if (vehiclesList.isEmpty)
          const GarageEmptyState()
        else
          // U1 fix: list generated without spread operator.
          // For potential large lists, consider migrating to SliverList.builder.
          ...List.generate(
            vehiclesList.length,
            (i) => VehicleCard(
              vehicleData: vehiclesList[i],
              onTap: () => setState(() {
                _selectedVehicleId = vehiclesList[i].id;
                _sheetExpanded = false;
              }),
            ),
          ),
      ],
    );
  }

  Widget _buildCountBadge(int count, AppResponsive r) {
    return Container(
      width: r.dim(28),
      height: r.dim(28),
      decoration: BoxDecoration(
        color: AppColors.cyan.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(r.r(AppRadius.s)),
      ),
      child: Center(
        child: Text(
          '$count',
          style: AppTextStyles.caption(
            context,
          ).copyWith(color: AppColors.cyan, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _buildErrorState(AppResponsive r) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: r.space(AppSpacing.lg)),
        padding: EdgeInsets.all(r.space(AppSpacing.xl)),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(r.r(AppRadius.xxl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(r.space(AppSpacing.lg)),
              decoration: BoxDecoration(
                color: AppColors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                size: AppIconSizes.massive(context),
                color: AppColors.red,
              ),
            ),
            SizedBox(height: r.space(AppSpacing.lg)),
            Text(
              Translations.of(context).garage.errorSyncFailed,
              style: AppTextStyles.sheetTitle(
                context,
              ).copyWith(color: Colors.white),
            ),
            SizedBox(height: r.space(AppSpacing.s)),
            Text(
              Translations.of(context).garage.errorSyncMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(
                context,
              ).copyWith(color: context.colors.textMuted, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  void _handleRemoveService(Vehicle vehicle, int serviceId) async {
    try {
      final repository = ref.read(maintenanceRepositoryProvider);
      await repository.deleteMaintenanceRecord(serviceId);

      ref.invalidate(maintenanceDocsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Translations.of(context).maintenance.serviceRemoved),
            backgroundColor: AppColors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${Translations.of(context).maintenance.errorRemovingService.replaceAll('{error}', '$e')}',
            ),
            backgroundColor: AppColors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildDetailSheetOverlay(
    AsyncValue<List<Vehicle>> vehiclesAsyncValue,
  ) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => setState(() {
            _selectedVehicleId = null;
            _sheetExpanded = false;
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            color: Colors.black.withValues(alpha: _sheetExpanded ? 0.6 : 0.3),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: vehiclesAsyncValue.maybeWhen(
            data: (vehicles) {
              final vId = _selectedVehicleId;
              if (vId == null) return const SizedBox.shrink();
              final vData = vehicles.firstWhere((v) => v.id == vId);
              return VehicleDetailSheet(
                vehicle: VehicleViewModel(vData),
                isExpanded: _sheetExpanded,
                onToggle: () =>
                    setState(() => _sheetExpanded = !_sheetExpanded),
                onClose: () => setState(() {
                  _selectedVehicleId = null;
                  _sheetExpanded = false;
                }),
                onLogService: () => _handleLogService(vData),
                onEdit: () => _showAddVehicleSheet(initialVehicle: vData),
                onRemove: () => _handleRemoveVehicle(vId, vData.displayName),
                onRemoveService: (id) => _handleRemoveService(vData, id),
                onEditService: (maintenance) =>
                    _showEditServiceSheet(vData, maintenance),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
