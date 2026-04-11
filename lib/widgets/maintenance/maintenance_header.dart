// Removed dart:ui
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/i18n/translations.g.dart';
import '../../core/responsive/responsive.dart';
import '../../theme/app_color_scheme.dart';

/// Header sticky del Historial — idéntico al [GarageHeader] en estructura
/// y tratamiento visual para mantener consistencia de la app.
class MaintenanceHeader extends StatelessWidget {
  const MaintenanceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final r = context.responsive;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
      ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: r.value(mobile: 600, tablet: 700),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  r.space(AppSpacing.lg),
                  MediaQuery.of(context).padding.top + r.space(AppSpacing.xs),
                  r.space(AppSpacing.lg),
                  r.space(AppSpacing.md),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Texto: eyebrow + título principal
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Translations.of(context).maintenance.logSubtitle,
                            style: textTheme.bodySmall?.copyWith(
                              color: context.colors.textDim,
                            ),
                          ),
                          Text(
                            Translations.of(context).maintenance.logTitle,
                            style: textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Ícono decorativo de historial (espejo del badge de notificaciones)
                    Semantics(
                      label: Translations.of(context).maintenance.historyLabel,
                      header: true,
                      child: Container(
                        width: r.dim(48),
                        height: r.dim(48),
                        alignment: Alignment.center,
                        child: Container(
                          width: r.dim(42),
                          height: r.dim(42),
                          decoration: BoxDecoration(
                            color: AppColors.orangePrimary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
                            border: Border.all(
                              color: AppColors.orangePrimary.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.history_rounded,
                            color: AppColors.orangePrimary,
                            size: AppIconSizes.lg(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
