import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../pages/service_map_page.dart';
import '../ui/custom_list_card.dart';

class PlacesListSheet extends StatelessWidget {
  final List<Location> locations;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Function(Location) onLocationSelected;

  const PlacesListSheet({
    super.key,
    required this.locations,
    required this.isExpanded,
    required this.onToggle,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
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
              // Handle / Initial Strip
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy < -10 && !isExpanded) {
                    onToggle();
                  } else if (details.delta.dy > 10 && isExpanded) {
                    onToggle();
                  }
                },
                onTap: onToggle,
                child: _buildHandleStrip(),
              ),
              
              if (isExpanded)
                Flexible(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    itemCount: locations.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final loc = locations[index];
                      final bool isWorkshop = loc.type == 'workshop';
                      final Color accent = isWorkshop ? AppColors.orangePrimary : AppColors.cyan;
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CustomListCard(
                          onTap: () => onLocationSelected(loc),
                          leading: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: accent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: accent.withOpacity(0.2)),
                            ),
                            child: Icon(
                              isWorkshop ? Icons.build_rounded : Icons.local_gas_station_rounded,
                              color: accent,
                              size: 20,
                            ),
                          ),
                          title: loc.name,
                          subtitle: loc.address,
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                loc.distance,
                                style: const TextStyle(
                                  color: AppColors.cyan,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, size: 12, color: AppColors.orangeSecondary),
                                  const SizedBox(width: 2),
                                  Text(
                                    loc.rating.toString(),
                                    style: const TextStyle(
                                      color: AppColors.textMain,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandleStrip() {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nearby Results',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${locations.length} locations found',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildCountBadge(
                    Icons.build_rounded,
                    AppColors.orangePrimary,
                    locations.where((l) => l.type == 'workshop').length.toString(),
                  ),
                  const SizedBox(width: 8),
                  _buildCountBadge(
                    Icons.local_gas_station_rounded,
                    AppColors.cyan,
                    locations.where((l) => l.type == 'gasstation').length.toString(),
                  ),
                ],
              ),
            ],
          ),
          if (!isExpanded) ...[
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Swipe up to see all options',
                style: TextStyle(color: AppColors.textDim, fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCountBadge(IconData icon, Color color, String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(
            count,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
