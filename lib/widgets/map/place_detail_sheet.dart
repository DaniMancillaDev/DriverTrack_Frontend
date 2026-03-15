import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../pages/service_map_page.dart';
import '../ui/star_rating.dart';
import '../ui/custom_button.dart';

class PlaceDetailSheet extends StatelessWidget {
  final Location location;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onClose;

  const PlaceDetailSheet({
    super.key,
    required this.location,
    required this.isExpanded,
    required this.onToggle,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final bool isWorkshop = location.type == 'workshop';
    final Color accent = isWorkshop ? AppColors.orangePrimary : AppColors.cyan;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 32,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy < -10 && !isExpanded) {
                    onToggle();
                  } else if (details.delta.dy > 10 && isExpanded) {
                    onToggle();
                  }
                },
                onTap: onToggle,
                child: Container(
                  width: double.infinity,
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.borderLight,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
              
              Flexible(
                child: SingleChildScrollView(
                  physics: isExpanded ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(accent, isWorkshop),
                        const SizedBox(height: 16),
                        _buildQuickStats(),
                        const SizedBox(height: 16),
                        _buildInfoGrid(),
                        if (location.specialties != null) ...[
                          const SizedBox(height: 16),
                          _buildSpecialties(),
                        ],
                        const SizedBox(height: 24),
                        _buildActionButtons(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color accent, bool isWorkshop) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: accent.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accent.withOpacity(0.3)),
          ),
          child: Icon(
            isWorkshop ? Icons.build_rounded : Icons.local_gas_station_rounded,
            color: accent,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded, size: 12, color: AppColors.textDark),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      location.address,
                      style: const TextStyle(color: AppColors.textDark, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.close_rounded, color: AppColors.textMuted, size: 18),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.border,
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        StarRating(rating: location.rating),
        const SizedBox(width: 6),
        Text(
          location.rating.toString(),
          style: const TextStyle(
            color: AppColors.orangeSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '(${location.reviews})',
          style: const TextStyle(color: AppColors.textDark, fontSize: 12),
        ),
        const SizedBox(width: 12),
        Container(width: 1, height: 14, color: AppColors.border),
        const SizedBox(width: 12),
        Text(
          location.distance,
          style: const TextStyle(color: AppColors.cyan, fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 12),
        Container(width: 1, height: 14, color: AppColors.border),
        const SizedBox(width: 12),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: location.open ? AppColors.green : AppColors.red,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          location.open ? 'Open Now' : 'Closed',
          style: TextStyle(
            color: location.open ? AppColors.green : AppColors.red,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          location.priceLevel,
          style: const TextStyle(color: AppColors.textDark, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildInfoGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoTag(Icons.access_time_filled_rounded, location.hours),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildInfoTag(Icons.phone_rounded, location.phone),
        ),
      ],
    );
  }

  Widget _buildInfoTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialties() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SPECIALTIES',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: location.specialties!.map((s) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.orangePrimary.withOpacity(0.08),
              border: Border.all(color: AppColors.orangePrimary.withOpacity(0.15)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              s,
              style: const TextStyle(
                color: AppColors.orangeSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Navigating to ${location.name}...'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.surface,
                ),
              );
            },
            variant: ButtonVariant.gradient,
            size: ButtonSize.lg,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.directions_rounded, color: Colors.white, size: 20),
                SizedBox(width: 10),
                Text(
                  'Navigate',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        _buildCircularAction(
          Icons.call_rounded,
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Calling ${location.phone}...'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCircularAction(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        width: 52,
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.cyan, size: 22),
      ),
    );
  }
}
