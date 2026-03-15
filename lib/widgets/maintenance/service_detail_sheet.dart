import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../ui/custom_button.dart';
import '../ui/summary_stats.dart';

class ServiceDetailSheet extends StatelessWidget {
  final Map<String, dynamic> service;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onClose;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;

  const ServiceDetailSheet({
    super.key,
    required this.service,
    required this.isExpanded,
    required this.onToggle,
    required this.onClose,
    this.onEdit,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final Color accentColor = service['accent'] ?? AppColors.orangePrimary;
    final String priceStr = '\$${(service['cost'] as double).toStringAsFixed(2)}';

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
          height: isExpanded ? MediaQuery.of(context).size.height * 0.85 : 450,
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
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  physics: isExpanded ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(accentColor),
                      const SizedBox(height: 24),
                      _buildCostSection(priceStr, accentColor),
                      const SizedBox(height: 32),
                      _buildStatsSection(accentColor),
                      const SizedBox(height: 32),
                      _buildNotesSection(),
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

  Widget _buildHeader(Color accent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service['service'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.directions_car, size: 14, color: accent),
                  const SizedBox(width: 6),
                  Text(
                    service['vehicle'],
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
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
                          Text('Edit Entry', style: TextStyle(color: Colors.white, fontSize: 14)),
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
                          Text('Delete Entry', style: TextStyle(color: AppColors.red, fontSize: 14)),
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
    );
  }

  Widget _buildCostSection(String cost, Color accent) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Total Investment',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5),
              ),
              SizedBox(height: 4),
              Text(
                'Professional Service',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            cost,
            style: TextStyle(
              color: AppColors.green,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(Color accent) {
    final stats = [
      StatItem(
        label: 'Mileage', 
        value: '${NumberFormat('#,###').format(service['mileage'])} mi', 
        accent: accent
      ),
      StatItem(
        label: 'Date', 
        value: DateFormat('MMM d, y').format(service['date']), 
        accent: AppColors.cyan
      ),
      StatItem(
        label: 'Category', 
        value: service['category'], 
        accent: AppColors.purple
      ),
    ];

    return SummaryStats(stats: stats);
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SERVICE NOTES',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            service['notes'] ?? 'No additional notes provided for this service entry.',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}
