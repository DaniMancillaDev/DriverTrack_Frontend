import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/responsive/responsive.dart';
import 'custom_button.dart';

class SheetActionButton extends StatelessWidget {
  final String label;
  final String? successLabel;
  final VoidCallback onPressed;
  final bool isEnabled;
  final bool isLoading;
  final bool isSuccess;
  final IconData icon;
  final IconData? successIcon;

  const SheetActionButton({
    super.key,
    required this.label,
    this.successLabel,
    required this.onPressed,
    this.isEnabled = true,
    this.isLoading = false,
    this.isSuccess = false,
    required this.icon,
    this.successIcon,
  });

  @override
  Widget build(BuildContext context) {
    final displayLabel = isSuccess ? (successLabel ?? label) : label;
    final displayIcon = isSuccess ? (successIcon ?? icon) : icon;

    return CustomButton(
      onPressed: isEnabled && !isLoading && !isSuccess ? onPressed : null,
      variant: ButtonVariant.gradient,
      isLoading: isLoading,
      gradientColors: isSuccess
          ? [AppColors.green, AppColors.green.withValues(alpha: 0.8)]
          : (isEnabled ? null : [AppColors.surface, AppColors.surface]),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Row(
          key: ValueKey('${isSuccess}_$isLoading'),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              displayIcon,
              color: isEnabled ? Colors.white : AppColors.textDark,
              size: AppIconSizes.lg(context),
            ),
            SizedBox(width: context.responsive.space(AppSpacing.xs)),
            Text(
              displayLabel,
              style: AppTextStyles.button(context).copyWith(
                color: isEnabled ? Colors.white : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
