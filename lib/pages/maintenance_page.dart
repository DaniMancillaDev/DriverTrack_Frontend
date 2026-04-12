import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../viewmodels/maintenance_view_model.dart';
import '../viewmodels/vehicle_view_model.dart';
import '../widgets/maintenance/maintenance_card.dart';
import '../widgets/maintenance/maintenance_card_skeleton.dart';
import '../widgets/maintenance/maintenance_header.dart';
import '../widgets/maintenance/maintenance_stats.dart';
import '../widgets/maintenance/add_service_sheet.dart';
import '../widgets/maintenance/service_detail_sheet.dart';
import '../widgets/ui/premium_fab.dart';
import '../widgets/ui/filter_pills.dart';
import '../models/vehicle_model.dart';
import '../models/maintenance_model.dart';
import '../widgets/ui/confirmation_dialog.dart';
import '../core/i18n/translations.g.dart';
import '../core/responsive/responsive.dart';
import '../theme/app_color_scheme.dart';
import '../widgets/maintenance/maintenance_empty_state.dart';
import '../widgets/ui/sliver_header_delegate.dart';

/// Página de historial y gestión de mantenimiento.
/// 
/// Centraliza la bitácora técnica de toda la flota de vehículos. 
/// Sus funciones principales incluyen:
/// * **Repositorio Histórico**: Listado cronológico de todas las intervenciones 
///   mecánicas y servicios realizados.
/// * **Análisis de Inversión**: Visualización de costos acumulados mediante [MaintenanceStats].
/// * **Filtrado Inteligente**: Capacidad de segmentar el historial por vehículo 
///   específico usando [FilterPills].
/// * **CRUD de Servicios**: Interfaz para el registro, edición y eliminación de 
///   entradas de mantenimiento.
class MaintenancePage extends ConsumerStatefulWidget {
  const MaintenancePage({super.key});

  @override
  ConsumerState<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends ConsumerState<MaintenancePage> {
  var _activeFilter = '';
  late ScrollController _scrollController;
  bool _isFabExtended = true;


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

  Future<void> _handleAddService(Map<String, dynamic> data) async {
    try {
      final repository = ref.read(maintenanceRepositoryProvider);
      final vehicles = ref.read(vehiclesProvider).value ?? [];
      final match = vehicles.firstWhere(
        (v) => VehicleViewModel(v).displayName == data['vehicle'],
        orElse: () => vehicles.first,
      );

      final desc = _buildDescriptionWithNotes(data);

      final newRecord = {
        'vehicle_id': match.id,
        'date': data['date'] as String,
        'description': desc,
        'cost': data['cost'].toString(),
        'mileage': data['mileage'],
        'category': data['category'],
      };

      final savedRecord = await repository.addMaintenanceRecord(newRecord);
      final params = MaintenanceParams(vehicleId: match.id);
      ref.read(maintenanceDocsProvider(params).notifier).updateLocal(savedRecord);
      ref.read(maintenanceDocsProvider(const MaintenanceParams()).notifier).updateLocal(savedRecord);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Translations.of(context).maintenance.serviceAdded),
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
              '${Translations.of(context).maintenance.errorAddingService(error: '$e')}',
            ),
            backgroundColor: AppColors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showAddServiceSheet(List<Vehicle> vehicles) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          AddServiceSheet(vehicles: vehicles, onSave: _handleAddService),
    );
  }

  void _handleEditEntry(Maintenance maintenance) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final vehicles = ref.read(vehiclesProvider).value ?? [];
        final vehicle = vehicles.firstWhere(
          (v) => v.id == maintenance.vehicleId,
          orElse: () => vehicles.first,
        );

        return AddServiceSheet(
          vehicles: [vehicle],
          initialMaintenance: maintenance,
          onSave: (data) async {
            try {
              final repository = ref.read(maintenanceRepositoryProvider);
              final params = MaintenanceParams(
                vehicleId: maintenance.vehicleId,
              );

              final recordData = {
                'vehicle_id': maintenance.vehicleId,
                'date': data['date'] as String,
                'description': _buildDescriptionWithNotes(data),
                'cost': data['cost'].toString(),
                'mileage': data['mileage'],
                'category': data['category'],
              };

              final updatedRec = await repository.updateMaintenanceRecord(
                maintenance.id,
                recordData,
              );
              ref.read(maintenanceDocsProvider(params).notifier).updateLocal(updatedRec);
              ref.read(maintenanceDocsProvider(const MaintenanceParams()).notifier).updateLocal(updatedRec);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      Translations.of(context).maintenance.serviceUpdated,
                    ),
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
                      Translations.of(context).maintenance.errorUpdatingService(error: '$e'),
                    ),
                    backgroundColor: AppColors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            }
          },
        );
      },
    );
  }

  void _handleRemoveEntry(int entryId, MaintenanceViewModel vm) {
    ConfirmationDialog.show(
      context,
      title: Translations.of(context).maintenance.removeEntryTitle,
      message: Translations.of(
        context,
      ).maintenance.removeEntryMessage(title: vm.title),
      onConfirm: () async {
        try {
          final repository = ref.read(maintenanceRepositoryProvider);
          await repository.deleteMaintenanceRecord(entryId);

          final params = MaintenanceParams(vehicleId: vm.vehicleId);
          ref.read(maintenanceDocsProvider(params).notifier).deleteLocal(entryId);
          ref.read(maintenanceDocsProvider(const MaintenanceParams()).notifier).deleteLocal(entryId);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  Translations.of(context).maintenance.serviceRemoved,
                ),
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
                  '${Translations.of(context).maintenance.errorRemovingService}: $e',
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
    final vehiclesAsync = ref.watch(vehiclesProvider);
    final maintenanceAsync = ref.watch(
      maintenanceDocsProvider(const MaintenanceParams()),
    );
    final r = context.responsive;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: vehiclesAsync.when(
        data: (vehicles) => maintenanceAsync.when(
          data: (maintenances) {
            final dynamicFilters =
                [Translations.of(context).maintenance.allVehicles] +
                vehicles.map((v) => VehicleViewModel(v).displayName).toList();

            final viewModels = maintenances
                .map((e) => MaintenanceViewModel(e))
                .toList();

            String getVehicleName(int vId) {
              final v = vehicles
                  .where((element) => element.id == vId)
                  .firstOrNull;
              return v != null
                  ? VehicleViewModel(v).displayName
                  : Translations.of(context).common.unknownVehicle;
            }

            final filtered =
                _activeFilter == '' ||
                    _activeFilter ==
                        Translations.of(context).maintenance.allVehicles
                ? viewModels
                : viewModels
                      .where(
                        (vm) => getVehicleName(vm.vehicleId) == _activeFilter,
                      )
                      .toList();

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(maintenanceDocsProvider);
                ref.invalidate(vehiclesProvider);
              },
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
                      child: const MaintenanceHeader(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        r.space(AppSpacing.lg),
                        r.space(AppSpacing.md), // Consistent gap after header
                        r.space(AppSpacing.lg),
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MaintenanceStats(maintenances: viewModels),
                          SizedBox(height: r.space(AppSpacing.xl)),
                          FilterPills(
                            filters: dynamicFilters,
                            activeFilter: _activeFilter,
                            onFilterChanged: (filter) =>
                                setState(() => _activeFilter = filter),
                          ),
                          SizedBox(height: r.space(AppSpacing.md)),
                          if (filtered.isEmpty)
                            MaintenanceEmptyState(
                              isFiltering:
                                  _activeFilter != Translations.of(context).maintenance.allVehicles,
                            )
                          else
                            ...List.generate(
                              filtered.length,
                              (i) => MaintenanceCard(
                                vm: filtered[i],
                                vehicleName: getVehicleName(
                                  filtered[i].vehicleId,
                                ),
                                onTap: () => _showServiceDetailSheet(filtered[i], getVehicleName),
                              ),
                            ),
                          SizedBox(height: r.dim(100)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: _buildLoading,
          error: _buildError,
        ),
        loading: _buildLoading,
        error: _buildError,
      ),
      floatingActionButton: vehiclesAsync.maybeWhen(
              data: (vehicles) => Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: r.value(mobile: 600, tablet: 700),
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: PremiumFAB(
                      onPressed: () => _showAddServiceSheet(vehicles),
                      label: Translations.of(context).maintenance.addService,
                      icon: Icons.add,
                      isExtended: _isFabExtended,
                    ),
                  ),
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
    );
  }

  void _showServiceDetailSheet(MaintenanceViewModel e, String Function(int) getName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceDetailSheet(
        serviceTitle: e.title,
        vehicleName: e.vehicleName(getName(e.vehicleId)),
        date: e.date,
        cost: e.cost,
        mileage: e.mileage,
        accentColor: e.computedAccent,
        category: e.category,
        notes: e.notes,
        onClose: () => Navigator.pop(context),
        onEdit: () {
          Navigator.pop(context);
          _handleEditEntry(e.maintenance);
        },
        onRemove: () {
          Navigator.pop(context);
          _handleRemoveEntry(e.id, e);
        },
      ),
    );
  }


  Widget _buildLoading() {
    final r = context.responsive;
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: r.space(AppSpacing.lg),
        vertical: r.space(AppSpacing.xs),
      ),
      itemCount: 5,
      itemBuilder: (context, _) => const MaintenanceCardSkeleton(),
    );
  }

  Widget _buildError(Object err, StackTrace stack) {
    final r = context.responsive;
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
              Translations.of(context).maintenance.errorTitle,
              style: AppTextStyles.title(
                context,
              ).copyWith(color: context.colors.textMain, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: r.space(AppSpacing.s)),
            Text(
              Translations.of(context).maintenance.errorMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(
                context,
              ).copyWith(color: context.colors.textMuted, height: 1.5),
            ),
            SizedBox(height: r.space(AppSpacing.lg)),
            TextButton.icon(
              onPressed: () {
                ref.invalidate(maintenanceDocsProvider);
                ref.invalidate(vehiclesProvider);
              },
              icon: Icon(Icons.refresh_rounded,
                  color: AppColors.orangePrimary, size: AppIconSizes.md(context)),
              label: Text(
                Translations.of(context).common.retry,
                style: AppTextStyles.button(context)
                    .copyWith(color: AppColors.orangePrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildDescriptionWithNotes(Map<String, dynamic> data) {
    return data['notes'] != null && data['notes'].toString().trim().isNotEmpty
        ? '${data['description']} | ${data['notes']}'
        : data['description'];
  }
}
