import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

enum ButtonVariant {
  defaultVariant,
  destructive,
  outline,
  secondary,
  ghost,
  link,
  gradient, // New premium variant
}

enum ButtonSize {
  defaultSize,
  sm,
  lg,
  icon,
}

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final double? width;
  final List<Color>? gradientColors;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = ButtonVariant.defaultVariant,
    this.size = ButtonSize.defaultSize,
    this.isLoading = false,
    this.width,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding;
    double minWidth = 0;
    double minHeight = 0;
    double borderRadius = 16; // Increased for premium feel

    switch (size) {
      case ButtonSize.sm:
        padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
        minHeight = 36;
        borderRadius = 12;
        break;
      case ButtonSize.lg:
        padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
        minHeight = 56;
        borderRadius = 18;
        break;
      case ButtonSize.icon:
        padding = const EdgeInsets.all(8);
        minWidth = 44;
        minHeight = 44;
        borderRadius = 14;
        break;
      case ButtonSize.defaultSize:
        padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
        minHeight = 48;
        borderRadius = 16;
        break;
    }

    final Widget buttonContent = isLoading
        ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : child;

    if (variant == ButtonVariant.gradient) {
      final List<Color> colors = gradientColors ?? [AppColors.orangePrimary, AppColors.orangeSecondary];
      return Container(
        width: width ?? (size == ButtonSize.icon ? minWidth : double.infinity),
        height: minHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            padding: padding,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          ),
          child: buttonContent,
        ),
      );
    }

    // Standard variants using AppColors
    switch (variant) {
      case ButtonVariant.destructive:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.red,
            foregroundColor: Colors.white,
            padding: padding,
            minimumSize: Size(width ?? minWidth, minHeight),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          ),
          child: buttonContent,
        );

      case ButtonVariant.outline:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textMain,
            side: const BorderSide(color: AppColors.border),
            padding: padding,
            minimumSize: Size(width ?? minWidth, minHeight),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          ),
          child: buttonContent,
        );

      case ButtonVariant.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textMain,
            padding: padding,
            minimumSize: Size(width ?? minWidth, minHeight),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          ),
          child: buttonContent,
        );

      case ButtonVariant.ghost:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            padding: padding,
            minimumSize: Size(width ?? minWidth, minHeight),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          ),
          child: buttonContent,
        );

      case ButtonVariant.link:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.cyan,
            padding: padding,
            minimumSize: Size(width ?? minWidth, minHeight),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
          child: buttonContent,
        );

      default:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orangePrimary,
            foregroundColor: Colors.white,
            padding: padding,
            minimumSize: Size(width ?? minWidth, minHeight),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          ),
          child: buttonContent,
        );
    }
  }
}
