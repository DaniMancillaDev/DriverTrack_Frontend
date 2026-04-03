import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface, // Background handles contrast (Tip 1)
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: AppColors.textDark, size: 16),
                const SizedBox(width: AppSpacing.md),
              ],
              Text(
                hint,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textDim,
                    ),
              ),
            ],
          ),
          isExpanded: true,
          dropdownColor: AppColors.surfaceLight,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textDark),
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: AppColors.textDark, size: 16),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Text(
                    itemLabelBuilder(item),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
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
          padding: const EdgeInsets.only(bottom: AppSpacing.xs, left: 4),
          child: Text(
            label!.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
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
