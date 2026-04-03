import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_theme.dart';
import '../core/i18n/translations.g.dart';
import '../core/responsive/responsive.dart';

import '../features/map/domain/entities/map_location.dart';
import '../features/map/presentation/providers/map_providers.dart';
import '../features/map/presentation/widgets/map_marker_layer.dart';
import '../features/map/presentation/widgets/map_controls.dart';
import '../features/map/presentation/widgets/map_header.dart';
import '../widgets/map/place_detail_sheet.dart';
import '../widgets/map/places_list_sheet.dart';

class ServiceMapPage extends ConsumerStatefulWidget {
  const ServiceMapPage({super.key});

  @override
  ConsumerState<ServiceMapPage> createState() => _ServiceMapPageState();
}

class _ServiceMapPageState extends ConsumerState<ServiceMapPage> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  late final AnimationController _animationController;
  late Tween<double> _latTween;
  late Tween<double> _lngTween;
  late Tween<double> _zoomTween;
  bool _sheetExpanded = false;
  bool _mapMovedSinceSearch = false;
  bool _hasSearched = false;
  LatLng? _lastSearchCenter;
  
  // Default center if no user location (e.g. Mexico City for the mock data)
  final LatLng _defaultCenter = const LatLng(19.4326, -99.1332);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 600)
    );
    final curve = CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn);
    _animationController.addListener(() {
      _mapController.move(
        LatLng(_latTween.evaluate(curve), _lngTween.evaluate(curve)),
        _zoomTween.evaluate(curve)
      );
    });
    
    // GPS will now only activate upon user request via the "My Location" button
    // which calls _centerOnUser -> fetchCurrentLocation.
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    if (_animationController.isAnimating) {
      _animationController.stop();
    }
    _latTween = Tween<double>(begin: _mapController.camera.center.latitude, end: destLocation.latitude);
    _lngTween = Tween<double>(begin: _mapController.camera.center.longitude, end: destLocation.longitude);
    _zoomTween = Tween<double>(begin: _mapController.camera.zoom, end: destZoom);

    _animationController.reset();
    _animationController.forward();
  }

  void _onLocationSelected(MapLocation loc) {
    ref.read(selectedLocationProvider.notifier).setLocation(loc);
    setState(() => _sheetExpanded = false);
    
    // Animate map to location
    _animatedMapMove(LatLng(loc.latitude, loc.longitude), 15.0);
  }

  void _unselectLocation() {
    ref.read(selectedLocationProvider.notifier).setLocation(null);
    setState(() => _sheetExpanded = false);
  }

  void _centerOnUser() {
    final userLocState = ref.read(userLocationProvider);
    userLocState.whenData((LatLng? loc) {
      if (loc != null) {
        _animatedMapMove(loc, 15.0);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Buscando ubicación GPS... Asegúrate de tener la ubicación activada en tu dispositivo.')),
        );
        ref.read(userLocationProvider.notifier).fetchCurrentLocation();
      }
    });
  }

  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    _animatedMapMove(_mapController.camera.center, currentZoom + 1);
  }

  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    _animatedMapMove(_mapController.camera.center, currentZoom - 1);
  }

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    final locationsAsync = ref.watch(nearbyLocationsProvider);
    final selectedLocation = ref.watch(selectedLocationProvider);
    final userLocationAsync = ref.watch(userLocationProvider);

    // Show errors (e.g. 429/504 from Overpass)
    ref.listen(nearbyLocationsProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Translations.of(context).map.overpassError),
            backgroundColor: AppColors.red,
          ),
        );
      }
    });

    // Auto-fly removed to prevent "returning to previous zone" annoyance.
    // The user will now stay where they panned.

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Interactive Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _defaultCenter,
              initialZoom: 13.0,
              minZoom: 3.0,
              maxZoom: 18.0,
              onTap: (_, __) => _unselectLocation(),
              onPositionChanged: (camera, hasGesture) {
                ref.read(mapBoundsProvider.notifier).setBounds(camera.visibleBounds);
                
                // If the user moved the map manually, show the "Search here" button
                if (hasGesture) {
                  setState(() => _mapMovedSinceSearch = true);
                }
              },
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.drivetrack',
                tileProvider: CancellableNetworkTileProvider(),
              ),
              
              // Map locations from provider
              locationsAsync.when(
                skipLoadingOnReload: true, // Crucial: Don't hide markers while dragging/loading new ones
                data: (locations) => MapMarkerLayer(
                  locations: locations,
                  selectedId: selectedLocation?.id,
                  onMarkerTap: _onLocationSelected,
                ),
                loading: () => const SizedBox.shrink(),
                error: (err, stack) {
                  print('DEBUG: Error loading markers: $err');
                  return const SizedBox.shrink();
                },
              ),

              // User location marker
              userLocationAsync.when(
                data: (LatLng? loc) {
                  if (loc == null) return const SizedBox.shrink();
                  return MarkerLayer(
                    markers: [
                      Marker(
                        point: loc,
                        width: r.dim(40),
                        height: r.dim(40),
                        child: _buildUserLocationMarker(context, r),
                      )
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              
              const RichAttributionWidget(
                attributions: [
                  TextSourceAttribution('OpenStreetMap contributors'),
                ],
              ),
            ],
          ),

          // 2. Top Header Overlay (Search & Filters)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MapHeaderWidget(
              onFilterChanged: () {
                _unselectLocation();
                setState(() {
                  _mapMovedSinceSearch = false;
                  _hasSearched = true;
                });
              },
            ),
          ),

          // 2.5 "Search this area" — bottom floating pill (Google Maps pattern)
          if (_mapMovedSinceSearch)
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _mapMovedSinceSearch = false;
                      _hasSearched = true;
                    });
                    ref.read(mapSearchTriggerProvider.notifier).trigger();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: r.space(AppSpacing.lg),
                      vertical: r.space(AppSpacing.s),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(r.r(AppRadius.xl)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_rounded, size: AppIconSizes.xs(context), color: AppColors.cyan),
                        SizedBox(width: r.space(AppSpacing.xs)),
                        Text(
                          Translations.of(context).map.searchThisArea,
                          style: AppTextStyles.bodySmall(context).copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // 3. Map Controls (Zoom, My Location)
          Positioned(
            right: r.space(AppSpacing.lg),
            bottom: r.dim(180),
            child: MapControls(
              onZoomIn: _zoomIn,
              onZoomOut: _zoomOut,
              onMyLocation: _centerOnUser,
            ),
          ),

          // 4. Bottom Detail / List Sheets
          if (selectedLocation != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: PlaceDetailSheet(
                location: selectedLocation,
                isExpanded: _sheetExpanded,
                onToggle: () => setState(() => _sheetExpanded = !_sheetExpanded),
                onClose: _unselectLocation,
              ),
            )
          else if (_hasSearched && locationsAsync.hasValue && locationsAsync.value!.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: PlacesListSheet(
                locations: locationsAsync.value!,
                isExpanded: _sheetExpanded,
                onToggle: () => setState(() => _sheetExpanded = !_sheetExpanded),
                onLocationSelected: _onLocationSelected,
              ),
            ),
            
          // Loading Overlay if fetching first time
          if (locationsAsync.isLoading && !locationsAsync.hasValue)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(child: CircularProgressIndicator(color: AppColors.cyan)),
            ),
        ],
      ),
    );
  }

  Widget _buildUserLocationMarker(BuildContext context, AppResponsive r) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: r.dim(20),
          height: r.dim(20),
          decoration: BoxDecoration(
            color: AppColors.cyan.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.cyan.withValues(alpha: 0.4), width: 2),
            boxShadow: [
              BoxShadow(color: AppColors.cyan.withValues(alpha: 0.5), blurRadius: 12),
            ],
          ),
          child: Center(
            child: Container(
              width: r.dim(10),
              height: r.dim(10),
              decoration: const BoxDecoration(
                color: AppColors.cyan,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
