import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_color_scheme.dart';

/// Un indicador visual de calificación mediante estrellas.
/// 
/// Permite representar puntuaciones numéricas (ej. 4.5) transformándolas 
/// en una fila de iconos de estrellas llenas o contorneadas.
class StarRating extends StatelessWidget {
  /// Valor de la calificación (ej. 4.2).
  final double rating;
  /// Cantidad total de estrellas a mostrar (por defecto 5).
  final int count;
  /// Tamaño de cada icono de estrella.
  final double size;
  /// Color para las estrellas calificadas.
  final Color? activeColor;
  /// Color para las estrellas restantes.
  final Color? inactiveColor;

  const StarRating({
    super.key,
    required this.rating,
    this.count = 5,
    this.size = 12,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? AppColors.orangeSecondary;
    final effectiveInactiveColor = inactiveColor ?? context.colors.textGhost;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final starValue = index + 1;
        final bool isFilled = starValue <= rating.round();

        return Icon(
          isFilled ? Icons.star : Icons.star_border,
          size: size,
          color: isFilled ? effectiveActiveColor : effectiveInactiveColor,
        );
      }),
    );
  }
}
