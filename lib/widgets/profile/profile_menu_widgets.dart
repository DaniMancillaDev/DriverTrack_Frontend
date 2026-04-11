import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/responsive/responsive.dart';
import '../ui/custom_list_card.dart';
import '../../theme/app_color_scheme.dart';

class ProfileExpandableContainer extends StatelessWidget {
  final bool isOpen;
  final Widget header;
  final List<Widget> children;

  const ProfileExpandableContainer({
    super.key,
    required this.isOpen,
    required this.header,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    return ClipRRect(
      borderRadius: BorderRadius.circular(r.r(AppRadius.xl)),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(r.r(AppRadius.xl)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(children: [header, if (isOpen) ...children]),
      ),
    );
  }
}

class ProfileMenuRow extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool borderBottom;
  final bool showBottomBorder;

  const ProfileMenuRow({
    super.key,
    required this.icon,
    required this.accent,
    required this.label,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.borderBottom = true,
    this.showBottomBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    return CustomListCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: r.space(AppSpacing.md),
          vertical: r.space(AppSpacing.s),
        ),
        child: Row(
          children: [
            // Simplified Icon: no heavy tinted box to reduce visual noise (Tip 2)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: r.space(AppSpacing.xs)),
              child: Icon(icon, color: accent, size: AppIconSizes.md(context)),
            ),
            SizedBox(width: r.space(AppSpacing.md)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.body(context).copyWith(
                      color: context.colors.textMain,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: AppTextStyles.caption(
                        context,
                      ).copyWith(color: context.colors.textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else
              Icon(
                Icons.chevron_right,
                size: AppIconSizes.sm(context),
                color: context.colors.surfaceLight2,
              ),
          ],
        ),
      ),
    );
  }
}

class ProfileBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const ProfileBadge({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.space(AppSpacing.s),
        vertical: r.space(AppSpacing.xxs),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppIconSizes.xs(context), color: color),
          SizedBox(width: r.space(6)),
          Text(
            label,
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class ProfileSimpleRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool showBottomBorder;
  final VoidCallback? onTap;

  const ProfileSimpleRow({
    super.key,
    required this.label,
    required this.icon,
    this.showBottomBorder = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: r.space(AppSpacing.md),
          vertical: r.space(AppSpacing.s),
        ),
        color: Colors
            .transparent, // Removed heavy bottom borders and solid background for cleaner whitespace (Tip 1)
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: AppIconSizes.sm(context),
                    color: context.colors.textSecondary,
                  ),
                  SizedBox(width: r.space(AppSpacing.s)),
                  Expanded(
                    child: Text(
                      label,
                      style: AppTextStyles.bodyMedium(
                        context,
                      ).copyWith(color: context.colors.textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: AppIconSizes.sm(context),
              color: context.colors.surfaceLight2,
            ),
          ],
        ),
      ),
    );
  }
}
