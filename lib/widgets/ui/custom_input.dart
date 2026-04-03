import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../core/responsive/responsive.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final String? label;
  final String? subHint;
  final String? initialValue;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? errorText;
  final bool enabled;
  final int maxLines;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomInput({
    super.key,
    this.controller,
    this.placeholder,
    this.label,
    this.subHint,
    this.initialValue,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.enabled = true,
    this.maxLines = 1,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final r = context.responsive;

    Widget input = TextFormField(
      controller: controller,
      initialValue: initialValue,
      obscureText: obscureText,
      keyboardType: keyboardType,
      enabled: enabled,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      style: AppTextStyles.body(context),
      cursorColor: colorScheme.primary,
      decoration: InputDecoration(
        hintText: placeholder,
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: r.space(AppSpacing.s)),
                child: prefixIcon,
              )
            : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: r.space(AppSpacing.s)),
                child: suffixIcon,
              )
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        hintStyle: AppTextStyles.body(context).copyWith(
          color: AppColors.textDim,
        ),
        errorText: errorText,
        errorStyle: AppTextStyles.label(context).copyWith(
          color: colorScheme.error,
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: r.space(AppSpacing.md),
          vertical: r.space(AppSpacing.s),
        ),
        
        // Default border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
          borderSide: BorderSide.none, // Flattened form design (Tip 1)
        ),

        // Focus state
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),

        // Error state
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1.5,
          ),
        ),

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
          borderSide: BorderSide.none,
        ),
      ),
    );

    if (label == null && subHint == null) return input;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: EdgeInsets.only(
              bottom: r.space(AppSpacing.xs),
              left: r.space(AppSpacing.xxs),
            ),
            child: Text(
              label!.toUpperCase(),
              style: AppTextStyles.label(context).copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.6,
              ),
            ),
          ),
        input,
        if (subHint != null)
          Padding(
            padding: EdgeInsets.only(
              top: r.space(AppSpacing.xxs),
              left: r.space(AppSpacing.xxs),
            ),
            child: Text(
              subHint!,
              style: AppTextStyles.label(context).copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
      ],
    );
  }
}
