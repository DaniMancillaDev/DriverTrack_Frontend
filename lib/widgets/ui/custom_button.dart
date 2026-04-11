import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_color_scheme.dart';

/// Variantes visuales soportadas para los botones de la aplicación.
enum ButtonVariant {
  /// Estilo corporativo base.
  defaultVariant,
  /// Acción de peligro o eliminación.
  destructive,
  /// Estilo con borde, ideal para acciones secundarias.
  outline,
  /// Estilo sutil de superficie.
  secondary,
  /// Sin fondo ni bordes, alta discreción.
  ghost,
  /// Estilo de enlace de texto puro.
  link,
  /// Estilo premium con gradiente de marca y sombras.
  gradient,
}

/// Escala de tamaños predefinidos para los botones.
enum ButtonSize { 
  /// Tamaño estándar (altura de 48px).
  defaultSize, 
  /// Tamaño compacto.
  sm, 
  /// Tamaño prominente (altura de 56px).
  lg, 
  /// Tamaño cuadrado para iconos.
  icon 
}

/// Orquestador de acciones táctiles altamente personalizable.
/// 
/// El [CustomButton] es el bloque fundamental de interacción. Su responsabilidad
/// es unificar los estilos visuales de la aplicación, gestionando automáticamente:
/// * **Estados de Carga**: Feedback visual proactivo mediante [isLoading].
/// * **Jerarquía Visual**: Soporte para múltiples variantes (gradientes, contornos, etc.).
/// * **Responsividad**: Adaptabilidad de tamaño y área de contacto física.
class CustomButton extends StatelessWidget {
  /// Función a ejecutar al presionar.
  final VoidCallback? onPressed;
  /// Contenido del botón (típicamente [Text] o [Icon]).
  final Widget child;
  /// Variante visual a aplicar.
  final ButtonVariant variant;
  /// Dimensiones del botón.
  final ButtonSize size;
  /// Muestra un indicador de progreso si es verdadero.
  final bool isLoading;
  /// Ancho personalizado opcional.
  final double? width;
  /// Colores personalizados para el gradiente (si se usa [ButtonVariant.gradient]).
  final List<Color>? gradientColors;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = ButtonVariant.defaultVariant,
    this.size = ButtonSize.defaultSize,
    this.isLoading = false,
    this.width,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    EdgeInsetsGeometry padding;
    double minWidth = 0;
    double minHeight = 0;
    double borderRadius = AppRadius.md;

    switch (size) {
      case ButtonSize.sm:
        padding = const EdgeInsets.symmetric(
          horizontal: AppSpacing.s,
          vertical: AppSpacing.xs,
        );
        minHeight = 36;
        borderRadius = AppRadius.s;
        break;
      case ButtonSize.lg:
        padding = const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        );
        minHeight = 56;
        borderRadius = AppRadius.lg;
        break;
      case ButtonSize.icon:
        padding = const EdgeInsets.all(AppSpacing.xs);
        minWidth = 44;
        minHeight = 44;
        borderRadius = AppRadius.md;
        break;
      case ButtonSize.defaultSize:
        padding = const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.s,
        );
        minHeight = 48;
        borderRadius = AppRadius.md;
        break;
    }

    // If loading, we use a different background (shimmer)
    if (isLoading && variant == ButtonVariant.gradient) {
      return Container(
        width: width ?? (size == ButtonSize.icon ? minWidth : double.infinity),
        height: minHeight,
        decoration: BoxDecoration(
          color: context.colors.surfaceLight,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            children: [
              const _ButtonShimmer(),
              Center(child: Opacity(opacity: 0.5, child: child)),
            ],
          ),
        ),
      );
    }

    final Widget buttonContent = isLoading
        ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
            ),
          )
        : child;

    if (variant == ButtonVariant.gradient) {
      final List<Color> colors =
          gradientColors ?? [colorScheme.primary, colorScheme.secondary];
      return Container(
        width: width ?? (size == ButtonSize.icon ? minWidth : double.infinity),
        height: minHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: colors.first.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: buttonContent,
        ),
      );
    }

    // Standard variants using Theme.of(context)
    switch (variant) {
      case ButtonVariant.destructive:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
            padding: padding,
            minimumSize: Size(width ?? minWidth, minHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: buttonContent,
        );

      case ButtonVariant.outline:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: colorScheme.onSurface,
            side: BorderSide(color: context.colors.border),
            padding: padding,
            minimumSize: Size(width ?? minWidth, minHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: buttonContent,
        );

      case ButtonVariant.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.surfaceLight,
            foregroundColor: colorScheme.onSurface,
            padding: padding,
            minimumSize: Size(width ?? minWidth, minHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: buttonContent,
        );

      case ButtonVariant.ghost:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: context.colors.textSecondary,
            padding: padding,
            minimumSize: Size(width ?? minWidth, minHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: buttonContent,
        );

      case ButtonVariant.link:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.cyan,
            padding: padding,
            minimumSize: Size(width ?? minWidth, minHeight),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
          child: buttonContent,
        );

      default:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: padding,
            minimumSize: Size(width ?? minWidth, minHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: buttonContent,
        );
    }
  }
}

class _ButtonShimmer extends StatefulWidget {
  const _ButtonShimmer();

  @override
  State<_ButtonShimmer> createState() => _ButtonShimmerState();
}

class _ButtonShimmerState extends State<_ButtonShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.colors.surfaceLight,
                context.colors.surfaceLight2,
                context.colors.surfaceLight,
              ],
              stops: [0.0, (_animation.value + 1) / 2, 1.0],
            ),
          ),
        );
      },
    );
  }
}
