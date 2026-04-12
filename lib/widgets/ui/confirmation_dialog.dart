import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/responsive/responsive.dart';
import '../../theme/app_color_scheme.dart';

/// Orquestador de validación para acciones críticas de usuario.
/// 
/// Su responsabilidad es proporcionar un punto de control táctil antes de ejecutar 
/// operaciones destructivas o irreversibles. Utiliza un [showModalBottomSheet] 
/// para priorizar la accesibilidad ergonómica en dispositivos móviles.
class ConfirmationDialog extends StatelessWidget {
  /// Título del diálogo (ej: "¿Eliminar vehículo?").
  final String title;
  /// Descripción detallada de las consecuencias de la acción.
  final String message;
  /// Etiqueta del botón de acción principal.
  final String confirmLabel;
  /// Color semántico para el botón de confirmación (ej: [AppColors.red] para borrar).
  final Color confirmColor;
  /// Callback ejecutado al confirmar la acción.
  final VoidCallback onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Eliminar',
    this.confirmColor = AppColors.red,
    required this.onConfirm,
  });

  /// Método estático para disparar el diálogo de forma declarativa.
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Eliminar',
    Color confirmColor = AppColors.red,
    required VoidCallback onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        confirmColor: confirmColor,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return Container(
      padding: EdgeInsets.fromLTRB(
        r.space(AppSpacing.lg),
        r.space(AppSpacing.lg),
        r.space(AppSpacing.lg),
        MediaQuery.of(context).padding.bottom + r.space(AppSpacing.lg),
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(r.r(AppRadius.xxl)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: r.dim(36),
              height: r.dim(4),
              margin: EdgeInsets.only(bottom: r.space(AppSpacing.lg)),
              decoration: BoxDecoration(
                color: context.colors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Icon
          Container(
            width: r.dim(48),
            height: r.dim(48),
            decoration: BoxDecoration(
              color: confirmColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
            ),
            child: Icon(
              Icons.delete_outline_rounded,
              color: confirmColor,
              size: AppIconSizes.lg(context),
            ),
          ),
          SizedBox(height: r.space(AppSpacing.md)),

          Text(
            title,
            style: AppTextStyles.sheetTitle(
              context,
            ).copyWith(color: context.colors.textMain),
          ),
          SizedBox(height: r.space(AppSpacing.xs)),
          Text(
            message,
            style: AppTextStyles.bodyMedium(
              context,
            ).copyWith(color: context.colors.textSecondary, height: 1.5),
          ),
          SizedBox(height: r.space(AppSpacing.xl)),

          // Actions
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: r.space(AppSpacing.md),
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.surfaceLight,
                      borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Cancelar',
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: context.colors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: r.space(AppSpacing.s)),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: r.space(AppSpacing.md),
                    ),
                    decoration: BoxDecoration(
                      color: confirmColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      confirmLabel,
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: confirmColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
