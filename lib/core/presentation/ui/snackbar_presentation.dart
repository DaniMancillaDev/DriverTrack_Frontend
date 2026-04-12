import 'package:flutter/material.dart';
import '../../../core/responsive/responsive.dart';
import '../../../theme/app_theme.dart';

/// Accion CTA dentro de un SnackBar.
class NotificationAction {
  final String label;
  final VoidCallback onTap;
  const NotificationAction({required this.label, required this.onTap});
}

/// Helper estatico para mostrar SnackBars consistentes en toda la app.
/// Centraliza el patron ScaffoldMessenger para eliminar la duplicacion.
class SnackBarHelper {
  SnackBarHelper._();

  static void success(BuildContext context, String message) {
    _show(
      context,
      message,
      AppColors.green,
      Icons.check_circle_outline_rounded,
    );
  }

  static void error(BuildContext context, String message) {
    _show(context, message, AppColors.red, Icons.error_outline_rounded);
  }

  static void info(BuildContext context, String message) {
    _show(context, message, AppColors.cyan, Icons.info_outline_rounded);
  }

  static void warning(BuildContext context, String message) {
    _show(
      context,
      message,
      AppColors.orangeSecondary,
      Icons.warning_amber_rounded,
    );
  }

  /// SnackBar con botones de accion (CTA). No bloquea la UI.
  /// Duracion extendida (8s) para dar tiempo al usuario de actuar.
  static void action(
    BuildContext context, {
    required String message,
    required Color color,
    required IconData icon,
    required List<NotificationAction> actions,
  }) {
    final r = context.responsive;
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: r.dim(18)),
                SizedBox(width: r.space(AppSpacing.s)),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: r.dim(14),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: r.space(AppSpacing.s)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions.map((a) {
                final idx = actions.indexOf(a);
                return Padding(
                  padding: EdgeInsets.only(left: idx > 0 ? r.space(AppSpacing.xs) : 0),
                  child: TextButton(
                    onPressed: () {
                      messenger.clearSnackBars();
                      a.onTap();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: r.space(AppSpacing.md),
                        vertical: r.space(AppSpacing.xs),
                      ),
                      minimumSize: Size(0, r.dim(36)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: r.dim(13),
                      ),
                    ),
                    child: Text(a.label),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        margin: EdgeInsets.fromLTRB(r.space(AppSpacing.md), 0, r.space(AppSpacing.md), r.space(AppSpacing.md)),
        duration: const Duration(seconds: 8),
      ),
    );
  }

  static void _show(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    final r = context.responsive;
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: r.dim(18)),
            SizedBox(width: r.space(AppSpacing.s)),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: r.dim(14),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        margin: EdgeInsets.fromLTRB(r.space(AppSpacing.md), 0, r.space(AppSpacing.md), r.space(AppSpacing.md)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
