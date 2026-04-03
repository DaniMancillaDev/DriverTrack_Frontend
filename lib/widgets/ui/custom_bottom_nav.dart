import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/i18n/translations.g.dart';
import '../../core/responsive/responsive.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = Translations.of(context);
    final r = context.responsive;

    final List<Map<String, dynamic>> tabs = [
      {'icon': Icons.directions_car_outlined, 'activeIcon': Icons.directions_car, 'label': t.nav.garage},
      {'icon': Icons.history_rounded, 'activeIcon': Icons.history_rounded, 'label': t.nav.history},
      {'icon': Icons.map_outlined, 'activeIcon': Icons.map, 'label': t.nav.map},
      {'icon': Icons.person_outline_rounded, 'activeIcon': Icons.person_rounded, 'label': t.nav.profile},
    ];

    return Container(
      padding: EdgeInsets.only(
        bottom: r.space(AppSpacing.s),
        top: r.space(AppSpacing.xxs),
        left: r.space(AppSpacing.xs),
        right: r.space(AppSpacing.xs),
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(tabs.length, (index) {
          final isSelected = currentIndex == index;
          final tab = tabs[index];

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                height: r.dim(56),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (isSelected)
                      Positioned(
                        top: r.space(4),
                        child: Container(
                          width: r.dim(48),
                          height: r.dim(32),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
                            border: Border.all(
                              color: colorScheme.primary.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                      ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isSelected ? (tab['activeIcon'] as IconData) : (tab['icon'] as IconData),
                          size: AppIconSizes.lg(context),
                          color: isSelected ? colorScheme.primary : AppColors.textDim,
                        ),
                        SizedBox(height: r.space(2)),
                        Text(
                          tab['label'] as String,
                          style: AppTextStyles.micro(context).copyWith(
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                            color: isSelected ? colorScheme.primary : AppColors.textDim,
                          ),
                        ),
                      ],
                    ),
                    if (isSelected)
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: r.dim(4),
                          height: r.dim(4),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withValues(alpha: 0.6),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
