import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class StatItem {
  final String label;
  final String value;
  final Color accent;

  StatItem({
    required this.label,
    required this.value,
    required this.accent,
  });
}

class SummaryStats extends StatelessWidget {
  final List<StatItem> stats;

  const SummaryStats({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 400;
          return Wrap(
            alignment: WrapAlignment.spaceAround,
            runAlignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 20,
            children: stats.map((stat) {
              return SizedBox(
                width: isWide ? (constraints.maxWidth - 80) / stats.length : (constraints.maxWidth - 60) / 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      stat.value,
                      style: TextStyle(
                        color: stat.accent,
                        fontSize: isWide ? 22 : 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stat.label.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
