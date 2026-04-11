import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Un componente de selección binaria personalizado.
/// 
/// Ofrece un diseño moderno con bordes redondeados y soporte integrado para 
/// etiquetas interactivas que expanden el área de interacción.
class CustomCheckbox extends StatelessWidget {
  /// Estado actual del checkbox.
  final bool value;
  /// Callback ejecutado cuando el estado cambia.
  final ValueChanged<bool?>? onChanged;
  /// Texto descriptivo opcional al lado del checkbox.
  final String? label;
  /// Controla la interactividad del widget.
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
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      side: BorderSide(
        color: colorScheme.outlineVariant, // border nativo
        width: 1,
      ),
      checkColor:
          colorScheme.onPrimary, // text-primary-foreground (icono palomita)
      fillColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (!enabled) {
          return colorScheme.onSurface.withValues(alpha: 0.12);
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
      borderRadius: BorderRadius.circular(AppRadius.xs),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xxs,
          horizontal: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            checkbox,
            const SizedBox(width: AppSpacing.xs),
            Text(
              label!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: enabled
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
