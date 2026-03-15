import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../ui/custom_button.dart';
import '../ui/summary_stats.dart';

class VehicleDetailSheet extends StatelessWidget {
  final Map<String, dynamic> vehicle;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onClose;
  final VoidCallback? onLogService;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;

  const VehicleDetailSheet({
    super.key,
    required this.vehicle,
    required this.isExpanded,
    required this.onToggle,
    required this.onClose,
    this.onLogService,
    this.onEdit,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final Color accentColor = vehicle['color'] ?? AppColors.orangePrimary;
    final double healthPct = (100 - ((vehicle['mileage'] as int) / (vehicle['maxMileage'] as int) * 100)).toDouble();

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
          height: isExpanded ? MediaQuery.of(context).size.height * 0.85 : 420,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 40,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag Handle & Header Area
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy < -10 && !isExpanded) onToggle();
                  if (details.delta.dy > 10 && isExpanded) onToggle();
                },
                onTap: onToggle,
                child: _buildHandle(context),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  physics: isExpanded ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroSection(healthPct, accentColor),
                      const SizedBox(height: 24),
                      _buildStatsSection(accentColor),
                      const SizedBox(height: 32),
                      _buildMaintenanceSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.borderLight,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(double healthPct, Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${vehicle['type']} • ${vehicle['plate']}',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                ),
              ],
            ),
            Row(
              children: [
                if (onEdit != null || onRemove != null)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit?.call();
                      } else if (value == 'remove') {
                        onRemove?.call();
                      }
                    },
                    color: AppColors.surface,
                    surfaceTintColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    icon: const Icon(Icons.more_vert_rounded, color: AppColors.textMuted),
                    itemBuilder: (context) => [
                      if (onEdit != null)
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: const [
                              Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondary),
                              SizedBox(width: 12),
                              Text('Edit Vehicle', style: TextStyle(color: Colors.white, fontSize: 14)),
                            ],
                          ),
                        ),
                      if (onRemove != null)
                        PopupMenuItem(
                          value: 'remove',
                          child: Row(
                            children: const [
                              Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.red),
                              SizedBox(width: 12),
                              Text('Remove Vehicle', style: TextStyle(color: AppColors.red, fontSize: 14)),
                            ],
                          ),
                        ),
                    ],
                  ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close, color: AppColors.textMuted),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.background,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Image.network(
                vehicle['image'],
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Container(
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Overall Health',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${healthPct.round()}%',
                          style: TextStyle(color: accent, fontSize: 14, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: healthPct / 100,
                        minHeight: 8,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(accent),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(Color accent) {
    final stats = [
      StatItem(label: 'Mileage', value: '${(vehicle['mileage'] / 1000).toStringAsFixed(1)}K', accent: accent),
      StatItem(label: 'Last Service', value: '12d ago', accent: AppColors.cyan),
      StatItem(label: 'Next Goal', value: '50K', accent: AppColors.purple),
    ];

    return SummaryStats(stats: stats);
  }

  Widget _buildMaintenanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RECENT MAINTENANCE',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        _buildHistoryItem('Oil & Filter Change', '15 Feb 2026', '\$89.99', Icons.opacity, AppColors.orangePrimary),
        _buildHistoryItem('Tire Rotation', '28 Jan 2026', '\$45.00', Icons.adjust, AppColors.cyan),
        _buildHistoryItem('Brake Inspection', '10 Jan 2026', 'Free', Icons.gavel_rounded, AppColors.green),
      ],
    );
  }

  Widget _buildHistoryItem(String title, String date, String cost, IconData icon, Color accent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accent, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  Text(date, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
            ),
            Text(cost, style: TextStyle(color: accent, fontSize: 13, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
