import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/responsive/responsive.dart';

class FilterPills extends StatelessWidget {
  final List<String> filters;
  final String activeFilter;
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
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
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
                  border: Border.all(
                    color: isSelected 
                        ? AppColors.orangePrimary.withValues(alpha: 0.4) 
                        : AppColors.border,
                  ),
                ),
                child: Text(
                  f,
                  style: AppTextStyles.bodySmall(context).copyWith(
                    color: isSelected ? AppColors.orangePrimary : AppColors.textMuted,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
