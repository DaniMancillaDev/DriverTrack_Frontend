import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final String? label;
  final String hint;
  final IconData? icon;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final void Function(T?) onChanged;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.itemLabelBuilder,
    required this.onChanged,
    this.label,
    this.hint = 'Select option...',
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Widget dropdown = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF222228)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: const Color(0xFF5A5A6A), size: 16),
                const SizedBox(width: 12),
              ],
              Text(
                hint,
                style: const TextStyle(color: Color(0xFF4A4A5A), fontSize: 15),
              ),
            ],
          ),
          isExpanded: true,
          dropdownColor: const Color(0xFF1C1C24),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF5A5A6A)),
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: const Color(0xFF5A5A6A), size: 16),
                    const SizedBox(width: 12),
                  ],
                  Text(
                    itemLabelBuilder(item),
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );

    if (label == null) return dropdown;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 4),
          child: Text(
            label!.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF9E9EAE),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
        ),
        dropdown,
      ],
    );
  }
}
