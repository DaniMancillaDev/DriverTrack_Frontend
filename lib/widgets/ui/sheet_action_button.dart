import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/responsive/responsive.dart';
import 'custom_button.dart';
import '../../theme/app_color_scheme.dart';

/// Un botón de acción principal específicamente diseñado para hojas modales (Sheets).
/// 
/// Orquesta múltiples estados de interacción:
/// * **Carga**: Muestra un spinner mientras se procesa la acción.
/// * **Éxito**: Cambia el color a verde y actualiza el icono/etiqueta para 
///   confirmar el resultado positivo.
/// * **Bloqueado**: Gestiona la interactividad basado en [isEnabled].
class SheetActionButton extends StatelessWidget {
  /// Etiqueta de texto por defecto.
  final String label;
  /// Etiqueta a mostrar cuando [isSuccess] es verdadero.
  final String? successLabel;
  /// Callback al presionar el botón.
  final VoidCallback onPressed;
  /// Controla la interactividad del botón.
  final bool isEnabled;
  /// Muestra el estado de carga.
  final bool isLoading;
  /// Muestra el estado de confirmación positiva.
  final bool isSuccess;
  /// Icono por defecto.
  final IconData icon;
  /// Icono a mostrar cuando [isSuccess] es verdadero.
  final IconData? successIcon;

  const SheetActionButton({
    super.key,
    required this.label,
    this.successLabel,
    required this.onPressed,
    this.isEnabled = true,
    this.isLoading = false,
    this.isSuccess = false,
    required this.icon,
    this.successIcon,
  });

  @override
  Widget build(BuildContext context) {
    final displayLabel = isSuccess ? (successLabel ?? label) : label;
    final displayIcon = isSuccess ? (successIcon ?? icon) : icon;

    return CustomButton(
      onPressed: isEnabled && !isLoading && !isSuccess ? onPressed : null,
      variant: ButtonVariant.gradient,
      isLoading: isLoading,
      gradientColors: isSuccess
          ? [AppColors.green, AppColors.green.withValues(alpha: 0.8)]
          : (isEnabled ? null : [context.colors.surface, context.colors.surface]),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Row(
          key: ValueKey('${isSuccess}_$isLoading'),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              displayIcon,
              color: isEnabled ? Colors.white : context.colors.textDark,
              size: AppIconSizes.lg(context),
            ),
            SizedBox(width: context.responsive.space(AppSpacing.xs)),
            Text(
              displayLabel,
              style: AppTextStyles.button(
                context,
              ).copyWith(color: isEnabled ? Colors.white : context.colors.textDark),
            ),
          ],
        ),
      ),
    );
  }
}
