import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
// Puntos de quiebre (Breakpoints)
// ─────────────────────────────────────────────────────────────

/// Orquestador de los umbrales de visualización (Breakpoints).
/// 
/// Define los límites físicos en píxeles lógicos que determinan cuándo 
/// la interfaz debe reorganizarse para optimizar la experiencia de usuario.
class AppBreakpoints {
  AppBreakpoints._();

  /// Umbral para teléfonos compactos (< 360px).
  static const double mobileSmall = 360;

  /// Umbral para teléfonos estándar (~ 400px).
  static const double mobile = 400;

  /// Umbral para tabletas y dispositivos de formato medio (~ 600px).
  static const double tablet = 600;

  /// Umbral para monitores y estaciones de trabajo (> 900px).
  static const double desktop = 900;
}

// ─────────────────────────────────────────────────────────────
// Clasificación de dispositivos
// ─────────────────────────────────────────────────────────────

/// Categorías de dispositivos soportadas por el sistema de diseño.
enum DeviceType {
  /// Teléfonos con ancho < 360px.
  mobileSmall,

  /// Teléfonos estándar (ej. iPhone Pro, Pixel).
  mobile,

  /// Tablets (ej. iPad Pro, Samsung Tab).
  tablet,

  /// Pantallas de escritorio o portátiles.
  desktop
}

// ─────────────────────────────────────────────────────────────
// Utilidad principal de adaptabilidad
// ─────────────────────────────────────────────────────────────

/// Clase principal para la gestión de la adaptabilidad en la aplicación.
///
/// Proporciona valores de escalado, dimensiones porcentuales y selección
/// automática de valores basados en el tipo de dispositivo detectado.
class AppResponsive {
  /// Ancho actual de la pantalla en píxeles lógicos.
  final double screenWidth;

  /// Alto actual de la pantalla en píxeles lógicos.
  final double screenHeight;

  /// Categoría del dispositivo actual basado en [AppBreakpoints].
  final DeviceType deviceType;

  /// Factor multiplicador para el escalado de fuentes y dimensiones.
  /// Permite que la UI se "agigante" o "encoja" proporcionalmente.
  final double scaleFactor;

  /// Orientación actual (vertical/horizontal).
  final Orientation orientation;

  AppResponsive._({
    required this.screenWidth,
    required this.screenHeight,
    required this.deviceType,
    required this.scaleFactor,
    required this.orientation,
  });

  /// Obtiene una instancia de [AppResponsive] a partir del [BuildContext].
  ///
  /// Utiliza [MediaQuery] internamente para asegurar que los valores sean exactos
  /// y reaccionen a cambios de tamaño o rotación.
  factory AppResponsive.of(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final height = mq.size.height;
    final orientation = mq.orientation;

    final DeviceType type;
    final double scale;

    if (width < AppBreakpoints.mobileSmall) {
      type = DeviceType.mobileSmall;
      scale = 0.85;
    } else if (width < AppBreakpoints.tablet) {
      type = DeviceType.mobile;
      scale = 1.0;
    } else if (width < AppBreakpoints.desktop) {
      type = DeviceType.tablet;
      scale = 1.15;
    } else {
      type = DeviceType.desktop;
      scale = 1.25;
    }

    return AppResponsive._(
      screenWidth: width,
      screenHeight: height,
      deviceType: type,
      scaleFactor: scale,
      orientation: orientation,
    );
  }

  // ─── Getters de conveniencia ──────────────────────────────────

  /// Indica si el dispositivo es un móvil pequeño.
  bool get isMobileSmall => deviceType == DeviceType.mobileSmall;

  /// Indica si el dispositivo es cualquier tipo de móvil (incluyendo small).
  bool get isMobile => deviceType == DeviceType.mobile || isMobileSmall;

  /// Indica si el dispositivo es una tablet.
  bool get isVolunteer => deviceType == DeviceType.tablet;

  /// Indica si el dispositivo es un escritorio.
  bool get isDesktop => deviceType == DeviceType.desktop;

  /// Indica si la orientación actual es horizontal.
  bool get isLandscape => orientation == Orientation.landscape;

  // ─── Métodos de escalado ──────────────────────────────────────

  /// Tamaño de fuente adaptativo.
  /// Reemplaza valores `fontSize` fijos por valores escalados según el dispositivo.
  double sp(double size) => size * scaleFactor;

  /// Radio adaptativo para bordes y esquinas.
  double r(double radius) => radius * scaleFactor;

  /// Tamaño de icono adaptativo.
  double iconSize(double size) => size * scaleFactor;

  /// Dimensión genérica adaptativa (usar para anchos y altos de contenedores).
  double dim(double size) => size * scaleFactor;

  /// Espaciado adaptativo (usar para márgenes y paddings).
  double space(double size) => size * scaleFactor;

  // ─── Selección de valores adaptativos ───────────────────────────

  /// Selecciona un valor específico basado en el tipo de dispositivo actual.
  ///
  /// Si no se proporciona un valor para una categoría específica,
  /// retrocede (fallback) al valor de la categoría inferior disponible.
  T value<T>({required T mobile, T? mobileSmall, T? tablet, T? desktop}) {
    return switch (deviceType) {
      DeviceType.mobileSmall => mobileSmall ?? mobile,
      DeviceType.mobile => mobile,
      DeviceType.tablet => tablet ?? mobile,
      DeviceType.desktop => desktop ?? tablet ?? mobile,
    };
  }

  /// Retorna un ancho proporcional (porcentaje del ancho total de pantalla).
  double wp(double percent) => screenWidth * percent / 100;

  /// Retorna un alto proporcional (porcentaje del alto total de pantalla).
  double hp(double percent) => screenHeight * percent / 100;
}

// ─────────────────────────────────────────────────────────────
// Extensión sobre BuildContext para acceso rápido
// ─────────────────────────────────────────────────────────────

/// Extensión para facilitar el acceso a la lógica de responsividad.
/// Permite usar `context.responsive` en cualquier parte de la jerarquía de widgets.
extension ResponsiveExtension on BuildContext {
  /// Proporciona acceso a las utilidades de [AppResponsive].
  AppResponsive get responsive => AppResponsive.of(this);
}

// ─────────────────────────────────────────────────────────────
// Widget ResponsiveBuilder
// ─────────────────────────────────────────────────────────────

/// Widget que expone la lógica de responsividad a través de un constructor (builder).
/// Útil cuando se necesita reconstruir partes complejas basadas en el tamaño detectado.
class ResponsiveBuilder extends StatelessWidget {
  /// Función constructora que recibe el contexto y la utilidad de responsividad.
  final Widget Function(BuildContext context, AppResponsive responsive) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return builder(context, AppResponsive.of(context));
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Tamaños de iconos adaptativos
// ─────────────────────────────────────────────────────────────

/// Centraliza los tamaños de iconos adaptativos del sistema.
class AppIconSizes {
  AppIconSizes._();

  static const double _xxs = 10;
  static const double _xs = 12;
  static const double _sm = 16;
  static const double _md = 18;
  static const double _lg = 20;
  static const double _xl = 24;
  static const double _xxl = 32;
  static const double _huge = 40;
  static const double _massive = 48;

  /// Tamaño extra pequeño (10sp).
  static double xxs(BuildContext context) => context.responsive.iconSize(_xxs);
  /// Tamaño muy pequeño (12sp).
  static double xs(BuildContext context) => context.responsive.iconSize(_xs);
  /// Tamaño pequeño estándar (16sp).
  static double sm(BuildContext context) => context.responsive.iconSize(_sm);
  /// Tamaño medio (18sp).
  static double md(BuildContext context) => context.responsive.iconSize(_md);
  /// Tamaño grande (20sp).
  static double lg(BuildContext context) => context.responsive.iconSize(_lg);
  /// Tamaño muy grande (24sp).
  static double xl(BuildContext context) => context.responsive.iconSize(_xl);
  /// Tamaño doble XL (32sp).
  static double xxl(BuildContext context) => context.responsive.iconSize(_xxl);
  /// Tamaño gigante (40sp).
  static double huge(BuildContext context) =>
      context.responsive.iconSize(_huge);
  /// Tamaño masivo (48sp).
  static double massive(BuildContext context) =>
      context.responsive.iconSize(_massive);
}

// ─────────────────────────────────────────────────────────────
// Estilos de texto adaptativos
// ─────────────────────────────────────────────────────────────

/// Centraliza los estilos de texto adaptativos del sistema.
class AppTextStyles {
  AppTextStyles._();

  /// Títulos principales de páginas (24sp, Bold).
  static TextStyle headline(BuildContext context) {
    final r = context.responsive;
    return TextStyle(
      fontSize: r.sp(24),
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
    );
  }

  /// Títulos de secciones intermedias (20sp, Bold).
  static TextStyle headlineMedium(BuildContext context) {
    final r = context.responsive;
    return TextStyle(fontSize: r.sp(20), fontWeight: FontWeight.w700);
  }

  /// Texto destacado o números grandes en hojas modales (22sp, Heavy).
  static TextStyle display(BuildContext context) {
    final r = context.responsive;
    return TextStyle(
      fontSize: r.sp(22),
      fontWeight: FontWeight.w800,
      letterSpacing: -0.4,
    );
  }

  /// Títulos de tarjetas o secciones (17sp, Bold).
  static TextStyle title(BuildContext context) {
    final r = context.responsive;
    return TextStyle(fontSize: r.sp(17), fontWeight: FontWeight.w700);
  }

  /// Texto de cuerpo principal (15sp).
  static TextStyle body(BuildContext context) {
    final r = context.responsive;
    return TextStyle(fontSize: r.sp(15));
  }

  /// Texto de cuerpo secundario o párrafos largos (14sp).
  static TextStyle bodyMedium(BuildContext context) {
    final r = context.responsive;
    return TextStyle(fontSize: r.sp(14));
  }

  /// Texto de cuerpo pequeño o subtítulos (13sp).
  static TextStyle bodySmall(BuildContext context) {
    final r = context.responsive;
    return TextStyle(fontSize: r.sp(13));
  }

  /// Pies de foto o texto suplementario (12sp).
  static TextStyle caption(BuildContext context) {
    final r = context.responsive;
    return TextStyle(fontSize: r.sp(12));
  }

  /// Etiquetas, tags o badges pequeños (11sp, Semibold).
  static TextStyle label(BuildContext context) {
    final r = context.responsive;
    return TextStyle(
      fontSize: r.sp(11),
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    );
  }

  /// Texto microscópico para UI auxiliar (10sp).
  static TextStyle micro(BuildContext context) {
    final r = context.responsive;
    return TextStyle(fontSize: r.sp(10));
  }

  /// El tamaño de texto más pequeño permitido (9sp).
  static TextStyle tiny(BuildContext context) {
    final r = context.responsive;
    return TextStyle(fontSize: r.sp(9));
  }

  /// Estilo para el contenido de los botones (16sp, Bold).
  static TextStyle button(BuildContext context) {
    final r = context.responsive;
    return TextStyle(fontSize: r.sp(16), fontWeight: FontWeight.w700);
  }

  /// Títulos dentro de BottomSheets o Diálogos (18sp, Heavy).
  static TextStyle sheetTitle(BuildContext context) {
    final r = context.responsive;
    return TextStyle(fontSize: r.sp(18), fontWeight: FontWeight.w800);
  }
}

// ─────────────────────────────────────────────────────────────
// Espaciado adaptativo
// ─────────────────────────────────────────────────────────────

/// Centraliza los márgenes y paddings dinámicos.
/// Se basa en la utilidad [AppResponsive] para escalar espacios según la pantalla.
class AppResponsiveSpacing {
  final AppResponsive _responsive;

  AppResponsiveSpacing._(this._responsive);

  /// Crea una instancia de espaciado adaptativo a partir del contexto.
  factory AppResponsiveSpacing.of(BuildContext context) {
    return AppResponsiveSpacing._(AppResponsive.of(context));
  }

  /// Espacio extra extra pequeño (4px escalado).
  double get xxs => _responsive.space(4);
  /// Espacio extra pequeño (8px escalado).
  double get xs => _responsive.space(8);
  /// Espacio pequeño (12px escalado).
  double get s => _responsive.space(12);
  /// Espacio medio (16px escalado).
  double get md => _responsive.space(16);
  /// Espacio grande (24px escalado).
  double get lg => _responsive.space(24);
  /// Espacio XL (32px escalado).
  double get xl => _responsive.space(32);
  /// Espacio XXL (40px escalado).
  double get xxl => _responsive.space(40);
  /// Espacio XXXL (48px escalado).
  double get xxxl => _responsive.space(48);
  /// Espacio masivo (64px escalado).
  double get massive => _responsive.space(64);
}
