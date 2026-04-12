import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';
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
import '../theme/app_color_scheme.dart';

/// Explorador geoespacial de servicios automotrices.
/// 
/// Provee una interfaz cartográfica interactiva para localizar infraestructura de 
/// apoyo al conductor. Implementa:
/// * **Búsqueda Dinámica**: Localización de talleres, gasolineras y refaccionarias 
///   basada en el área visible del mapa (Bounding Box).
/// * **Integración Overpass**: Consulta en tiempo real a OpenStreetMap para 
///   obtener datos actualizados de servicios.
/// * **Navegación Intuitiva**: Fly-to animado a locaciones seleccionadas y 
///   seguimiento GPS de la posición del usuario.
class ServiceMapPage extends ConsumerStatefulWidget {
  const ServiceMapPage({super.key});

  @override
  ConsumerState<ServiceMapPage> createState() => _ServiceMapPageState();
}

class _ServiceMapPageState extends ConsumerState<ServiceMapPage>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  late final AnimationController _animationController;
  late Tween<double> _latTween;
  late Tween<double> _lngTween;
  late Tween<double> _zoomTween;

  bool _mapMovedSinceSearch = false;
  bool _hasSearched = false;
  LatLng? _lastSearchCenter;
  bool _isLocating = false;

  // Centro por defecto si no hay ubicación del usuario (ej. Ciudad de México para datos de prueba)
  final LatLng _defaultCenter = const LatLng(19.4326, -99.1332);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    final curve = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    );
    _animationController.addListener(() {
      _mapController.move(
        LatLng(_latTween.evaluate(curve), _lngTween.evaluate(curve)),
        _zoomTween.evaluate(curve),
      );
    });

    // El GPS ahora solo se activa bajo solicitud del usuario mediante el botón
    // "Mi ubicación", el cual llama a _centerOnUser -> fetchCurrentLocation.
  }

  @override
  void dispose() {
    ScaffoldMessenger.of(context).clearSnackBars();
    _animationController.dispose();
    super.dispose();
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    if (_animationController.isAnimating) {
      _animationController.stop();
    }
    _latTween = Tween<double>(
      begin: _mapController.camera.center.latitude,
      end: destLocation.latitude,
    );
    _lngTween = Tween<double>(
      begin: _mapController.camera.center.longitude,
      end: destLocation.longitude,
    );
    _zoomTween = Tween<double>(
      begin: _mapController.camera.zoom,
      end: destZoom,
    );

    _animationController.reset();
    _animationController.forward();
  }

  void _onLocationSelected(MapLocation loc) {
    ref.read(selectedLocationProvider.notifier).setLocation(loc);

    // Anima el mapa hacia la ubicación
    _animatedMapMove(LatLng(loc.latitude, loc.longitude), 15.0);
  }

  void _unselectLocation() {
    final selectedLocation = ref.read(selectedLocationProvider);
    if (selectedLocation != null) {
      ref.read(selectedLocationProvider.notifier).setLocation(null);
    } else if (_hasSearched) {
      if (mounted) setState(() => _hasSearched = false);
    }
  }

  void _centerOnUser() {
    if (_isLocating) return; // Debounce/bloqueo temporal
    
    setState(() => _isLocating = true);

    // Limpia notificaciones previas antes de mostrar la nueva
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          Translations.of(context).map.gpsSearching,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Obligar siempre a refrescar la ubicación limpia y después centrar
    ref.read(userLocationProvider.notifier).fetchCurrentLocation().then((_) {
      if (!mounted) return;
      setState(() => _isLocating = false);
      
      final freshLoc = ref.read(userLocationProvider).value;
      if (freshLoc != null) {
        _animatedMapMove(freshLoc, 15.0);
      }
    }).catchError((_) {
      // Garantizar limpieza de estado si falla
      if (mounted) setState(() => _isLocating = false);
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mapStyle = isDark ? 'dark_all' : 'light_all';

    // Retroalimentación de estado vacío (Sin resultados)
    ref.listen(nearbyLocationsProvider, (previous, next) {
      if (!next.isLoading && next.hasValue && next.value!.isEmpty && _hasSearched) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                Translations.of(context).map.noResults,
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
          setState(() => _hasSearched = false);
        }
      }
    });

    // Los errores de la API Overpass (429/504) ahora se manejan silenciosamente
    // para evitar saturar al usuario con snackbars rojos. El mapa conservará
    // los puntos previamente cargados si una petición falla.

    // Se eliminó el auto-fly para evitar la molestia de "regresar a la zona anterior".
    // El usuario ahora permanece donde desplazó el mapa.

    return Scaffold(
      backgroundColor: context.colors.background,
      body: Column(
        children: [
          // ── Encabezado (no flotante, en flujo natural del Column) ──
          MapHeaderWidget(
            onFilterChanged: () {
              _unselectLocation();
              setState(() {
                _mapMovedSinceSearch = false;
                _hasSearched = true;
              });
            },
          ),

          // ── Área del mapa (Expanded + Stack para controles flotantes) ──
          Expanded(
            child: Stack(
              children: [
                // 1. Mapa interactivo
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _defaultCenter,
                    initialZoom: 13.0,
                    minZoom: 3.0,
                    maxZoom: 18.0,
                    onTap: (_, __) => _unselectLocation(),
                    onPositionChanged: (camera, hasGesture) {
                      ref
                          .read(mapBoundsProvider.notifier)
                          .setBounds(camera.visibleBounds);

                      // Si el usuario movió el mapa manualmente, muestra el botón "Buscar aquí"
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
                      urlTemplate:
                          'https://{s}.basemaps.cartocdn.com/$mapStyle/{z}/{x}/{y}{r}.png',
                      subdomains: const ['a', 'b', 'c', 'd'],
                      userAgentPackageName: 'com.example.drivetrack',
                      tileProvider: CancellableNetworkTileProvider(),
                    ),

                    // Ubicaciones del mapa desde el provider
                    locationsAsync.when(
                      skipLoadingOnReload:
                          true, // Crucial: No ocultar marcadores mientras se arrastra/cargan nuevos
                      data: (locations) => MapMarkerLayer(
                        locations: locations,
                        selectedId: selectedLocation?.id,
                        onMarkerTap: _onLocationSelected,
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (err, stack) {
                        if (kDebugMode) {
                          dev.log(
                            'Error loading markers: $err',
                            name: 'ServiceMapPage',
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    // Marcador de ubicación del usuario
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
                            ),
                          ],
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),

                    const RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution('© CartoDB'),
                        TextSourceAttribution('© OpenStreetMap contributors'),
                      ],
                    ),
                  ],
                ),

                // 2. "Buscar en esta área" — píldora flotante (patrón de Google Maps)
                Positioned(
                  top: r.space(AppSpacing.lg),
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    opacity: _mapMovedSinceSearch ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: AnimatedSlide(
                      offset: Offset(0, _mapMovedSinceSearch ? 0.0 : -0.15),
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: IgnorePointer(
                        ignoring: !_mapMovedSinceSearch,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _mapMovedSinceSearch = false;
                                _hasSearched = true;
                              });
                              ref
                                  .read(mapSearchTriggerProvider.notifier)
                                  .trigger();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: r.space(AppSpacing.lg),
                                vertical: r.space(AppSpacing.s),
                              ),
                              decoration: BoxDecoration(
                                color: context.colors.surface,
                                border: Border.all(
                                  color: context.colors.borderLight,
                                ),
                                borderRadius:
                                    BorderRadius.circular(r.r(AppRadius.xl)),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.search_rounded,
                                    size: AppIconSizes.xs(context),
                                    color: AppColors.cyan,
                                  ),
                                  SizedBox(width: r.space(AppSpacing.xs)),
                                  Text(
                                    Translations.of(context).map.searchThisArea,
                                    style:
                                        AppTextStyles.bodySmall(context).copyWith(
                                      color: context.colors.textMain,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // 3. Controles del mapa (Zoom, Mi ubicación)
                Positioned(
                  right: r.space(AppSpacing.lg),
                  bottom: r.space(AppSpacing.xxxl),
                  child: MapControls(
                    onZoomIn: _zoomIn,
                    onZoomOut: _zoomOut,
                    onMyLocation: _isLocating ? null : _centerOnUser,
                  ),
                ),

                // 4. Sheets inferiores de Detalle / Lista
                if (selectedLocation != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: PlaceDetailSheet(
                      location: selectedLocation,
                      onClose: _unselectLocation,
                    ),
                  )
                else if (_hasSearched &&
                    !locationsAsync.isLoading &&
                    locationsAsync.hasValue &&
                    locationsAsync.value!.isNotEmpty)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: PlacesListSheet(
                      locations: locationsAsync.value!,
                      onLocationSelected: _onLocationSelected,
                      onClose: () {
                        if (mounted) setState(() => _hasSearched = false);
                      },
                    ),
                  ),
              ],
            ),
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
            border: Border.all(
              color: AppColors.cyan.withValues(alpha: 0.4),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.cyan.withValues(alpha: 0.5),
                blurRadius: 12,
              ),
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
