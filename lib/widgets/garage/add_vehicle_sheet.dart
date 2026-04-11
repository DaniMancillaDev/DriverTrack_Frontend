import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/vehicle_model.dart';
import '../../models/vehicle_type_model.dart';
import '../../providers/app_providers.dart';
import '../ui/custom_input.dart';
import '../ui/custom_dropdown.dart';
import '../ui/sheet_container.dart';
import '../ui/sheet_header.dart';
import '../ui/sheet_action_button.dart';
import 'vehicle_type_toggle.dart';
import 'vehicle_preview_card.dart';
import '../../theme/app_theme.dart';
import '../../utils/form_validators.dart';
import '../../core/i18n/translations.g.dart';
import '../../theme/app_color_scheme.dart';

class AddVehicleSheet extends ConsumerStatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final Vehicle? initialVehicle;

  const AddVehicleSheet({super.key, required this.onSave, this.initialVehicle});

  @override
  ConsumerState<AddVehicleSheet> createState() => _AddVehicleSheetState();
}

class _AddVehicleSheetState extends ConsumerState<AddVehicleSheet>
    with TickerProviderStateMixin {
  VehicleType? _type;
  String? _brand;
  late final TextEditingController _modelController;
  String? _year;
  late final TextEditingController _plateController;
  late final TextEditingController _mileageController;
  late final TextEditingController _maxMileageController;

  bool _isSaving = false;
  bool _isSaved = false;
  final Set<String> _dirtyFields = {};

  // Validation state
  String? _modelError;
  String? _plateError;
  String? _mileageError;
  String? _maxMileageError;

  final List<String> _carBrands = [
    "Toyota",
    "Ford",
    "Honda",
    "BMW",
    "Mercedes",
    "Chevrolet",
    "Hyundai",
    "Nissan",
    "Kia",
    "Audi",
    "Volkswagen",
    "Subaru",
    "Mazda",
    "Lexus",
    "Jeep",
  ];
  final List<String> _motoBrands = [
    "Honda",
    "Yamaha",
    "Kawasaki",
    "Suzuki",
    "Ducati",
    "Harley-Davidson",
    "KTM",
    "BMW Motorrad",
    "Triumph",
    "Royal Enfield",
  ];

  late final List<String> _years;

  @override
  void initState() {
    super.initState();
    final currentYear = DateTime.now().year;
    _years = List.generate(30, (index) => (currentYear - index).toString());

    // Initialize with editing data if provided
    if (widget.initialVehicle != null) {
      final v = widget.initialVehicle!;
      _type = v.vehicleType;
      _brand = v.brand;
      
      // Prevent dropdown errors if brand is not in the list
      if (_brand != null) {
        if (!_carBrands.contains(_brand)) _carBrands.add(_brand!);
        if (!_motoBrands.contains(_brand)) _motoBrands.add(_brand!);
      }
      
      _modelController = TextEditingController(text: v.model);
      _year = v.year.toString();
      _plateController = TextEditingController(text: v.plate);
      _mileageController = TextEditingController(text: v.mileage.toString());
      _maxMileageController = TextEditingController(text: v.maxMileage.toString());
    } else {
      _modelController = TextEditingController();
      _plateController = TextEditingController();
      _mileageController = TextEditingController();
      _maxMileageController = TextEditingController(text: '50000');
    }
  }

  void _validate() {
    setState(() {
      final t = Translations.of(context);
      _modelError = FormValidators.notEmpty(
        _modelController.text,
        t.garage.addVehicleForm.modelLabel,
        context,
      );
      _plateError = FormValidators.licensePlate(_plateController.text, context);
      _mileageError = FormValidators.mileage(_mileageController.text, context);
      _maxMileageError = FormValidators.mileage(_maxMileageController.text, context);
    });
  }

  bool get _isValid =>
      _type != null &&
      _brand != null &&
      _year != null &&
      _modelError == null &&
      _plateError == null &&
      _mileageError == null &&
      _maxMileageError == null &&
      _modelController.text.isNotEmpty &&
      _plateController.text.isNotEmpty &&
      _mileageController.text.isNotEmpty &&
      _maxMileageController.text.isNotEmpty;

  void _handleSave() async {
    _validate();

    if (!_isValid) {
      setState(() {
        _dirtyFields.addAll(['model', 'plate', 'mileage', 'maxMileage']);
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _isSaved = false;
    });

    final vehicle = {
      'brand': _brand,
      'model': _modelController.text,
      'year': int.parse(_year!),
      'plate': _plateController.text.toUpperCase(),
      'mileage': int.tryParse(_mileageController.text) ?? 0,
      'max_mileage': int.tryParse(_maxMileageController.text) ?? 50000,
      'type_id': _type!.id,
    };

    try {
      await widget.onSave(vehicle);

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

  Widget _buildAnimatedItem(int index, Widget child) {
    return TweenAnimationBuilder<double>(
      key: ValueKey('anim_$index'),
      duration: Duration(milliseconds: 250 + (index * 40)),
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
    final vehicleTypesAsync = ref.watch(vehicleTypesProvider);
    final vehicleTypes = vehicleTypesAsync.value ?? [];

    // Initialize default type if not set
    if (_type == null && vehicleTypes.isNotEmpty) {
      _type = vehicleTypes.first;
    }

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
              title: widget.initialVehicle != null
                  ? Translations.of(context).garage.addVehicleForm.titleUpdate
                  : Translations.of(context).garage.addVehicleForm.titleAdd,
              subtitle: Translations.of(context).garage.addVehicleForm.subtitle,
              onClose: () => Navigator.pop(context),
            ),
            const SizedBox(height: AppSpacing.lg),

            if (vehicleTypes.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: CircularProgressIndicator(),
                ),
              )
            else ...[
              _buildAnimatedItem(
                0,
                VehicleTypeToggle(
                  vehicleTypes: vehicleTypes,
                  selectedType: _type ?? vehicleTypes.first,
                  onChanged: (v) => setState(() {
                    _type = v;
                    _brand = null;
                  }),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildAnimatedItem(
                1,
                CustomDropdown<String>(
                  value: _brand,
                  label: Translations.of(
                    context,
                  ).garage.addVehicleForm.brandLabel,
                  hint: Translations.of(
                    context,
                  ).garage.addVehicleForm.brandHint,
                  icon: Icons.bookmark_outline_rounded,
                  items: _type?.slug == 'car' ? _carBrands : _motoBrands,
                  itemLabelBuilder: (v) => v,
                  onChanged: (v) {
                    setState(() => _brand = v);
                    _markDirty('brand');
                  },
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),

            _buildAnimatedItem(
              2,
              CustomInput(
                controller: _modelController,
                label: Translations.of(
                  context,
                ).garage.addVehicleForm.modelLabel,
                placeholder: _type?.slug == 'car'
                    ? Translations.of(
                        context,
                      ).garage.addVehicleForm.modelHintCar
                    : Translations.of(
                        context,
                      ).garage.addVehicleForm.modelHintMoto,
                errorText: (_dirtyFields.contains('model'))
                    ? _modelError
                    : null,
                prefixIcon: Icon(
                  Icons.tag_rounded,
                  size: 16,
                  color: context.colors.textDark,
                ),
                onChanged: (_) {
                  _markDirty('model');
                  _validate();
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildAnimatedItem(
              3,
              CustomDropdown<String>(
                value: _year,
                label: Translations.of(context).garage.addVehicleForm.yearLabel,
                hint: Translations.of(context).garage.addVehicleForm.yearHint,
                icon: Icons.calendar_today_rounded,
                items: _years,
                itemLabelBuilder: (v) => v,
                onChanged: (v) {
                  setState(() => _year = v);
                  _markDirty('year');
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildAnimatedItem(
              4,
              CustomInput(
                controller: _plateController,
                label: Translations.of(
                  context,
                ).garage.addVehicleForm.plateLabel,
                placeholder: Translations.of(
                  context,
                ).garage.addVehicleForm.plateHint,
                errorText: (_dirtyFields.contains('plate'))
                    ? _plateError
                    : null,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9-]')),
                  _UpperCaseTextFormatter(),
                ],
                prefixIcon: Icon(
                  Icons.tag_rounded,
                  size: 16,
                  color: context.colors.textDark,
                ),
                subHint: Translations.of(
                  context,
                ).garage.addVehicleForm.plateSubHint,
                onChanged: (v) {
                  _markDirty('plate');
                  _validate();
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildAnimatedItem(
              5,
              CustomInput(
                controller: _mileageController,
                label: Translations.of(
                  context,
                ).garage.addVehicleForm.mileageLabel,
                placeholder: Translations.of(
                  context,
                ).garage.addVehicleForm.mileageHint,
                errorText: (_dirtyFields.contains('mileage'))
                    ? _mileageError
                    : null,
                prefixIcon: Icon(
                  Icons.speed_rounded,
                  size: 16,
                  color: context.colors.textDark,
                ),
                keyboardType: TextInputType.number,
                subHint: Translations.of(
                  context,
                ).garage.addVehicleForm.mileageSubHint,
                onChanged: (_) {
                  _markDirty('mileage');
                  _validate();
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildAnimatedItem(
              6,
              CustomInput(
                controller: _maxMileageController,
                label: Translations.of(context).$meta.locale.languageCode == 'es' ? 'Límite Máximo de KM' : 'Max Life Mileage',
                placeholder: 'ej., 50000',
                errorText: (_dirtyFields.contains('maxMileage'))
                    ? _maxMileageError
                    : null,
                prefixIcon: Icon(
                  Icons.av_timer_rounded,
                  size: 16,
                  color: context.colors.textDark,
                ),
                keyboardType: TextInputType.number,
                subHint: Translations.of(context).$meta.locale.languageCode == 'es' ? 'Vida útil del vehículo (sirve para alertas y estado de salud)' : 'Expected life span to calculate vehicle health',
                onChanged: (_) {
                  _markDirty('maxMileage');
                  _validate();
                },
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            if (_brand != null || _modelController.text.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s, left: 2),
                child: Text(
                  'PREVIEW',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: context.colors.textMuted,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _buildAnimatedItem(
                7,
                VehiclePreviewCard(
                  type: _type,
                  brand: _brand,
                  model: _modelController.text,
                  year: _year,
                  plate: _plateController.text,
                  mileage: _mileageController.text,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),

            _buildAnimatedItem(
              8,
              SheetActionButton(
                label: widget.initialVehicle != null
                    ? Translations.of(context).garage.addVehicleForm.btnUpdate
                    : (_type?.icon == 'motorcycle_rounded'
                          ? Translations.of(
                              context,
                            ).garage.addVehicleForm.btnSaveMoto
                          : Translations.of(
                              context,
                            ).garage.addVehicleForm.btnSaveCar),
                successLabel: widget.initialVehicle != null
                    ? Translations.of(context).garage.addVehicleForm.btnUpdated
                    : (_type?.icon == 'motorcycle_rounded'
                          ? Translations.of(
                              context,
                            ).garage.addVehicleForm.btnSavedMoto
                          : Translations.of(
                              context,
                            ).garage.addVehicleForm.btnSavedCar),
                onPressed: _handleSave,
                isEnabled: _isValid,
                isLoading: _isSaving,
                isSuccess: _isSaved,
                icon: widget.initialVehicle != null
                    ? Icons.save_rounded
                    : (_type?.icon == 'motorcycle_rounded'
                          ? Icons.motorcycle_rounded
                          : Icons.directions_car_filled_rounded),
                successIcon: Icons.check_circle_rounded,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            _buildAnimatedItem(
              9,
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    Translations.of(context).garage.addVehicleForm.btnCancel,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: context.colors.textMuted,
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
}

class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
