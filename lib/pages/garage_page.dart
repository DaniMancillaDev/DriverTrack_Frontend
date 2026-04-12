import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../providers/auth_provider.dart';
import '../core/network/api_client.dart';
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

// Widgets modulares
import '../widgets/garage/garage_header.dart';
import '../widgets/garage/garage_stats.dart';
import '../widgets/garage/garage_empty_state.dart';
import '../widgets/garage/vehicle_card.dart';
import '../widgets/garage/vehicle_card_skeleton.dart';
import '../widgets/garage/weather_widget.dart';
import '../widgets/ui/sliver_header_delegate.dart';

/// Página principal del "Garaje" (Dashboard).
/// 
/// Actúa como el núcleo de la aplicación, centralizando la supervisión de 
/// la flota. Sus responsabilidades incluyen:
/// * **Visualización de Estatus**: Presenta métricas de salud y rendimiento 
///   de todos los vehículos mediante [GarageStats].
/// * **Gestión de Activos**: Permite el registro, edición y baja de vehículos.
/// * **Contexto Ambiental**: Integra alerts meteorológicos en tiempo real 
///   relevantes para la conducción.
/// * **Navegación Táctica**: Provee acceso inmediato a notificaciones y al 
///   registro rápido de mantenimientos.
class GaragePage extends ConsumerStatefulWidget {
  const GaragePage({super.key});

  @override
  ConsumerState<GaragePage> createState() => _GaragePageState();
}

class _GaragePageState extends ConsumerState<GaragePage> {
  late ScrollController _scrollController;
  bool _isFabExtended = true;

  // ─── Helper: mostrar SnackBar de error amigable ───────────

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Muestra mensaje de sesión expirada (amigable, sin datos del servidor).
  void _showSessionExpiredMessage() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(Translations.of(context).auth.sessionExpiredSnackbar),
        backgroundColor: AppColors.orangeSecondary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }


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
        'max_mileage': data['max_mileage'] ?? 50000,
      };
      await ref.read(vehiclesProvider.notifier).addVehicle(newVehicleData);
      _showSuccessSnackBar(Translations.of(context).garage.vehicleAdded);
    } on SessionExpiredException {
      _showSessionExpiredMessage();
    } catch (_) {
      _showErrorSnackBar(Translations.of(context).garage.errorAddingVehicle);
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
      _showSuccessSnackBar(Translations.of(context).garage.vehicleUpdated);
    } on SessionExpiredException {
      _showSessionExpiredMessage();
      rethrow;
    } catch (_) {
      _showErrorSnackBar(Translations.of(context).garage.errorUpdatingVehicle);
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

          // Actualizar el kilometraje del vehículo localmente.
          // AddServiceSheet ya resuelve el valor absoluto (lectura o current + incremento),
          // así que siempre actualizamos para reflejar la salud de inmediato.
          final newMileage = data['mileage'] as int;
          if (newMileage != vehicle.mileage) {
            final updatedVehicle = vehicle.copyWith(mileage: newMileage);
            ref.read(vehiclesProvider.notifier).updateVehicleLocally(updatedVehicle);
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  Translations.of(context).garage.serviceLogged(
                    vehicleName: vehicle.displayName,
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

          // Actualizar el kilometraje del vehículo localmente.
          // AddServiceSheet ya resuelve el valor absoluto, siempre actualizamos si cambió.
          final editMileage = data['mileage'] as int;
          if (editMileage != vehicle.mileage) {
            final updatedVehicle = vehicle.copyWith(mileage: editMileage);
            ref.read(vehiclesProvider.notifier).updateVehicleLocally(updatedVehicle);
          }

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
      message: Translations.of(context).garage.removeVehicleMessage(vehicleName: vehicleName),
      onConfirm: () async {
        try {
          await ref.read(vehiclesProvider.notifier).deleteVehicle(vehicleId);
          _showSuccessSnackBar(Translations.of(context).garage.vehicleRemoved);
        } on SessionExpiredException {
          _showSessionExpiredMessage();
        } catch (_) {
          _showErrorSnackBar(Translations.of(context).garage.errorRemovingVehicle);
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
      body: vehiclesAsyncValue.when(
        data: (vehiclesList) => RefreshIndicator(
          onRefresh: () => ref.read(vehiclesProvider.notifier).refresh(),
          color: AppColors.orangePrimary,
          backgroundColor: context.colors.surface,
          edgeOffset: MediaQuery.of(context).padding.top + r.dim(80),
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverPinnedHeaderDelegate(
                  height: MediaQuery.of(context).padding.top + r.dim(82),
                  child: GarageHeader(
                    onNotificationTap: () => context.push('/notifications'),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: r.space(AppSpacing.md)),
                            GarageStats(vehicles: vehiclesList),
                            SizedBox(height: r.space(AppSpacing.xxl)),
                            _buildVehiclesSection(vehiclesList, r),
                            SizedBox(height: r.space(AppSpacing.massive)),
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
      floatingActionButton: Center(
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

  void _showVehicleDetailSheet(Vehicle vehicle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VehicleDetailSheet(
        vehicle: VehicleViewModel(vehicle),
        onClose: () => Navigator.pop(context),
        onLogService: () {
          // No cerramos el VehicleDetailSheet — abrimos AddServiceSheet encima.
          // Al cerrar AddServiceSheet, el provider se actualiza y VehicleDetailSheet
          // se reconstruye automáticamente gracias a ref.watch(maintenanceDocsProvider).
          // Leer vehículo actualizado del provider para evitar snapshot congelado.
          final liveVehicle = ref.read(vehiclesProvider).value?.where((v) => v.id == vehicle.id).firstOrNull ?? vehicle;
          _handleLogService(liveVehicle);
        },
        onEdit: () {
          Navigator.pop(context);
          _showAddVehicleSheet(initialVehicle: vehicle);
        },
        onRemove: () {
          Navigator.pop(context);
          _handleRemoveVehicle(vehicle.id, vehicle.brand);
        },
        onRemoveService: (id) {
          _handleRemoveService(vehicle, id);
        },
        onEditService: (maintenance) {
          // No cerramos el VehicleDetailSheet — abrimos edit sheet encima.
          // Al cerrarlo, el provider se actualiza y VehicleDetailSheet se reconstruye solo.
          // Leer vehículo actualizado del provider para evitar snapshot congelado.
          final liveVehicle = ref.read(vehiclesProvider).value?.where((v) => v.id == vehicle.id).firstOrNull ?? vehicle;
          _showEditServiceSheet(liveVehicle, maintenance);
        },
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
          // Corrección U1: lista generada sin operador de propagación.
          // Para listas potencialmente grandes, considerar migrar a SliverList.builder.
          ...List.generate(
            vehiclesList.length,
            (i) => VehicleCard(
              vehicleData: vehiclesList[i],
              onTap: () => _showVehicleDetailSheet(vehiclesList[i]),
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
              ).copyWith(color: context.colors.textMain),
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
      final params = MaintenanceParams(vehicleId: vehicle.id);
      ref.read(maintenanceDocsProvider(params).notifier).deleteLocal(serviceId);
      ref.read(maintenanceDocsProvider(const MaintenanceParams()).notifier).deleteLocal(serviceId);
      _showSuccessSnackBar(Translations.of(context).maintenance.serviceRemoved);
    } on SessionExpiredException {
      _showSessionExpiredMessage();
    } catch (_) {
      _showErrorSnackBar(Translations.of(context).maintenance.errorRemovingService);
    }
  }
}
