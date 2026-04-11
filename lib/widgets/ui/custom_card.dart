import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Contenedor base con bordes redondeados y estilo unificado.
/// 
/// Implementa una superficie [Card] personalizada que sigue el sistema de radios 
/// y bordes de la aplicación, optimizada para visualización plana (sin elevación).
class CustomCard extends StatelessWidget {
  /// Contenido principal de la tarjeta.
  final Widget child;
  /// Espaciado interno opcional.
  final EdgeInsetsGeometry? padding;
  /// Color de fondo personalizado. Si es nulo, usa el por defecto del tema.
  final Color? backgroundColor;
  /// Márgenes exteriores opcionales.
  final EdgeInsetsGeometry? margin;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin ?? EdgeInsets.zero,
      color: backgroundColor ?? Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      elevation: 0, // En la web suele ser sin elevación (flat)
      child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
    );
  }
}

/// Encabezado estandarizado para usar dentro de un [CustomCard].
/// 
/// Organiza un título, una descripción y una acción opcional en la parte superior.
class CustomCardHeader extends StatelessWidget {
  final Widget? title;
  final Widget? description;
  final Widget? action;
  final EdgeInsetsGeometry padding;

  const CustomCardHeader({
    super.key,
    this.title,
    this.description,
    this.action,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.xl,
      AppSpacing.xl,
      AppSpacing.xl,
      AppSpacing.xxs,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) title!,
                if (title != null && description != null)
                  const SizedBox(height: AppSpacing.xxs),
                // ignore: use_null_aware_elements
                if (description != null) description!,
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: AppSpacing.md),
            action!,
          ],
        ],
      ),
    );
  }
}

class CustomCardTitle extends StatelessWidget {
  final String text;

  const CustomCardTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        height: 1,
        letterSpacing: -0.5,
      ),
    );
  }
}

class CustomCardDescription extends StatelessWidget {
  final String text;

  const CustomCardDescription(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class CustomCardContent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const CustomCardContent({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.xl,
      vertical: AppSpacing.md,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding, child: child);
  }
}

class CustomCardFooter extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const CustomCardFooter({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.xl,
      AppSpacing.xxs,
      AppSpacing.xl,
      AppSpacing.xl,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding, child: child);
  }
}
