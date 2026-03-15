import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/ui/star_rating.dart';
import '../widgets/ui/custom_button.dart';
import '../widgets/map/place_detail_sheet.dart';
import '../widgets/map/places_list_sheet.dart';

class Location {
  final String id;
  final String name;
  final String type; // 'workshop' | 'gasstation'
  final String address;
  final double rating;
  final int reviews;
  final String distance;
  final bool open;
  final String hours;
  final String phone;
  final double x; // percent position on map
  final double y;
  final List<String>? specialties;
  final String priceLevel;

  Location({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.rating,
    required this.reviews,
    required this.distance,
    required this.open,
    required this.hours,
    required this.phone,
    required this.x,
    required this.y,
    this.specialties,
    required this.priceLevel,
  });
}

final List<Location> locations = [
  Location(
    id: "l1",
    name: "AutoTech Pro Workshop",
    type: "workshop",
    address: "1420 Motor Lane, Downtown",
    rating: 4.8,
    reviews: 247,
    distance: "0.3 mi",
    open: true,
    hours: "Mon–Sat 8AM–7PM",
    phone: "+1 (555) 201-4455",
    x: 28,
    y: 35,
    specialties: ["Oil Change", "Brakes", "Engine Repair"],
    priceLevel: "\$\$",
  ),
  Location(
    id: "l2",
    name: "SpeedFix Garage",
    type: "workshop",
    address: "88 Gear Street, Midtown",
    rating: 4.5,
    reviews: 183,
    distance: "0.7 mi",
    open: true,
    hours: "Mon–Sun 7AM–9PM",
    phone: "+1 (555) 307-8821",
    x: 62,
    y: 52,
    specialties: ["Tires", "Alignment", "Diagnostics"],
    priceLevel: "\$",
  ),
  Location(
    id: "l3",
    name: "QuickFuel Station",
    type: "gasstation",
    address: "333 Highway Blvd",
    rating: 4.2,
    reviews: 95,
    distance: "0.4 mi",
    open: true,
    hours: "Open 24 Hours",
    phone: "+1 (555) 400-2200",
    x: 45,
    y: 22,
    priceLevel: "\$",
  ),
  Location(
    id: "l4",
    name: "Premium Auto Care",
    type: "workshop",
    address: "750 Service Rd, Westside",
    rating: 4.9,
    reviews: 512,
    distance: "1.2 mi",
    open: false,
    hours: "Mon–Fri 9AM–6PM",
    phone: "+1 (555) 511-6690",
    x: 74,
    y: 68,
    specialties: ["Luxury Cars", "Full Detail", "AC Repair"],
    priceLevel: "\$\$\$",
  ),
  Location(
    id: "l5",
    name: "EnergyFuel 24/7",
    type: "gasstation",
    address: "12 Central Ave",
    rating: 3.9,
    reviews: 78,
    distance: "0.9 mi",
    open: true,
    hours: "Open 24 Hours",
    phone: "+1 (555) 600-1133",
    x: 20,
    y: 65,
    priceLevel: "\$\$",
  ),
  Location(
    id: "l6",
    name: "MotoFix Specialist",
    type: "workshop",
    address: "501 Rider's Blvd, East",
    rating: 4.7,
    reviews: 134,
    distance: "1.5 mi",
    open: true,
    hours: "Tue–Sun 10AM–8PM",
    phone: "+1 (555) 712-3344",
    x: 50,
    y: 75,
    specialties: ["Motorcycles", "Scooters", "Tune-up"],
    priceLevel: "\$\$",
  ),
];

class ServiceMapPage extends StatefulWidget {
  const ServiceMapPage({super.key});

  @override
  State<ServiceMapPage> createState() => _ServiceMapPageState();
}

class _ServiceMapPageState extends State<ServiceMapPage> {
  String? _selectedId;
  String _filter = 'all';
  String _searchQuery = '';
  bool _sheetExpanded = false;

  @override
  Widget build(BuildContext context) {
    final filtered = locations.where((l) {
      if (_filter != 'all' && l.type != _filter) return false;
      if (_searchQuery.isNotEmpty && !l.name.toLowerCase().contains(_searchQuery.toLowerCase())) return false;
      return true;
    }).toList();

    final selected = _selectedId != null ? locations.firstWhere((l) => l.id == _selectedId) : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Map Background
          Positioned.fill(
            child: CustomPaint(
              painter: MapBackgroundPainter(),
            ),
          ),

          // User Location
          const Center(
            child: UserLocationMarker(),
          ),

          // Markers
          ...filtered.map((loc) => MapMarker(
                location: loc,
                isSelected: _selectedId == loc.id,
                onTap: () {
                  setState(() {
                    if (_selectedId == loc.id) {
                      _selectedId = null;
                      _sheetExpanded = false;
                    } else {
                      _selectedId = loc.id;
                      _sheetExpanded = false;
                    }
                  });
                },
              )),

          // Top Header Overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildHeader(),
          ),

          // Bottom Detail Sheet
          if (selected != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: PlaceDetailSheet(
                location: selected,
                isExpanded: _sheetExpanded,
                onToggle: () => setState(() => _sheetExpanded = !_sheetExpanded),
                onClose: () => setState(() {
                  _selectedId = null;
                  _sheetExpanded = false;
                }),
              ),
            )
          else
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: PlacesListSheet(
                locations: filtered,
                isExpanded: _sheetExpanded,
                onToggle: () => setState(() => _sheetExpanded = !_sheetExpanded),
                onLocationSelected: (loc) {
                  setState(() {
                    _selectedId = loc.id;
                    _sheetExpanded = false;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background,
            AppColors.background.withOpacity(0.8),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Explore Nearby', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  Text(
                    'Service Map 📍',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.cyan.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cyan.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.near_me, size: 12, color: AppColors.cyan),
                    SizedBox(width: 6),
                    Text('Live', style: TextStyle(color: AppColors.cyan, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search workshops, gas stations...',
                hintStyle: const TextStyle(color: AppColors.textDark),
                prefixIcon: const Icon(Icons.search, color: AppColors.textDark, size: 18),
                suffixIcon: _searchQuery.isNotEmpty 
                    ? IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textDark, size: 16),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Filter Pills
          Row(
            children: [
              _buildFilterPill('all', 'All', Icons.filter_list),
              const SizedBox(width: 8),
              _buildFilterPill('workshop', 'Workshops', Icons.build),
              const SizedBox(width: 8),
              _buildFilterPill('gasstation', 'Gas Stations', Icons.local_gas_station),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String key, String label, IconData icon) {
    final bool isSelected = _filter == key;
    Color accent = AppColors.orangePrimary;
    if (key == 'gasstation') accent = AppColors.cyan;

    return GestureDetector(
      onTap: () => setState(() => _filter = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? accent.withOpacity(0.15) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? accent.withOpacity(0.4) : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: isSelected ? accent : AppColors.textMuted),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? accent : AppColors.textMuted,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
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
          Text(count, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class MapMarker extends StatelessWidget {
  final Location location;
  final bool isSelected;
  final VoidCallback onTap;

  const MapMarker({
    super.key,
    required this.location,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isWorkshop = location.type == 'workshop';
    final Color accent = isWorkshop ? AppColors.orangePrimary : AppColors.cyan;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      left: MediaQuery.of(context).size.width * (location.x / 100),
      top: MediaQuery.of(context).size.height * (location.y / 100),
      child: FractionalTranslation(
        translation: const Offset(-0.5, -1.0),
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: isSelected ? 44 : 36,
                height: isSelected ? 44 : 36,
                decoration: BoxDecoration(
                  color: isSelected ? accent : accent.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(isSelected ? 20 : 16),
                  border: Border.all(color: accent, width: 2),
                  boxShadow: isSelected ? [
                    BoxShadow(color: accent.withOpacity(0.5), blurRadius: 12, spreadRadius: 2),
                  ] : null,
                ),
                child: Icon(
                  isWorkshop ? Icons.build : Icons.local_gas_station,
                  color: isSelected ? Colors.white : accent,
                  size: isSelected ? 20 : 16,
                ),
              ),
              Container(
                width: 2,
                height: 8,
                color: accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserLocationMarker extends StatelessWidget {
  const UserLocationMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.cyan.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.cyan.withOpacity(0.4), width: 2),
          ),
          child: Center(
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.cyan,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppColors.cyan.withOpacity(0.5), blurRadius: 12),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.cyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.cyan.withOpacity(0.3)),
          ),
          child: const Text('You', style: TextStyle(color: AppColors.cyan, fontSize: 9, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

class MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF141418)
      ..style = PaintingStyle.fill;

    // Background
    canvas.drawRect(Offset.zero & size, paint);

    // City Blocks
    paint.color = const Color(0xFF1A1A20);
    final blocks = [
      [10, 10, 110, 80],
      [130, 10, 110, 80],
      [260, 10, 130, 80],
      [10, 110, 80, 90],
      [110, 100, 160, 100],
      [290, 100, 100, 90],
      [10, 230, 120, 80],
      [150, 210, 100, 90],
      [270, 220, 120, 80],
    ];

    for (var b in blocks) {
      canvas.drawRRect(
        RRect.fromLTRBR(
          b[0] * size.width / 400,
          b[1] * size.height / 320,
          (b[0] + b[2]) * size.width / 400,
          (b[1] + b[3]) * size.height / 320,
          const Radius.circular(4),
        ),
        paint,
      );
    }

    // Main Roads
    paint.color = const Color(0xFF202028);
    // Horizontal roads
    canvas.drawRect(
      Rect.fromLTRB(0, 90 * size.height / 320, size.width, 108 * size.height / 320),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTRB(0, 195 * size.height / 320, size.width, 213 * size.height / 320),
      paint,
    );
    // Vertical roads
    canvas.drawRect(
      Rect.fromLTRB(120 * size.width / 400, 0, 134 * size.width / 400, size.height),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTRB(252 * size.width / 400, 0, 266 * size.width / 400, size.height),
      paint,
    );

    // Lane markings
    paint.color = const Color(0xFF2E2E38);
    final hMarkings = [0, 40, 80, 120, 160, 200, 240, 280, 320, 360];
    for (var x in hMarkings) {
      canvas.drawRRect(
        RRect.fromLTRBR(x * size.width / 400, 98 * size.height / 320, (x + 20) * size.width / 400, 100 * size.height / 320, const Radius.circular(1)),
        paint,
      );
      canvas.drawRRect(
        RRect.fromLTRBR(x * size.width / 400, 203 * size.height / 320, (x + 20) * size.width / 400, 205 * size.height / 320, const Radius.circular(1)),
        paint,
      );
    }
    final vMarkings = [0, 40, 80, 120, 160, 200, 240, 280];
    for (var y in vMarkings) {
      canvas.drawRRect(
        RRect.fromLTRBR(128 * size.width / 400, y * size.height / 320, 130 * size.width / 400, (y + 20) * size.height / 320, const Radius.circular(1)),
        paint,
      );
      canvas.drawRRect(
        RRect.fromLTRBR(260 * size.width / 400, y * size.height / 320, 262 * size.width / 400, (y + 20) * size.height / 320, const Radius.circular(1)),
        paint,
      );
    }

    // Park area
    paint.color = const Color(0xFF172218);
    canvas.drawRRect(
      RRect.fromLTRBR(
        130 * size.width / 400,
        108 * size.height / 320,
        250 * size.width / 400,
        188 * size.height / 320,
        const Radius.circular(8),
      ),
      paint,
    );

    // Park Text
    const textStyle = TextStyle(
      color: Color(0xFF243024),
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );
    final textPainter = TextPainter(
      text: const TextSpan(text: 'CITY PARK', style: textStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        190 * size.width / 400 - textPainter.width / 2,
        148 * size.height / 320 - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
