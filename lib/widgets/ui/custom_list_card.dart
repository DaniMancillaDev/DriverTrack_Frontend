import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_color_scheme.dart';

/// Una tarjeta especializada para elementos de lista con interacción rica.
/// 
/// Provee un contenedor interactivo ([InkWell]) con soporte visual para 
/// estados de selección, resaltando el borde y aplicando sombras sutiles. 
/// Es ideal para listar vehículos, servicios o cualquier entidad con metadatos.
class CustomListCard extends StatelessWidget {
  /// Widget opcional en el extremo izquierdo (ej: icono o avatar).
  final Widget? leading;
  /// Título principal de la entrada.
  final String? title;
  /// Texto de apoyo debajo del título.
  final String? subtitle;
  /// Widget opcional en el extremo derecho (ej: flecha o badge).
  final Widget? trailing;
  /// Contenido personalizado que reemplaza la estructura Row por defecto.
  final Widget? child;
  /// Callback al presionar la tarjeta.
  final VoidCallback? onTap;
  /// Indica si la tarjeta debe mostrar el estilo visual de selección.
  final bool isSelected;
  /// Espaciado interno de la tarjeta.
  final EdgeInsetsGeometry? padding;

  const CustomListCard({
    super.key,
    this.child, // Hijo opcional, retrocede a Row si es nulo
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.isSelected = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasChild = child != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        highlightColor: AppColors.orangePrimary.withValues(alpha: 0.1),
        splashColor: AppColors.orangePrimary.withValues(alpha: 0.1),
        hoverColor: Colors.white.withValues(alpha: 0.02),
        child: Ink(
          padding: padding ?? const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.orangePrimary.withValues(alpha: 0.08)
                : context.colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: isSelected
                ? Border.all(
                    color: AppColors.orangePrimary.withValues(alpha: 0.4),
                    width: 1.5,
                  )
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.orangePrimary.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: hasChild
              ? child!
              : Row(
                  children: [
                    if (leading != null) ...[
                      leading!,
                      const SizedBox(width: AppSpacing.md),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (title != null)
                            Text(
                              title!,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: context.colors.textMain,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          if (subtitle != null) ...[
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              subtitle!,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: context.colors.textMuted),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (trailing != null) ...[
                      const SizedBox(width: AppSpacing.md),
                      trailing!,
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
