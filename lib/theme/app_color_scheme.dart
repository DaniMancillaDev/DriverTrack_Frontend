import 'package:flutter/material.dart';

/// Tokens de color adaptativos por tema.
///
/// Uso: `context.colors.background`, `context.colors.textMain`, etc.
///
/// Los colores brand/semánticos (orange, green, red, cyan) NO están aquí
/// porque no cambian entre temas — viven en `AppColors.*` como constantes.
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  const AppColorScheme({
    required this.background,
    required this.surface,
    required this.surfaceLight,
    required this.surfaceLight2,
    required this.inputBackground,
    required this.border,
    required this.borderLight,
    required this.divider,
    required this.textMain,
    required this.textSecondary,
    required this.textMuted,
    required this.textDark,
    required this.textDim,
    required this.textGhost,
    required this.isDark,
  });

  final Color background;
  final Color surface;
  final Color surfaceLight;
  final Color surfaceLight2;
  final Color inputBackground;
  final Color border;
  final Color borderLight;
  final Color divider;
  final Color textMain;
  final Color textSecondary;
  final Color textMuted;

  /// Usado en chips y elementos sobre superficies oscuras/medias.
  final Color textDark;

  /// Texto muy tenue — separadores, hints secundarios.
  final Color textDim;

  /// Casi invisible — solo para bordes muy sutiles.
  final Color textGhost;

  /// True si el tema activo es oscuro.
  final bool isDark;

  // ─────────────────────────────────────────────────────────────
  // Instancias
  // ─────────────────────────────────────────────────────────────

  static const dark = AppColorScheme(
    background: Color(0xFF000000),
    surface: Color(0xFF1A1A1E),
    surfaceLight: Color(0xFF25252A),
    surfaceLight2: Color(0xFF323238),
    inputBackground: Color(0xFF1E1E24),
    border: Color(0xFF2C2C35),
    borderLight: Color(0xFF383844),
    divider: Color(0xFF202028),
    textMain: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFA0A0B0),
    textMuted: Color(0xFF6B6B7A),
    textDark: Color(0xFF5A5A6A),
    textDim: Color(0xFF4A4A5A),
    textGhost: Color(0xFF3A3A48),
    isDark: true,
  );

  static const light = AppColorScheme(
    background: Color(0xFFF2F2F7),
    surface: Color(0xFFFFFFFF),
    surfaceLight: Color(0xFFF5F5F7),
    surfaceLight2: Color(0xFFE5E5EA),
    inputBackground: Color(0xFFFFFFFF),
    border: Color(0xFFD1D1D6),
    borderLight: Color(0xFFE5E5EA),
    divider: Color(0xFFE0E0E5),
    // Textos — todos oscuros para garantizar contraste sobre fondos claros.
    // WCAG AA requiere ≥ 4.5:1 para texto normal, ≥ 3:1 para texto grande/bold.
    textMain: Color(0xFF1C1C1E),      // ~19:1 — texto principal
    textSecondary: Color(0xFF3C3C43), // ~9.5:1 — texto secundario legible
    textMuted: Color(0xFF52525A),     // ~7.1:1 — texto muted pero legible
    textDark: Color(0xFF636366),      // ~5.7:1 — etiquetas y chips OK
    textDim: Color(0xFF8E8E93),       // ~3.7:1 — solo para texto grande/bold
    textGhost: Color(0xFFAEAEB2),     // ~2.7:1 — solo decorativo, nunca texto legible
    isDark: false,
  );

  // ─────────────────────────────────────────────────────────────
  // ThemeExtension API
  // ─────────────────────────────────────────────────────────────

  @override
  AppColorScheme copyWith({
    Color? background,
    Color? surface,
    Color? surfaceLight,
    Color? surfaceLight2,
    Color? inputBackground,
    Color? border,
    Color? borderLight,
    Color? divider,
    Color? textMain,
    Color? textSecondary,
    Color? textMuted,
    Color? textDark,
    Color? textDim,
    Color? textGhost,
    bool? isDark,
  }) {
    return AppColorScheme(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceLight: surfaceLight ?? this.surfaceLight,
      surfaceLight2: surfaceLight2 ?? this.surfaceLight2,
      inputBackground: inputBackground ?? this.inputBackground,
      border: border ?? this.border,
      borderLight: borderLight ?? this.borderLight,
      divider: divider ?? this.divider,
      textMain: textMain ?? this.textMain,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textDark: textDark ?? this.textDark,
      textDim: textDim ?? this.textDim,
      textGhost: textGhost ?? this.textGhost,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  AppColorScheme lerp(AppColorScheme? other, double t) {
    if (other == null) return this;
    return AppColorScheme(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceLight: Color.lerp(surfaceLight, other.surfaceLight, t)!,
      surfaceLight2: Color.lerp(surfaceLight2, other.surfaceLight2, t)!,
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      textMain: Color.lerp(textMain, other.textMain, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textDark: Color.lerp(textDark, other.textDark, t)!,
      textDim: Color.lerp(textDim, other.textDim, t)!,
      textGhost: Color.lerp(textGhost, other.textGhost, t)!,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}

/// Acceso ergonómico: `context.colors.background`
extension AppColorSchemeContext on BuildContext {
  AppColorScheme get colors =>
      Theme.of(this).extension<AppColorScheme>() ?? AppColorScheme.dark;
}
