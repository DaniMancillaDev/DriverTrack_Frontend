import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'package:intl/intl.dart';
import '../../theme/app_color_scheme.dart';

/// Un selector de fecha integrado diseñado para formularios limpios.
/// 
/// A diferencia de los pickers nativos invasivos, este widget separa el 
/// día, mes y año en tres campos seleccionables que abren hojas modales 
/// para una entrada de datos rápida y táctil.
class InlineDatePicker extends StatefulWidget {
  /// Fecha seleccionada inicialmente.
  final DateTime initialDate;
  /// Notifica cambios de fecha al widget padre.
  final ValueChanged<DateTime> onChanged;

  const InlineDatePicker({
    super.key,
    required this.initialDate,
    required this.onChanged,
  });

  @override
  State<InlineDatePicker> createState() => _InlineDatePickerState();
}

class _InlineDatePickerState extends State<InlineDatePicker> {
  late int _selectedDay;
  late int _selectedMonth;
  late int _selectedYear;

  final List<int> _days = List.generate(31, (i) => i + 1);
  final List<int> _months = List.generate(12, (i) => i + 1);
  final List<int> _years = List.generate(30, (i) => DateTime.now().year - i);

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDate.day;
    _selectedMonth = widget.initialDate.month;
    _selectedYear = widget.initialDate.year;
  }

  void _updateDate() {
    int maxDays = DateTime(_selectedYear, _selectedMonth + 1, 0).day;
    if (_selectedDay > maxDays) {
      _selectedDay = maxDays;
    }
    widget.onChanged(DateTime(_selectedYear, _selectedMonth, _selectedDay));
    setState(() {});
  }

  Widget _buildField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: context.colors.background,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Column(
            children: [
              Text(
                label.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: context.colors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: context.colors.textMain,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showSelector(
    String title,
    List<int> items,
    int current,
    ValueChanged<int> onSelected,
  ) async {
    final theme = Theme.of(context);
    await showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.colors.borderLight,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: context.colors.textMain,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = item == current;
                    return ListTile(
                      title: Center(
                        child: Text(
                          item.toString().padLeft(2, '0'),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: isSelected
                                ? AppColors.orangePrimary
                                : context.colors.textMain,
                            fontWeight: isSelected
                                ? FontWeight.w800
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                      onTap: () {
                        onSelected(item);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildField(
          label: 'Día',
          value: _selectedDay.toString().padLeft(2, '0'),
          onTap: () => _showSelector('Día', _days, _selectedDay, (v) {
            _selectedDay = v;
            _updateDate();
          }),
        ),
        const SizedBox(width: AppSpacing.s),
        _buildField(
          label: 'Mes',
          value: DateFormat.MMM(Localizations.localeOf(context).languageCode).format(DateTime(2020, _selectedMonth)),
          onTap: () => _showSelector('Mes', _months, _selectedMonth, (v) {
            _selectedMonth = v;
            _updateDate();
          }),
        ),
        const SizedBox(width: AppSpacing.s),
        _buildField(
          label: 'Año',
          value: _selectedYear.toString(),
          onTap: () => _showSelector('Año', _years, _selectedYear, (v) {
            _selectedYear = v;
            _updateDate();
          }),
        ),
      ],
    );
  }
}
