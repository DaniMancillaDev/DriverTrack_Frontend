import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final bool enabled;

  const CustomCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Componente nativo checkbox base modificado a la apariencia Tailwind
    final Widget checkbox = Checkbox(
      value: value,
      onChanged: enabled ? onChanged : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4), // Equivalente a rounded-[4px]
      ),
      side: BorderSide(
        color: colorScheme.outlineVariant, // border nativo
        width: 1,
      ),
      checkColor: colorScheme.onPrimary, // text-primary-foreground (icono palomita)
      fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (!enabled) {
          return colorScheme.onSurface.withOpacity(0.12);
        }
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary; // bg-primary al estar seleccionado
        }
        return colorScheme.surface; // bg-input-background por defecto
      }),
      // Para asimilar el tamaño size-4 (16x16 px) podemos envolverlo en un SizedBox/Transform si vemos 
      // la versión nativa de Material muy grande, pero la recomendación actual es usar el tamaño 
      // mínimo clicable de Material (48x48 área de tap).
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, 
    );

    // Si no hay etiqueta, devuelve solo el Checkbox
    if (label == null) {
      return checkbox;
    }

    // Si hay etiqueta, ponlo en un Row amigable
    return InkWell(
      onTap: enabled
          ? () {
              if (onChanged != null) {
                onChanged!(!value);
              }
            }
          : null,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            checkbox,
            const SizedBox(width: 8),
            Text(
              label!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: enabled
                        ? colorScheme.onSurface
                        : colorScheme.onSurface.withOpacity(0.5),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
