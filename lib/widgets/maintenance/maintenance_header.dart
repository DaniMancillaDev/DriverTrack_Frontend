import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/i18n/translations.g.dart';

class MaintenanceHeader extends StatelessWidget {
  final VoidCallback? onAddPressed;

  const MaintenanceHeader({super.key, this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, AppSpacing.lg, 0, AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Translations.of(context).maintenance.logTitle,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppColors.textMain,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            Translations.of(context).maintenance.logSubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
