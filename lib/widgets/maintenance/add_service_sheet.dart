import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../ui/custom_input.dart';
import '../ui/custom_dropdown.dart';

class AddServiceSheet extends StatefulWidget {
  final List<String> vehicles;
  final Function(Map<String, dynamic>) onSave;

  const AddServiceSheet({
    super.key,
    required this.vehicles,
    required this.onSave,
  });

  @override
  State<AddServiceSheet> createState() => _AddServiceSheetState();
}

class _AddServiceSheetState extends State<AddServiceSheet> {
  late String _selectedVehicle;
  final TextEditingController _serviceController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedVehicle = widget.vehicles.first;
  }

  bool get _isValid =>
      _serviceController.text.isNotEmpty &&
      _costController.text.isNotEmpty &&
      _mileageController.text.isNotEmpty;

  void _handleSave() async {
    if (!_isValid) return;

    setState(() => _isSaving = true);

    // Simulate save delay for premium feel
    await Future.delayed(const Duration(milliseconds: 800));

    final entry = {
      'vehicle': _selectedVehicle,
      'service': _serviceController.text,
      'date': _selectedDate,
      'cost': double.tryParse(_costController.text) ?? 0.0,
      'mileage': int.tryParse(_mileageController.text) ?? 0,
      'notes': _notesController.text.isEmpty ? null : _notesController.text,
    };

    widget.onSave(entry);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFF6B1A),
              onPrimary: Colors.white,
              surface: Color(0xFF16161A),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF0F0F12),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0F0F12),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            border: Border(top: BorderSide(color: Color(0xFF2A2A30))),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF333340),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Add Service Record',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Log a maintenance activity',
                                style: TextStyle(color: Color(0xFF5A5A6A), fontSize: 13),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Color(0xFF6B6B7A), size: 18),
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xFF16161A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: const BorderSide(color: Color(0xFF2E2E38)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Vehicle Select
                      CustomDropdown<String>(
                        value: _selectedVehicle,
                        label: 'Vehicle',
                        icon: Icons.directions_car_filled_rounded,
                        items: widget.vehicles,
                        itemLabelBuilder: (v) => v,
                        onChanged: (v) => setState(() => _selectedVehicle = v!),
                      ),
                      const SizedBox(height: 20),

                      // Service Name
                      CustomInput(
                        controller: _serviceController,
                        label: 'Service Description',
                        placeholder: 'e.g., Oil Change, Tire Rotation...',
                        prefixIcon: const Icon(Icons.build_circle_rounded, size: 16, color: Color(0xFF5A5A6A)),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date Select
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0, left: 4),
                                  child: Text(
                                    'Date'.toUpperCase(),
                                    style: const TextStyle(
                                      color: Color(0xFF9E9EAE),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => _selectDate(context),
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF16161A),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: const Color(0xFF222228)),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.calendar_today_rounded, color: Color(0xFF5A5A6A), size: 16),
                                        const SizedBox(width: 12),
                                        Text(
                                          DateFormat('MMM d, y').format(_selectedDate),
                                          style: const TextStyle(color: Colors.white, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Cost Input
                          Expanded(
                            child: CustomInput(
                              controller: _costController,
                              label: 'Cost (USD)',
                              placeholder: '0.00',
                              prefixIcon: const Icon(Icons.attach_money_rounded, size: 16, color: Color(0xFF5A5A6A)),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Mileage Input
                      CustomInput(
                        controller: _mileageController,
                        label: 'Mileage at Service',
                        placeholder: 'e.g., 42000',
                        prefixIcon: const Icon(Icons.speed_rounded, size: 16, color: Color(0xFF5A5A6A)),
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 20),

                      // Notes Textarea
                      CustomInput(
                        controller: _notesController,
                        label: 'Notes (Optional)',
                        placeholder: 'Additional details...',
                        maxLines: 2,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 32),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          onTap: _isValid && !_isSaving ? _handleSave : null,
                          borderRadius: BorderRadius.circular(16),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: _isSaving
                                  ? const Color(0xFF4CAF82)
                                  : _isValid
                                      ? null
                                      : const Color(0xFF222228),
                              gradient: !_isValid || _isSaving
                                  ? null
                                  : const LinearGradient(
                                      colors: [Color(0xFFFF6B1A), Color(0xFFFF9C1A)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: _isValid && !_isSaving
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFFFF6B1A).withOpacity(0.35),
                                        blurRadius: 24,
                                        offset: const Offset(0, 8),
                                      )
                                    ]
                                  : [],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _isSaving ? Icons.check_circle_rounded : Icons.add_task_rounded,
                                  color: _isValid ? Colors.white : const Color(0xFF5A5A6A),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _isSaving ? 'Record Saved' : 'Save Service Record',
                                  style: TextStyle(
                                    color: _isValid ? Colors.white : const Color(0xFF5A5A6A),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Color(0xFF5A5A6A), fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
