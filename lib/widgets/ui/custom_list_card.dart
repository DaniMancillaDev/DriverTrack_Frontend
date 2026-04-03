import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CustomListCard extends StatelessWidget {
  final Widget? leading;
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? child;
  final VoidCallback? onTap;
  final bool isSelected;
  final EdgeInsetsGeometry? padding;

  const CustomListCard({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.child,
    this.onTap,
    this.isSelected = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasChild = child != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        highlightColor: AppColors.orangePrimary.withValues(alpha: 0.1),
        splashColor: AppColors.orangePrimary.withValues(alpha: 0.1),
        hoverColor: Colors.white.withValues(alpha: 0.02),
        child: Ink(
          padding: padding ?? const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.orangePrimary.withValues(alpha: 0.08)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: isSelected 
                ? Border.all(
                    color: AppColors.orangePrimary.withValues(alpha: 0.4),
                    width: 1.5,
                  )
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.orangePrimary.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: hasChild 
            ? child! 
            : Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        if (title != null)
                          Text(
                            title!,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          subtitle!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textMuted,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: AppSpacing.md),
                  trailing!,
                ],
              ],
            ),
        ),
      ),
    );
  }
}
