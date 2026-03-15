import 'package:flutter/material.dart';
import '../ui/custom_input.dart';
import '../ui/custom_dropdown.dart';

class AddVehicleSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const AddVehicleSheet({super.key, required this.onSave});

  @override
  State<AddVehicleSheet> createState() => _AddVehicleSheetState();
}

class _AddVehicleSheetState extends State<AddVehicleSheet> {
  String _type = 'car';
  String? _brand;
  final TextEditingController _modelController = TextEditingController();
  String? _year;
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();

  bool _isSaving = false;

  final List<String> _carBrands = [
    "Toyota", "Ford", "Honda", "BMW", "Mercedes", "Chevrolet", "Hyundai", "Nissan", "Kia", "Audi", "Volkswagen", "Subaru"
  ];
  final List<String> _motoBrands = [
    "Honda", "Yamaha", "Kawasaki", "Suzuki", "Ducati", "Harley-Davidson", "KTM", "BMW Motorrad", "Triumph", "Royal Enfield"
  ];

  late final List<String> _years;

  @override
  void initState() {
    super.initState();
    final currentYear = DateTime.now().year;
    _years = List.generate(30, (index) => (currentYear - index).toString());
  }

  bool get _isValid =>
      _brand != null &&
      _modelController.text.isNotEmpty &&
      _year != null &&
      _plateController.text.isNotEmpty &&
      _mileageController.text.isNotEmpty;

  void _handleSave() async {
    if (!_isValid) return;

    setState(() => _isSaving = true);

    // Simulate save delay for premium feel
    await Future.delayed(const Duration(milliseconds: 900));

    final vehicle = {
      'brand': _brand,
      'model': _modelController.text,
      'year': _year,
      'plate': _plateController.text.toUpperCase(),
      'mileage': _mileageController.text,
      'type': _type,
    };

    widget.onSave(vehicle);
    if (mounted) Navigator.pop(context);
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
                                'Add Vehicle',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Link a new vehicle to your garage',
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

                      // Type Toggle
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, left: 4),
                        child: Text(
                          'Vehicle Type'.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF9E9EAE),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF16161A),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF222228)),
                        ),
                        child: Row(
                          children: [
                            _buildTypeButton('car', Icons.directions_car_filled_rounded, 'Car'),
                            const SizedBox(width: 6),
                            _buildTypeButton('motorcycle', Icons.motorcycle_rounded, 'Motorcycle'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Brand Select
                      CustomDropdown<String>(
                        value: _brand,
                        label: 'Brand / Make',
                        hint: 'Select brand...',
                        icon: Icons.bookmark_outline_rounded,
                        items: _type == 'car' ? _carBrands : _motoBrands,
                        itemLabelBuilder: (v) => v,
                        onChanged: (v) => setState(() => _brand = v),
                      ),
                      const SizedBox(height: 20),

                      // Model Input
                      CustomInput(
                        controller: _modelController,
                        label: 'Model',
                        placeholder: _type == 'car' ? 'e.g., Camry, Civic, F-150' : 'e.g., CBR 600RR, R1, Ninja',
                        prefixIcon: const Icon(Icons.tag_rounded, size: 16, color: Color(0xFF5A5A6A)),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 20),

                      // Year Select
                      CustomDropdown<String>(
                        value: _year,
                        label: 'Year',
                        hint: 'Select year...',
                        icon: Icons.calendar_today_rounded,
                        items: _years,
                        itemLabelBuilder: (v) => v,
                        onChanged: (v) => setState(() => _year = v),
                      ),
                      const SizedBox(height: 20),

                      // Plate Input
                      CustomInput(
                        controller: _plateController,
                        label: 'License Plate',
                        placeholder: 'e.g., ABC-1234',
                        prefixIcon: const Icon(Icons.tag_rounded, size: 16, color: Color(0xFF5A5A6A)),
                        subHint: 'Letters, numbers, and hyphens only',
                        onChanged: (v) {
                          _plateController.text = v.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9-]'), '');
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 20),

                      // Mileage Input
                      CustomInput(
                        controller: _mileageController,
                        label: 'Starting Mileage (mi)',
                        placeholder: 'e.g., 25000',
                        prefixIcon: const Icon(Icons.speed_rounded, size: 16, color: Color(0xFF5A5A6A)),
                        keyboardType: TextInputType.number,
                        subHint: 'Current odometer reading',
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 32),

                      // Live Preview
                      if (_brand != null || _modelController.text.isNotEmpty) _buildPreviewCard(),
                      const SizedBox(height: 24),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              label: _isSaving ? 'Vehicle Saved' : 'Save Vehicle',
                              onPressed: _handleSave,
                              isEnabled: _isValid,
                              icon: _isSaving ? Icons.check_circle_rounded : Icons.directions_car_filled_rounded,
                            ),
                          ),
                        ],
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

  Widget _buildTypeButton(String type, IconData icon, String label) {
    final isActive = _type == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _type = type;
          _brand = null;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    colors: [Color(0xFFFF6B1A), Color(0xFFFF9C1A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(14),
            boxShadow: isActive
                ? [BoxShadow(color: const Color(0xFFFF6B1A).withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 4))]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isActive ? Colors.white : const Color(0xFF5A5A6A), size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : const Color(0xFF5A5A6A),
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    final title = [
      _brand,
      _modelController.text,
      _year
    ].where((e) => e != null && e.isNotEmpty).join(' ');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF222228)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B1A).withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFF6B1A).withOpacity(0.2)),
            ),
            child: Icon(
              _type == 'car' ? Icons.directions_car_filled_rounded : Icons.motorcycle_rounded,
              color: const Color(0xFFFF6B1A),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.isEmpty ? 'Your Vehicle' : title,
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (_plateController.text.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B1A).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFF6B1A).withOpacity(0.2)),
                    ),
                    child: Text(
                      _plateController.text.toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFFFF6B1A),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  )
                else
                  const Text('Plate not set', style: TextStyle(color: Color(0xFF4A4A5A), fontSize: 12)),
              ],
            ),
          ),
          if (_mileageController.text.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _mileageController.text,
                  style: const TextStyle(color: Color(0xFFFF9C1A), fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const Text('miles', style: TextStyle(color: Color(0xFF4A4A5A), fontSize: 11)),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
    required bool isEnabled,
    required IconData icon,
  }) {
    return InkWell(
      onTap: isEnabled ? onPressed : null,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _isSaving
              ? const Color(0xFF4CAF82)
              : isEnabled
                  ? null
                  : const Color(0xFF222228),
          gradient: !isEnabled || _isSaving
              ? null
              : const LinearGradient(
                  colors: [Color(0xFFFF6B1A), Color(0xFFFF9C1A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: (_isSaving ? const Color(0xFF4CAF82) : const Color(0xFFFF6B1A)).withOpacity(0.35),
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
              icon,
              color: isEnabled ? Colors.white : const Color(0xFF5A5A6A),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isEnabled ? Colors.white : const Color(0xFF5A5A6A),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
