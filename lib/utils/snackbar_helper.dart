import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Helper estático para mostrar SnackBars consistentes en toda la app.
/// Centraliza el patrón ScaffoldMessenger para eliminan la duplicación.
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

  static void _show(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
