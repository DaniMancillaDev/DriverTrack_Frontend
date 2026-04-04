import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/responsive/responsive.dart';
import '../ui/custom_switch.dart';
import '../../theme/app_color_scheme.dart';

class ProfileToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color accent;
  final String? subtitle;
  final bool showBottomBorder;

  const ProfileToggleRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.accent,
    this.subtitle,
    this.showBottomBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.space(AppSpacing.md),
        vertical: r.space(AppSpacing.s),
      ),
      decoration: const BoxDecoration(
        color: Colors
            .transparent, // Replaced explicit background and borders to maintain whitespace flow (Tip 1)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodyMedium(
                    context,
                  ).copyWith(color: context.colors.textSecondary),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTextStyles.label(context).copyWith(color: accent),
                  ),
              ],
            ),
          ),
          CustomSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class ProfileSelectionRow extends StatelessWidget {
  final String label;
  final List<String> options;
  final List<String>? displayLabels;
  final ValueChanged<String> onChanged;
  final String currentValue;
  final Color accent;
  final bool showBottomBorder;

  const ProfileSelectionRow({
    super.key,
    required this.label,
    required this.options,
    this.displayLabels,
    required this.onChanged,
    required this.currentValue,
    required this.accent,
    this.showBottomBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.space(AppSpacing.md),
        vertical: r.space(AppSpacing.s),
      ),
      decoration: const BoxDecoration(
        color: Colors
            .transparent, // Cleaner UI flow without slicing borders (Tip 1)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.bodyMedium(
                context,
              ).copyWith(color: context.colors.textSecondary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: options.asMap().entries.map((entry) {
              final idx = entry.key;
              final opt = entry.value;
              final displayLabel =
                  (displayLabels != null && idx < displayLabels!.length)
                  ? displayLabels![idx]
                  : opt;
              final isSelected = opt == currentValue;
              return GestureDetector(
                onTap: () => onChanged(opt),
                child: Container(
                  margin: EdgeInsets.only(left: r.space(AppSpacing.xs)),
                  padding: EdgeInsets.symmetric(
                    horizontal: r.space(10),
                    vertical: r.space(4),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Simplified background (Tip 2)
                    borderRadius: BorderRadius.circular(r.r(AppRadius.s)),
                  ),
                  child: Text(
                    displayLabel,
                    style: AppTextStyles.label(context).copyWith(
                      color: isSelected ? accent : context.colors.textMuted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class ProfileSecurityButton extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final String actionLabel;
  final VoidCallback? onTap;

  const ProfileSecurityButton({
    super.key,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.actionLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.space(AppSpacing.md),
        vertical: r.space(AppSpacing.s),
      ),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: r.dim(34),
                  height: r.dim(34),
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Flattened icon container
                    borderRadius: BorderRadius.circular(r.r(AppRadius.s)),
                  ),
                  child: Icon(
                    icon,
                    size: AppIconSizes.sm(context),
                    color: context.colors.textMuted,
                  ),
                ),
                SizedBox(width: r.space(AppSpacing.s)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: AppTextStyles.bodySmall(context).copyWith(
                          color: context.colors.textMain,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: AppTextStyles.label(
                          context,
                        ).copyWith(color: context.colors.textSecondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: r.space(AppSpacing.s)),
              minimumSize: Size(0, r.dim(32)),
              backgroundColor: context.colors.surfaceLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(r.r(AppRadius.s)),
              ),
            ),
            child: Text(
              actionLabel,
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
