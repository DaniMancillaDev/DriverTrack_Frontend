import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_color_scheme.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/i18n/translations.g.dart';
import '../../../widgets/ui/custom_button.dart';

/// Accion CTA dentro de una notificacion [AppNotification].
class AppNotificationAction {
  /// Etiqueta visible del boton.
  final String label;

  /// Si es true, el boton usa estilo destacado (filled).
  /// Si es false, usa estilo secundario (outline).
  final bool isPrimary;

  /// Callback ejecutado al presionar la accion.
  /// El dialogo se cierra automaticamente antes de ejecutar este callback.
  final VoidCallback onPressed;

  const AppNotificationAction({
    required this.label,
    this.isPrimary = false,
    required this.onPressed,
  });
}

/// Notificacion modal centrada reutilizable.
///
/// Diseño consistente con el theme global: usa [CustomButton] con variantes
/// para jerarquia visual, [Wrap] para overflow en pantallas pequenas,
/// y [context.colors] para colores adaptativos.
///
/// Soporta una o multiples acciones dinamicas. Si no se especifican acciones,
/// muestra un boton "Entendido" por defecto (compatibilidad hacia atras).
class AppNotification extends StatelessWidget {
  /// Titulo principal de la notificacion.
  final String? title;

  /// Mensaje descriptivo debajo del titulo.
  final String message;

  /// Icono mostrado dentro del circulo tintado.
  final IconData icon;

  /// Color semantico del icono y su fondo tintado.
  /// Por defecto [AppColors.orangeSecondary].
  final Color iconColor;

  /// Lista de acciones (botones CTA).
  /// Si esta vacia, se muestra un unico boton "Entendido" que cierra el dialogo.
  final List<AppNotificationAction> actions;

  const AppNotification({
    super.key,
    this.title,
    required this.message,
    required this.icon,
    this.iconColor = AppColors.orangeSecondary,
    this.actions = const [],
  });

  /// Muestra la notificacion como dialogo modal centrado.
  ///
  /// Retorna un [Future<void>] que se completa al cerrar el dialogo.
  static Future<void> show(
    BuildContext context, {
    String? title,
    required String message,
    required IconData icon,
    Color iconColor = AppColors.orangeSecondary,
    List<AppNotificationAction> actions = const [],
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => AppNotification(
        title: title,
        message: message,
        icon: icon,
        iconColor: iconColor,
        actions: actions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return AlertDialog(
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      icon: Container(
        padding: EdgeInsets.all(r.space(AppSpacing.md)),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.10),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: r.dim(36),
        ),
      ),
      title: title != null
          ? Text(
              title!,
              style: AppTextStyles.sheetTitle(context),
              textAlign: TextAlign.center,
            )
          : null,
      content: Text(
        message,
        style: AppTextStyles.bodySmall(context).copyWith(
          color: context.colors.textMuted,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: EdgeInsets.fromLTRB(
        r.space(AppSpacing.lg),
        0,
        r.space(AppSpacing.lg),
        r.space(AppSpacing.md),
      ),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final t = Translations.of(context);

    // Sin acciones: boton "Entendido" por defecto
    if (actions.isEmpty) {
      return [
        CustomButton(
          onPressed: () => Navigator.pop(context),
          variant: ButtonVariant.ghost,
          size: ButtonSize.sm,
          child: Text(t.maintenance.understood),
        ),
      ];
    }

    // Una sola accion: boton centrado
    if (actions.length == 1) {
      final a = actions.first;
      return [
        CustomButton(
          onPressed: () {
            Navigator.pop(context);
            a.onPressed();
          },
          variant: a.isPrimary ? ButtonVariant.defaultVariant : ButtonVariant.ghost,
          size: ButtonSize.sm,
          child: Text(a.label),
        ),
      ];
    }

    // Multiples acciones: Wrap para overflow en pantallas pequenas
    return [
      Wrap(
        alignment: WrapAlignment.center,
        spacing: context.responsive.space(AppSpacing.s),
        runSpacing: context.responsive.space(AppSpacing.xs),
        children: actions.map((a) {
          return CustomButton(
            onPressed: () {
              Navigator.pop(context);
              a.onPressed();
            },
            variant: a.isPrimary ? ButtonVariant.defaultVariant : ButtonVariant.outline,
            size: ButtonSize.sm,
            child: Text(a.label),
          );
        }).toList(),
      ),
    ];
  }
}
