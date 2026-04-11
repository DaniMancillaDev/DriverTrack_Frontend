import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/responsive/responsive.dart';

/// Un botón de acción flotante (FAB) con estética premium y expansible.
/// 
/// Utiliza el gradiente de marca y elevación dinámica para destacar como la 
/// acción principal de la pantalla. Soporta un estado expandido ([isExtended]) 
/// que muestra una etiqueta de texto animada junto al icono.
class PremiumFAB extends StatelessWidget {
  /// Callback ejecutado al presionar el botón.
  final VoidCallback onPressed;
  /// Etiqueta de texto a mostrar cuando está extendido.
  final String label;
  /// Icono representativo de la acción.
  final IconData icon;
  /// Controla si el botón se muestra en formato circular (compacto) o extendido.
  final bool isExtended;

  const PremiumFAB({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
    this.isExtended = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final r = context.responsive;

    return Container(
      height: r.dim(56),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppRadius.full),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: r.space(AppSpacing.md),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: AppIconSizes.xl(context),
                ),
                // AnimatedSize hace que el ancho colapse/expande suavemente
                AnimatedSize(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeInOutCubic,
                  child: isExtended
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: r.space(AppSpacing.s)),
                            // AnimatedSwitcher para fade in/out del texto
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              transitionBuilder: (child, animation) =>
                                  FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                              child: Text(
                                label,
                                key: const ValueKey('fab_label'),
                                style: AppTextStyles.body(context).copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
