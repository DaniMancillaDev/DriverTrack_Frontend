import 'package:flutter/material.dart';

enum BadgeVariant {
  defaultVariant,
  secondary,
  destructive,
  outline,
}

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
    return CustomBadge(
      key: key,
      variant: variant,
      label: Text(text),
    );
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
        border = Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        );
        break;
      case BadgeVariant.defaultVariant:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6), // Equivalente as rounded-md de TW
        border: border,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2), // Equivalente px-2 py-0.5
      child: DefaultTextStyle(
        style: (Theme.of(context).textTheme.labelSmall ?? const TextStyle()).copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600, // Medium/SemiBold equivalentes a font-medium
              height: 1.2,
            ),
        child: label,
      ),
    );
  }
}
