import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

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
      style: const TextStyle(color: AppColors.textMain, fontSize: 15),
      cursorColor: colorScheme.primary,
      decoration: InputDecoration(
        hintText: placeholder,
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: prefixIcon,
              )
            : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: suffixIcon,
              )
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        hintStyle: const TextStyle(color: AppColors.textDim, fontSize: 15),
        errorText: errorText,
        errorStyle: const TextStyle(fontSize: 12),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        
        // Default border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),

        // Focus state
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),

        // Error state
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1.5,
          ),
        ),

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.surfaceLight,
            width: 1,
          ),
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
            padding: const EdgeInsets.only(bottom: 8.0, left: 4),
            child: Text(
              label!.toUpperCase(),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
          ),
        input,
        if (subHint != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              subHint!,
              style: const TextStyle(color: AppColors.textDark, fontSize: 11),
            ),
          ),
      ],
    );
  }
}

