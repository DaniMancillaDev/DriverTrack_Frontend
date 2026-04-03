import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../ui/custom_input.dart';
import '../ui/custom_dropdown.dart';
import '../ui/sheet_container.dart';
import '../ui/sheet_header.dart';
import '../ui/sheet_action_button.dart';
import '../ui/inline_date_picker.dart';
import '../../theme/app_theme.dart';
import '../../utils/form_validators.dart';
import '../../models/vehicle_model.dart';
import '../../models/maintenance_model.dart';
import '../../utils/maintenance_mapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/i18n/translations.g.dart';
import '../../core/units/domain/unit_formatter.dart';
import '../../core/units/presentation/unit_system_provider.dart';
import '../../features/currency/presentation/widgets/currency_display.dart';
import '../../features/currency/presentation/providers/currency_provider.dart';
import '../../features/currency/domain/entities/currency.dart';

class AddServiceSheet extends ConsumerStatefulWidget {
  final List<Vehicle> vehicles;
  final Future<void> Function(Map<String, dynamic>) onSave;
  final Maintenance? initialMaintenance;

  const AddServiceSheet({
    super.key,
    required this.vehicles,
    required this.onSave,
    this.initialMaintenance,
  });

  @override
  ConsumerState<AddServiceSheet> createState() => _AddServiceSheetState();
}

class _AddServiceSheetState extends ConsumerState<AddServiceSheet> {
  Vehicle? _selectedVehicle;
  late final TextEditingController _serviceController;
  DateTime _selectedDate = DateTime.now();
  late final TextEditingController _costController;
  late final TextEditingController _mileageController;
  late final TextEditingController _notesController;

  bool _isSaving = false;
  bool _isSaved = false;
  final Set<String> _dirtyFields = {};
  String _selectedCategory = 'General';
  final List<String> _categories = [
    'General',
    'Fluid Service',
    'Wear & Tear',
    'Inspection',
    'Cosmetic',
    'Electrical'
  ];

  // Validation state
  String? _serviceError;
  String? _costError;
  String? _mileageError;

  @override
  void initState() {
    super.initState();
    
    if (widget.initialMaintenance != null) {
      final m = widget.initialMaintenance!;
      _selectedVehicle = widget.vehicles.firstWhere(
        (v) => v.id == m.vehicleId,
        orElse: () => widget.vehicles.first,
      );
      _serviceController = TextEditingController(text: MaintenanceMapper.getTitle(m.description));
      _selectedDate = m.date;
      final currencyState = ref.read(currencyNotifierProvider).value;
      double initialCost = m.cost;
      if (currencyState != null && currencyState.activeCurrency != Currency.usd) {
         initialCost = initialCost * currencyState.exchangeRate.rate;
      }
      _costController = TextEditingController(text: initialCost.toStringAsFixed(2));
      _mileageController = TextEditingController(text: m.mileage.toString());
      _selectedCategory = m.category;
      _notesController = TextEditingController(text: MaintenanceMapper.getNotes(m.description) ?? ''); 
    } else {
      _selectedVehicle = widget.vehicles.isNotEmpty
          ? widget.vehicles.first
          : null;
      _serviceController = TextEditingController();
      _costController = TextEditingController();
      _mileageController = TextEditingController();
      _notesController = TextEditingController();
    }

    _serviceController.addListener(_validate);
    _costController.addListener(_validate);
    _mileageController.addListener(_validate);
  }

  @override
  void dispose() {
    _serviceController.dispose();
    _costController.dispose();
    _mileageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _validate() {
    setState(() {
      final t = Translations.of(context);
      _serviceError = FormValidators.notEmpty(
        _serviceController.text,
        t.maintenance.service, context,
      );
      _costError = FormValidators.cost(_costController.text, context);
      _mileageError = FormValidators.mileage(_mileageController.text, context);
    });
  }

  bool get _isValid =>
      _selectedVehicle != null &&
      _serviceError == null &&
      _costError == null &&
      _mileageError == null &&
      _serviceController.text.isNotEmpty &&
      _costController.text.isNotEmpty &&
      _mileageController.text.isNotEmpty;

  void _handleSave() async {
    _validate();

    if (!_isValid) {
      setState(() {
        _dirtyFields.addAll(['service', 'cost', 'mileage']);
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _isSaved = false;
    });

    double finalCost = double.tryParse(_costController.text) ?? 0.0;

    // Obtener la divisa actual. Si el usuario ingresó en MXN, convertimos a USD base.
    final currencyState = ref.read(currencyNotifierProvider).value;
    if (currencyState != null && currencyState.activeCurrency != Currency.usd) {
      // Divide entre el tipo de cambio USD -> MXN para regresar a USD puro
      finalCost = finalCost / currencyState.exchangeRate.rate;
    }

    final entry = {
      'vehicle_id': _selectedVehicle!.id,
      'description': _serviceController.text,
      'date': _selectedDate.toIso8601String().split('T')[0],
      'cost': finalCost,
      'mileage': int.tryParse(_mileageController.text) ?? 0,
      'category': _selectedCategory,
      'notes': _notesController.text.isEmpty ? null : _notesController.text,
    };

    try {
      await widget.onSave(entry);
      
      if (!mounted) return;

      setState(() {
        _isSaving = false;
        _isSaved = true;
      });

      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.red),
      );
    }
  }

  void _markDirty(String field) {
    if (!_dirtyFields.contains(field)) {
      setState(() => _dirtyFields.add(field));
    }
  }

  // Removed _selectDate since we now use InlineDatePicker

  Widget _buildAnimatedItem(int index, Widget child) {
    return TweenAnimationBuilder<double>(
      key: ValueKey('anim_svc_$index'),
      duration: Duration(milliseconds: 400 + (index * 80)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, animChild) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: animChild,
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final t = Translations.of(context);
    
    final currencyAsync = ref.watch(currencyNotifierProvider);
    final String activeCurrencyCode = currencyAsync.value?.activeCurrency.code ?? 'USD';

    return SheetContainer(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SheetHeader(
              title: t.maintenance.addServiceRecord,
              subtitle: t.maintenance.logActivity,
              onClose: () => Navigator.pop(context),
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildAnimatedItem(
              0,
              CustomDropdown<Vehicle>(
                value: _selectedVehicle,
                label: t.maintenance.vehicle,
                icon: Icons.directions_car_filled_rounded,
                items: widget.vehicles,
                itemLabelBuilder: (v) => v.displayName,
                onChanged: (v) => setState(() => _selectedVehicle = v),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            _buildAnimatedItem(
              1,
              CustomDropdown<String>(
                value: _selectedCategory,
                label: 'Category',
                icon: Icons.category_rounded,
                items: _categories,
                itemLabelBuilder: (c) => c,
                onChanged: (c) {
                  if (c != null) setState(() => _selectedCategory = c);
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            _buildAnimatedItem(
              2,
              CustomInput(
                controller: _serviceController,
                label: t.maintenance.serviceDescription,
                placeholder: t.maintenance.servicePlaceholder,
                errorText: _dirtyFields.contains('service')
                    ? _serviceError
                    : null,
                prefixIcon: const Icon(
                  Icons.build_circle_rounded,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                onChanged: (_) => _markDirty('service'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            _buildAnimatedItem(
              3,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.s, left: 4),
                    child: Text(
                      t.maintenance.date.toUpperCase(),
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  InlineDatePicker(
                    initialDate: _selectedDate,
                    onChanged: (d) {
                      _markDirty('date');
                      setState(() => _selectedDate = d);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Cost and Mileage on the same row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildAnimatedItem(
                    4,
                    CustomInput(
                      controller: _costController,
                      label: '${t.maintenance.costLabel} ($activeCurrencyCode)',
                      placeholder: '0.00',
                      errorText: _dirtyFields.contains('cost')
                          ? _costError
                          : null,
                      prefixIcon: const Icon(
                        Icons.attach_money_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (_) => _markDirty('cost'),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildAnimatedItem(
                    4,
                    CustomInput(
                      controller: _mileageController,
                      label: t.maintenance.mileage,
                      placeholder: t.maintenance.mileagePlaceholder,
                      errorText: _dirtyFields.contains('mileage')
                          ? _mileageError
                          : null,
                      prefixIcon: const Icon(
                        Icons.speed_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _markDirty('mileage'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            _buildAnimatedItem(
              5,
              CustomInput(
                controller: _notesController,
                label: t.maintenance.notesHint,
                placeholder: t.maintenance.detailsPlaceholder,
                maxLines: 2,
                onChanged: (_) => setState(() {}),
              ),
            ),
            if (_serviceController.text.isNotEmpty ||
                _costController.text.isNotEmpty)
              _buildAnimatedItem(6, _buildRecordPreview(context)),

            const SizedBox(height: AppSpacing.lg),

            _buildAnimatedItem(
              7,
              SheetActionButton(
                label: widget.initialMaintenance != null ? t.maintenance.btnUpdate : t.maintenance.btnSave,
                successLabel: widget.initialMaintenance != null ? t.maintenance.btnUpdated : t.maintenance.btnSaved,
                onPressed: _handleSave,
                isEnabled: _isValid,
                isLoading: _isSaving,
                isSuccess: _isSaved,
                icon: widget.initialMaintenance != null ? Icons.save_rounded : Icons.add_task_rounded,
                successIcon: Icons.check_circle_rounded,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            _buildAnimatedItem(
              8,
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    t.common.cancel,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordPreview(BuildContext context) {
    final rawCost = double.tryParse(_costController.text) ?? 0.0;
    final currencyState = ref.read(currencyNotifierProvider).value;
    double cost = rawCost;
    if (currencyState != null && currencyState.activeCurrency != Currency.usd) {
      cost = rawCost / currencyState.exchangeRate.rate;
    }
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.s),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                Translations.of(context).maintenance.recordPreview,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            _serviceController.text.isEmpty
                ? Translations.of(context).maintenance.untitledService
                : _serviceController.text,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            '${_selectedVehicle?.displayName ?? Translations.of(context).maintenance.unknownVehicle} • ${DateFormat('MMM d, y').format(_selectedDate)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Translations.of(context).maintenance.costLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  cost > 0
                      ? CurrencyDisplay(
                          amount: cost,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.green,
                                fontWeight: FontWeight.w800,
                              ),
                        )
                      : Text(
                          Translations.of(context).maintenance.costFree,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Translations.of(context).maintenance.mileageLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    UnitFormatter.formatDistance(double.tryParse(_mileageController.text) ?? 0, ref.watch(unitSystemProvider), fractionDigits: 0),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
