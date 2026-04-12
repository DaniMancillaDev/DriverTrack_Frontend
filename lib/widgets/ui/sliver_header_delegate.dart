import 'package:flutter/material.dart';

/// Un delegado para [SliverPersistentHeader] que mantiene un widget fijo (pinned)
/// con una altura calculada dinámicamente o fija.
/// 
/// Se utiliza para unificar el comportamiento de los encabezados de la aplicación
/// asegurando que el contenido se desplace correctamente debajo de ellos sin 
/// necesidad de paddings manuales.
class SliverPinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  SliverPinnedHeaderDelegate({
    required this.child,
    required this.height,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant SliverPinnedHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
