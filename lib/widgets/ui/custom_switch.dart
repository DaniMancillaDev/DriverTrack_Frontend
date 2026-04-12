import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Un interruptor tipo switch alineado con el sistema de diseño.
/// 
/// Provee una alternativa visual al [Checkbox], ideal para configuraciones
/// binarias directas. Incluye soporte para etiquetas laterales interactivas.
class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final bool enabled;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final Widget switchWidget = Switch(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeThumbColor: colorScheme.onPrimary, // Color del pulgar cuando está activo
      activeTrackColor: colorScheme.primary, // bg-primary cuando está activo
      inactiveThumbColor: colorScheme.surface, // bg-card del pulgar cuando está inactivo
      inactiveTrackColor:
          colorScheme.surfaceContainerHighest, // bg-switch-background
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (states) => Colors.transparent, // Tailwind usa border-transparent
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    if (label == null) {
      return switchWidget;
    }

    return InkWell(
      onTap: enabled
          ? () {
              if (onChanged != null) onChanged!(!value);
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
            switchWidget,
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
