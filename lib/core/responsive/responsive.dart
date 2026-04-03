import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
// Breakpoints
// ─────────────────────────────────────────────────────────────

class AppBreakpoints {
  AppBreakpoints._();

  static const double mobileSmall = 360;
  static const double mobile = 400;
  static const double tablet = 600;
  static const double desktop = 900;
}

// ─────────────────────────────────────────────────────────────
// Device classification
// ─────────────────────────────────────────────────────────────

enum DeviceType { mobileSmall, mobile, tablet, desktop }

// ─────────────────────────────────────────────────────────────
// Core responsive utility
// ─────────────────────────────────────────────────────────────

class AppResponsive {
  final double screenWidth;
  final double screenHeight;
  final DeviceType deviceType;
  final double scaleFactor;
  final Orientation orientation;

  AppResponsive._({
    required this.screenWidth,
    required this.screenHeight,
    required this.deviceType,
    required this.scaleFactor,
    required this.orientation,
  });

  /// Create from BuildContext — uses MediaQuery for accurate sizing.
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

  // ─── Convenience getters ──────────────────────────────────

  bool get isMobileSmall => deviceType == DeviceType.mobileSmall;
  bool get isMobile => deviceType == DeviceType.mobile || isMobileSmall;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;
  bool get isLandscape => orientation == Orientation.landscape;

  // ─── Scaling methods ──────────────────────────────────────

  /// Scale-aware font size. Replaces hardcoded `fontSize:` values.
  double sp(double size) => size * scaleFactor;

  /// Scale-aware radius.
  double r(double radius) => radius * scaleFactor;

  /// Scale-aware icon size.
  double iconSize(double size) => size * scaleFactor;

  /// Scale-aware dimension (for containers, images, etc.).
  double dim(double size) => size * scaleFactor;

  /// Scale-aware spacing.
  double space(double size) => size * scaleFactor;

  // ─── Responsive value selection ───────────────────────────

  /// Pick a value based on current device type.
  /// Falls back to the smallest provided value.
  T value<T>({
    required T mobile,
    T? mobileSmall,
    T? tablet,
    T? desktop,
  }) {
    return switch (deviceType) {
      DeviceType.mobileSmall => mobileSmall ?? mobile,
      DeviceType.mobile => mobile,
      DeviceType.tablet => tablet ?? mobile,
      DeviceType.desktop => desktop ?? tablet ?? mobile,
    };
  }

  /// Returns a proportional width (percentage of screen width).
  double wp(double percent) => screenWidth * percent / 100;

  /// Returns a proportional height (percentage of screen height).
  double hp(double percent) => screenHeight * percent / 100;
}

// ─────────────────────────────────────────────────────────────
// Extension on BuildContext for easy access
// ─────────────────────────────────────────────────────────────

extension ResponsiveExtension on BuildContext {
  AppResponsive get responsive => AppResponsive.of(this);
}

// ─────────────────────────────────────────────────────────────
// ResponsiveBuilder widget
// ─────────────────────────────────────────────────────────────

class ResponsiveBuilder extends StatelessWidget {
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
// Responsive Icon Sizes
// ─────────────────────────────────────────────────────────────

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

  static double xxs(BuildContext context) => context.responsive.iconSize(_xxs);
  static double xs(BuildContext context) => context.responsive.iconSize(_xs);
  static double sm(BuildContext context) => context.responsive.iconSize(_sm);
  static double md(BuildContext context) => context.responsive.iconSize(_md);
  static double lg(BuildContext context) => context.responsive.iconSize(_lg);
  static double xl(BuildContext context) => context.responsive.iconSize(_xl);
  static double xxl(BuildContext context) => context.responsive.iconSize(_xxl);
  static double huge(BuildContext context) => context.responsive.iconSize(_huge);
  static double massive(BuildContext context) => context.responsive.iconSize(_massive);
}

// ─────────────────────────────────────────────────────────────
// Responsive Text Styles
// ─────────────────────────────────────────────────────────────

class AppTextStyles {
  AppTextStyles._();

  /// 24sp — Main headings
  static TextStyle headline(BuildContext context) {
    final r = context.responsive;
    return TextStyle(
      fontSize: r.sp(24),
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
    );
  }

  /// 20sp — Section headings
  static TextStyle headlineMedium(BuildContext context) {
    final r = context.responsive;
    return TextStyle(
      fontSize: r.sp(20),
      fontWeight: FontWeight.w700,
    );
  }

  /// 22sp — Large display numbers / titles in sheets
  static TextStyle display(BuildContext context) {
    final r = context.responsive;
    return TextStyle(
      fontSize: r.sp(22),
      fontWeight: FontWeight.w800,
      letterSpacing: -0.4,
    );
  }

  /// 17sp — Titles (cards, sections)
  static TextStyle title(BuildContext context) {
    final r = context.responsive;
    return TextStyle(
      fontSize: r.sp(17),
      fontWeight: FontWeight.w700,
    );
  }

  /// 15sp — Primary body text
  static TextStyle body(BuildContext context) {
    final r = context.responsive;
    return TextStyle(
      fontSize: r.sp(15),
    );
  }

  /// 14sp — Secondary body text
  static TextStyle bodyMedium(BuildContext context) {
    final r = context.responsive;
    return TextStyle(
      fontSize: r.sp(14),
    );
  }

  /// 13sp — Small body / subtitles
  static TextStyle bodySmall(BuildContext context) {
    final r = context.responsive;
    return TextStyle(
      fontSize: r.sp(13),
    );
  }

  /// 12sp — Captions / supplementary text
  static TextStyle caption(BuildContext context) {
    final r = context.responsive;
    return TextStyle(
      fontSize: r.sp(12),
    );
  }

  /// 11sp — Labels / tags
  static TextStyle label(BuildContext context) {
    final r = context.responsive;
    return TextStyle(
      fontSize: r.sp(11),
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    );
  }

  /// 10sp — Micro labels / badges
  static TextStyle micro(BuildContext context) {
    final r = context.responsive;
    return TextStyle(
      fontSize: r.sp(10),
    );
  }

  /// 9sp — Tiny text (minimal UI labels)
  static TextStyle tiny(BuildContext context) {
    final r = context.responsive;
    return TextStyle(
      fontSize: r.sp(9),
    );
  }

  /// 16sp — Button text
  static TextStyle button(BuildContext context) {
    final r = context.responsive;
    return TextStyle(
      fontSize: r.sp(16),
      fontWeight: FontWeight.w700,
    );
  }

  /// 18sp — Sheet / dialog titles
  static TextStyle sheetTitle(BuildContext context) {
    final r = context.responsive;
    return TextStyle(
      fontSize: r.sp(18),
      fontWeight: FontWeight.w800,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Responsive Spacing (extends existing AppSpacing with scaling)
// ─────────────────────────────────────────────────────────────

class AppResponsiveSpacing {
  final AppResponsive _responsive;

  AppResponsiveSpacing._(this._responsive);

  factory AppResponsiveSpacing.of(BuildContext context) {
    return AppResponsiveSpacing._(AppResponsive.of(context));
  }

  double get xxs => _responsive.space(4);
  double get xs => _responsive.space(8);
  double get s => _responsive.space(12);
  double get md => _responsive.space(16);
  double get lg => _responsive.space(24);
  double get xl => _responsive.space(32);
  double get xxl => _responsive.space(40);
  double get xxxl => _responsive.space(48);
  double get massive => _responsive.space(64);
}
