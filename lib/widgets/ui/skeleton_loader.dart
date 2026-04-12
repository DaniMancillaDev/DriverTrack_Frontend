import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_color_scheme.dart';

/// Un marcador de posición animado (Shimmer) para estados de carga.
/// 
/// Utiliza un degradado lineal que se desplaza horizontalmente para simular 
/// actividad mientras se cargan datos asíncronos. Es altamente personalizable 
/// en dimensiones y redondeo.
class SkeletonLoader extends StatefulWidget {
  /// Ancho del bloque de carga.
  final double width;
  /// Altura del bloque de carga.
  final double height;
  /// Radio de los bordes (por defecto [AppRadius.s]).
  final double borderRadius;
  /// Espaciado externo opcional.
  final EdgeInsetsGeometry? margin;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppRadius.s,
    this.margin,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: widget.width,
            height: widget.height,
            margin: widget.margin,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.colors.surfaceLight,
                  context.colors.surfaceLight2,
                  context.colors.surfaceLight,
                ],
                stops: [
                  0.0,
                  (_animation.value + 1) /
                      2, // Map -2..2 to roughly 0..1 range for movement
                  1.0,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
