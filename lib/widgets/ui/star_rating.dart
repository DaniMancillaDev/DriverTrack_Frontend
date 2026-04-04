import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_color_scheme.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int count;
  final double size;
  final Color? activeColor;
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
