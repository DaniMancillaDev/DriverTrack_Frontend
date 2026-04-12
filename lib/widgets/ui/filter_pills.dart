import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/responsive/responsive.dart';
import '../../theme/app_color_scheme.dart';

/// Una lista de píldoras de filtro con scroll horizontal y efecto de desvanecimiento.
/// 
/// Permite al usuario seleccionar una opción entre múltiples categorías. 
/// Utiliza un [ShaderMask] para crear un gradiente de transparencia en los 
/// bordes, indicando visualmente que hay más elementos para desplazar.
class FilterPills extends StatelessWidget {
  /// Lista de etiquetas de texto para los filtros.
  final List<String> filters;
  /// Filtro seleccionado actualmente (activado visualmente).
  final String activeFilter;
  /// Callback disparado al seleccionar una nueva píldora.
  final Function(String) onFilterChanged;

  const FilterPills({
    super.key,
    required this.filters,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    return ShaderMask(
      // Fading edge derecho: indica visualmente que hay más pills para scrollear
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            context.colors.textMain,
            context.colors.textMain,
            Colors.transparent,
          ],
          stops: const [0.0, 0.75, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        // Padding derecho extra para que la última pill no quede tapada por el fade
        child: Padding(
          padding: EdgeInsets.only(right: r.space(AppSpacing.xl)),
          child: Row(
            children: filters.map((f) {
              final isSelected = activeFilter == f;
              return Padding(
                padding: EdgeInsets.only(right: r.space(AppSpacing.s)),
                child: GestureDetector(
                  onTap: () => onFilterChanged(f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: r.space(AppSpacing.md),
                      vertical: r.space(AppSpacing.s),
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.orangePrimary.withValues(alpha: 0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.orangePrimary.withValues(alpha: 0.4)
                            : context.colors.borderLight,
                      ),
                    ),
                    child: Text(
                      f,
                      style: AppTextStyles.bodySmall(context).copyWith(
                        color: isSelected
                            ? AppColors.orangePrimary
                            : context.colors.textMain,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
