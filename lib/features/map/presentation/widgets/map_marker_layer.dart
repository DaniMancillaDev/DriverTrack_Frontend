import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/entities/map_location.dart';
import '../../../../theme/app_theme.dart';
import '../../../../core/responsive/responsive.dart';

class MapMarkerLayer extends StatelessWidget {
  final List<MapLocation> locations;
  final String? selectedId;
  final Function(MapLocation) onMarkerTap;

  const MapMarkerLayer({
    super.key,
    required this.locations,
    required this.selectedId,
    required this.onMarkerTap,
  });

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: locations.map((loc) {
        final bool isSelected = selectedId == loc.id;
        final bool isWorkshop = loc.type == 'workshop';
        final Color accent = isWorkshop
            ? AppColors.orangePrimary
            : AppColors.cyan;
        final r = context.responsive;

        // Size changes animated via AnimatedContainer inside the marker builder
        final double baseSize = r.dim(isSelected ? 60 : 45);

        return Marker(
          point: LatLng(loc.latitude, loc.longitude),
          width: baseSize,
          height: baseSize,
          // Bottom center ensures the tip of the "needle" is exactly at the GPS coordinate
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () => onMarkerTap(loc),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: r.dim(isSelected ? 44 : 36),
                    height: r.dim(isSelected ? 44 : 36),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? accent
                          : accent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(
                        r.r(isSelected ? AppRadius.xl : AppRadius.md),
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: accent.withValues(alpha: 0.4),
                                blurRadius: 14,
                                spreadRadius: 0,
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      isWorkshop ? Icons.build : Icons.local_gas_station,
                      color: isSelected ? Colors.white : accent,
                      size: isSelected
                          ? AppIconSizes.lg(context)
                          : AppIconSizes.sm(context),
                    ),
                  ),
                  Container(
                    width: 2,
                    height: r.dim(isSelected ? 10 : 6),
                    color: accent,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
