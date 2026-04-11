import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../core/responsive/responsive.dart';
import '../../theme/app_color_scheme.dart';

/// Un campo de entrada de texto estandarizado para formularios.
/// 
/// Integra soporte para etiquetas, textos de ayuda inferiores, iconos de 
/// prefijo/sufijo y validaciones responsivas. Utiliza el esquema de colores 
/// de la aplicación para resaltar estados de enfoque y error.
class CustomInput extends StatelessWidget {
  /// Controlador de texto opcional.
  final TextEditingController? controller;
  /// Texto de ayuda dentro del campo.
  final String? placeholder;
  /// Etiqueta superior del campo.
  final String? label;
  /// Pequeño texto explicativo debajo del campo.
  final String? subHint;
  /// Valor inicial si no se usa controlador.
  final String? initialValue;
  /// Oculta el texto (útil para contraseñas).
  final bool obscureText;
  /// Tipo de teclado a mostrar.
  final TextInputType keyboardType;
  /// Texto de error manual.
  final String? errorText;
  /// Controla la edición del campo.
  final bool enabled;
  /// Cantidad de líneas permitidas.
  final int maxLines;
  /// Callback de cambio de valor.
  final void Function(String)? onChanged;
  /// Lógica de validación para formularios.
  final String? Function(String?)? validator;
  /// Máscaras y restricciones de entrada.
  final List<TextInputFormatter>? inputFormatters;
  /// Icono al inicio del campo.
  final Widget? prefixIcon;
  /// Icono al final del campo.
  final Widget? suffixIcon;
  /// Límite de caracteres.
  final int? maxLength;

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
    this.maxLength,
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
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      style: AppTextStyles.body(context).copyWith(color: context.colors.textMain),
      cursorColor: colorScheme.primary,
      decoration: InputDecoration(
        hintText: placeholder,
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: r.space(AppSpacing.s),
                ),
                child: prefixIcon,
              )
            : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: r.space(AppSpacing.s),
                ),
                child: suffixIcon,
              )
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        hintStyle: AppTextStyles.body(
          context,
        ).copyWith(color: context.colors.textDim),
        errorText: errorText,
        errorStyle: AppTextStyles.label(
          context,
        ).copyWith(color: colorScheme.error),
        filled: true,
        fillColor: context.colors.inputBackground,
        contentPadding: EdgeInsets.symmetric(
          horizontal: r.space(AppSpacing.md),
          vertical: r.space(AppSpacing.s),
        ),

        // Default border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
          borderSide: BorderSide(color: context.colors.border, width: 1.0),
        ),

        // Focus state
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),

        // Error state
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
          borderSide: BorderSide(color: colorScheme.error, width: 1),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
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
              style: AppTextStyles.label(
                context,
              ).copyWith(color: context.colors.textMain, letterSpacing: 0.8),
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
                color: context.colors.textDark,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
      ],
    );
  }
}
