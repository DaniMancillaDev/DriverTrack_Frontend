import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int count;
  final double size;
  final Color activeColor;
  final Color inactiveColor;

  const StarRating({
    super.key,
    required this.rating,
    this.count = 5,
    this.size = 12,
    this.activeColor = const Color(0xFFFF9C1A),
    this.inactiveColor = const Color(0xFF333340),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final starValue = index + 1;
        final bool isFilled = starValue <= rating.round();

        return Icon(
          isFilled ? Icons.star : Icons.star_border,
          size: size,
          color: isFilled ? activeColor : inactiveColor,
        );
      }),
    );
  }
}
