import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Variantes visuales soportadas por el sistema de etiquetas.
enum BadgeVariant { 
  /// Estilo principal basado en el color primario.
  defaultVariant, 
  /// Estilo neutral basado en el color secundario.
  secondary, 
  /// Estilo de alerta basado en el color de error.
  destructive, 
  /// Estilo con borde y fondo transparente.
  outline 
}

/// Un componente de etiqueta (badge) para mostrar estados, categorías o contadores.
/// 
/// El [CustomBadge] adapta automáticamente su paleta de colores según la [variant]
/// seleccionada, asegurando consistencia con el esquema de colores global.
class CustomBadge extends StatelessWidget {
  final Widget label;
  final BadgeVariant variant;

  const CustomBadge({
    super.key,
    required this.label,
    this.variant = BadgeVariant.defaultVariant,
  });

  /// Constructor útil si se quiere enviar una cadena de texto en vez de widget.
  factory CustomBadge.text(
    String text, {
    Key? key,
    BadgeVariant variant = BadgeVariant.defaultVariant,
  }) {
    return CustomBadge(key: key, variant: variant, label: Text(text));
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color foregroundColor;
    BoxBorder? border;

    final colorScheme = Theme.of(context).colorScheme;

    switch (variant) {
      case BadgeVariant.secondary:
        backgroundColor = colorScheme.secondary;
        foregroundColor = colorScheme.onSecondary;
        break;
      case BadgeVariant.destructive:
        backgroundColor = colorScheme.error;
        foregroundColor = colorScheme.onError;
        break;
      case BadgeVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.onSurface;
        border = Border.all(color: colorScheme.outlineVariant, width: 1);
        break;
      case BadgeVariant.defaultVariant:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.s),
        border: border,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      child: DefaultTextStyle(
        style: (Theme.of(context).textTheme.labelSmall ?? const TextStyle())
            .copyWith(
              color: foregroundColor,
              fontWeight:
                  FontWeight.w600, // Medium/SemiBold equivalentes a font-medium
              height: 1.2,
            ),
        child: label,
      ),
    );
  }
}
