import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

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
    final List<Map<String, dynamic>> tabs = [
      {'label': 'Garage', 'icon': Icons.directions_car_outlined, 'activeIcon': Icons.directions_car},
      {'label': 'Maintenance', 'icon': Icons.build_outlined, 'activeIcon': Icons.build},
      {'label': 'Maps', 'icon': Icons.map_outlined, 'activeIcon': Icons.map},
      {'label': 'Profile', 'icon': Icons.person_outline, 'activeIcon': Icons.person},
    ];

    return Container(
      padding: const EdgeInsets.only(bottom: 10, top: 6, left: 8, right: 8),
      decoration: const BoxDecoration(
        color: AppColors.background,
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
                height: 52,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (isSelected)
                      Positioned(
                        top: 4,
                        child: Container(
                          width: 48,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.orangePrimary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.orangePrimary.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isSelected ? (tab['activeIcon'] as IconData) : (tab['icon'] as IconData),
                          size: 22,
                          color: isSelected ? AppColors.orangePrimary : AppColors.textDim,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tab['label'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                            color: isSelected ? AppColors.orangePrimary : AppColors.textDim,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                    if (isSelected)
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.orangePrimary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.orangePrimary.withOpacity(0.6),
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
