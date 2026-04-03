import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF1C1C1E);
  static const Color surfaceLight = Color(0xFF2C2C2E);
  
  static const Color surfaceLight2 = Color(0xFF3A3A3C);
  static const Color accent = Color(0xFFB8A0FF);
  static const Color border = Color(0xFF222228);
  static const Color borderLight = Color(0xFF2E2E38);
  static const Color divider = Color(0xFF252530);

  // Accents
  static const Color orangePrimary = Color(0xFFFF6B1A);
  static const Color orangeSecondary = Color(0xFFFF9C1A);
  static const Color cyan = Color(0xFF00D4E8);
  static const Color green = Color(0xFF4CAF82);
  static const Color red = Color(0xFFFF4D4D);
  static const Color purple = Color(0xFFB8A0FF);
  static const Color yellow = Color(0xFFFFBE3D);

  // Text
  static const Color textMain = Colors.white;
  static const Color textSecondary = Color(0xFF9E9EAE);
  static const Color textMuted = Color(0xFF6B6B7A);
  static const Color textDark = Color(0xFF5A5A6A);
  static const Color textDim = Color(0xFF4A4A5A);
  static const Color textGhost = Color(0xFF3A3A48);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [orangePrimary, orangeSecondary],
  );

  static LinearGradient surfaceGradient(Color accent) => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [accent.withValues(alpha: 0.1), Colors.transparent],
  );
}

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

class AppRadius {
  static const double xs = 8.0;
  static const double s = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double full = 999.0;
}

class AppTheme {
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
        bodyLarge: TextStyle(
          color: AppColors.textMain,
          fontSize: 15,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
        labelSmall: TextStyle(
          color: AppColors.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
