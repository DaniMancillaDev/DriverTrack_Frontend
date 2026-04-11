import 'package:flutter/material.dart';
import 'app_color_scheme.dart';

/// Definición central de la paleta de colores y recursos visuales.
/// 
/// Centraliza todos los tokens de color del sistema de diseño, organizados por:
/// * **Backgrounds**: Superficies oscuras y capas de elevación.
/// * **Brand**: Colores de marca (Naranja primario) y acentos.
/// * **Semantic**: Colores de estado (Éxito, Error, Advertencia).
/// * **Text**: Jerarquía tipográfica desde Main hasta Ghost.
class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF1A1A1E);
  static const Color surfaceLight = Color(0xFF25252A);
  static const Color surfaceLight2 = Color(0xFF323238);
  static const Color inputBackground = Color(0xFF1E1E24);
  
  // Accents & Brand
  static const Color orangePrimary = Color(0xFFFF6B1A);
  static const Color orangeSecondary = Color(0xFFFF9C1A);
  static const Color accent = Color(0xFFFF6B1A); // Anteriormente Morado, ahora alineado a la marca.
  
  static const Color border = Color(0xFF2C2C35);
  static const Color borderLight = Color(0xFF383844);
  static const Color divider = Color(0xFF202028);

  // Status Colors
  static const Color info = Color(0xFF00D4E8); // Cyan
  static const Color success = Color(0xFF4CAF82); // Green
  static const Color error = Color(0xFFFF4D4D); // Red
  static const Color warning = Color(0xFFFFBE3D); // Yellow

  // Legacy variables (retained for fallback)
  static const Color cyan = Color(0xFF00D4E8);
  static const Color green = Color(0xFF4CAF82);
  static const Color red = Color(0xFFFF4D4D);
  static const Color purple = Color(0xFFFF6B1A); // Deprecated purple logic -> orange
  static const Color yellow = Color(0xFFFFBE3D);

  // Text
  static const Color textMain = Colors.white;
  static const Color textSecondary = Color(0xFFA0A0B0);
  static const Color textMuted = Color(0xFF6B6B7A);
  static const Color textDark = Color(0xFF5A5A6A); // Used typically inside dark chips
  static const Color textDim = Color(0xFF4A4A5A);
  static const Color textGhost = Color(0xFF3A3A48);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [orangePrimary, orangeSecondary],
  );

  /// Genera un gradiente suave para superficies basadas en un color de acento.
  static LinearGradient surfaceGradient(Color baseAccent) => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [baseAccent.withValues(alpha: 0.08), Colors.transparent],
  );
}

/// Escala de espaciado estandarizada para márgenes y paddings.
class AppSpacing {
  static const double zero = 0;
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double s = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;
  static const double xxxl = 48.0;
  static const double massive = 64.0;
}

/// Definición de radios de borde para consistencia visual.
class AppRadius {
  static const double xs = 8.0;
  static const double s = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double full = 999.0;
}

/// Punto de configuración central para los temas de la aplicación.
/// 
/// Provee definiciones de [ThemeData] para modos Claro y Oscuro, 
/// configurando:
/// * **Material 3**: Activado por defecto con esquemas de color adaptativos.
/// * **Tipografía**: Integración de la fuente 'Inter'.
/// * **Extensions**: Uso de [AppColorScheme] para tokens personalizados que 
///   no existen en el SDK estándar de Flutter.
class AppTheme {
  /// Devuelve la configuración del tema oscuro basado en AppColors.
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.orangePrimary,
        secondary: AppColors.orangeSecondary,
        surface: AppColors.surface,
        surfaceContainer: AppColors.surface,
        error: AppColors.red,
      ),
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.textMain,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textMain,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: AppColors.textMain,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(color: AppColors.textMain, fontSize: 16),
        bodyMedium: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        labelLarge: TextStyle(
          color: AppColors.textMain,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          color: AppColors.textMain,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          color: AppColors.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      extensions: const [AppColorScheme.dark],
    );
  }

  /// Tema claro — usa AppColorScheme.light para los tokens adaptativos.
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColorScheme.light.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.orangePrimary,
        secondary: AppColors.orangeSecondary,
        surface: Color(0xFFFFFFFF),
        surfaceContainer: Color(0xFFF5F5F7),
        error: AppColors.red,
        onPrimary: Colors.white,
        onSurface: Color(0xFF1C1C1E),
      ),
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Color(0xFF1C1C1E),
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          color: Color(0xFF1C1C1E),
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: Color(0xFF1C1C1E),
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(color: Color(0xFF1C1C1E), fontSize: 16),
        bodyMedium: TextStyle(color: Color(0xFF6C6C70), fontSize: 14),
        labelLarge: TextStyle(
          color: Color(0xFF1C1C1E),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          color: Color(0xFF1C1C1E),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          color: Color(0xFF6C6C70),
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      extensions: const [AppColorScheme.light],
    );
  }
}
