import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_color_scheme.dart';

/// Un selector de opciones desplegable genérico y tipado.
/// 
/// Permite seleccionar un elemento de una lista de tipo [T], utilizando 
/// una etiqueta opcional y un constructor de etiquetas personalizado para la UI.
class CustomDropdown<T> extends StatelessWidget {
  /// Valor seleccionado actualmente.
  final T? value;
  /// Etiqueta superior opcional del campo.
  final String? label;
  /// Texto de ayuda cuando no hay selección.
  final String hint;
  /// Icono opcional a mostrar junto a las opciones.
  final IconData? icon;
  /// Lista de opciones disponibles.
  final List<T> items;
  /// Función para determinar el texto a mostrar por cada item de tipo [T].
  final String Function(T) itemLabelBuilder;
  /// Callback ejecutado al seleccionar una nueva opción.
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
        color: context.colors.surface, // Background handles contrast (Tip 1)
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: context.colors.textMain,
          ),
          hint: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: context.colors.textDark, size: 16),
                const SizedBox(width: AppSpacing.md),
              ],
              Text(
                hint,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: context.colors.textDim),
              ),
            ],
          ),
          isExpanded: true,
          dropdownColor: context.colors.surfaceLight,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: context.colors.textDark,
          ),
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: context.colors.textDark, size: 16),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Text(
                    itemLabelBuilder(item),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: context.colors.textMain),
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
              color: context.colors.textSecondary,
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
