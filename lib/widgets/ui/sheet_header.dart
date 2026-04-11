import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/responsive/responsive.dart';
import '../../theme/app_color_scheme.dart';

class SheetHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onClose;
  final Widget? trailing;

  const SheetHeader({
    super.key,
    required this.title,
    this.subtitle,
    required this.onClose,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.display(
                  context,
                ).copyWith(color: context.colors.textMain, letterSpacing: -0.3),
              ),
              if (subtitle != null) ...[
                SizedBox(height: r.space(AppSpacing.xxs)),
                Text(
                  subtitle!,
                  style: AppTextStyles.bodySmall(
                    context,
                  ).copyWith(color: context.colors.textDark),
                ),
              ],
            ],
          ),
        ),
        Row(
          children: [
            if (trailing != null) ...[
              trailing!,
              SizedBox(width: r.space(AppSpacing.xs)),
            ],
            Semantics(
              button: true,
              label: 'Cerrar',
              child: IconButton(
                onPressed: onClose,
                icon: Icon(
                  Icons.close,
                  color: context.colors.textMuted,
                  size: AppIconSizes.md(context),
                ),
                style: IconButton.styleFrom(
                  backgroundColor: context.colors.surfaceLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
