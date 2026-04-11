# flutter_map + OpenStreetMap Integration

Migrate the DriverTrack service map from a fake `CustomPainter` placeholder to a
real interactive map using `flutter_map` + OpenStreetMap tiles, connected to real
data (or curated fallback), with full Clean Architecture.

---

## 🔍 Code Review Findings

### Critical Issues
| File | Problem | Severity |
|------|---------|----------|
| [service_map_page.dart](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/pages/service_map_page.dart) | [Location](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/pages/service_map_page.dart#9-42) model **defined inside the page file** — kills testability & reuse | 🔴 High |
| [service_map_page.dart](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/pages/service_map_page.dart) | All 6 locations are **100% hardcoded mocks**, never touch the API | 🔴 High |
| [service_map_page.dart](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/pages/service_map_page.dart) | [MapBackgroundPainter](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/pages/service_map_page.dart#566-677) is a **fake canvas painting**, not a real map | 🔴 High |
| [service_map_page.dart](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/pages/service_map_page.dart) | [MapMarker](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/pages/service_map_page.dart#448-510) uses **`x/y` percentages** to position pins — breaks completely on any screen size change | 🔴 High |
| [service_map_page.dart](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/pages/service_map_page.dart) | [_buildInfoTag](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/pages/service_map_page.dart#393-418), [_buildCountBadge](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/pages/service_map_page.dart#419-446) are **dead code** (exist in both the page AND the widgets) | 🟡 Medium |
| [place_detail_sheet.dart](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/widgets/map/place_detail_sheet.dart) | Imports [Location](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/pages/service_map_page.dart#9-42) from [service_map_page.dart](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/pages/service_map_page.dart) — creates circular coupling | 🟡 Medium |
| [place_detail_sheet.dart](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/widgets/map/place_detail_sheet.dart) | "SPECIALTIES" label is **hardcoded English**, not i18n | 🟡 Medium |
| [place_detail_sheet.dart](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/widgets/map/place_detail_sheet.dart) | `navigatingTo` uses `.replaceAll()` instead of slang's param syntax | 🟡 Medium |
| [pubspec.yaml](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/pubspec.yaml) | `geolocator` is a dependency but **no Android/iOS permission manifests** configured | 🟡 Medium |

### What's Well Done (Reuse)
- [PlaceDetailSheet](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/widgets/map/place_detail_sheet.dart#9-399) and [PlacesListSheet](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/widgets/map/places_list_sheet.dart#8-248) UI is excellent — **keep as-is**, only swap the [Location](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/pages/service_map_page.dart#9-42) import
- Filter Pills + Search Bar logic is clean — **move to provider**
- [AppColors](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/theme/app_theme.dart#3-45), `AppTextStyles`, [AppSpacing](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/theme/app_theme.dart#46-58) design system — **reuse fully**
- `AsyncNotifier` pattern in [app_providers.dart](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/providers/app_providers.dart) — **replicate exactly**
- [ApiClient](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/services/api_client.dart#6-88) is generic enough — **use directly**

---

## 🏛️ Architectural Decision: Opción A (Frontend) con preparación para B

**Decision: Frontend handles markers, filters and search; backend is prepared for future.**

**Justification:**
- Your backend (`FastAPI`) has no `/map` or `/locations` endpoint yet — building backend logic first would block progress
- Current dataset (workshops, gas stations) is small enough for client-side filtering with **zero latency**
- `flutter_map` renders markers natively — no server round-trip needed per interaction
- **Opción B tradeoffs**: requires new FastAPI route, geo-spatial queries (PostGIS or similar), auth-protected endpoint — overkill for MVP
- **Migration path**: the `MapRepository` interface is designed so swapping the `MapRepositoryImpl` from static data → real API is a **1-file change**

---

## 🧱 Architecture Decision: No Backend for Map Data (For Now)

> [!IMPORTANT]
> The current FastAPI backend does **not** have a `/map/locations` endpoint. The implementation will use curated, realistic mock data baked into the repository's fallback. When you're ready to add the backend endpoint, only `map_repository_impl.dart` needs updating — the domain, providers, and UI remain unchanged.

---

## User Review Required

> [!WARNING]
> **Android Permissions**: To use geolocator fully, `AndroidManifest.xml` needs `ACCESS_FINE_LOCATION` and `ACCESS_COARSE_LOCATION` permissions added. I will add these, but verify your [android/app/src/main/AndroidManifest.xml](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/android/app/src/main/AndroidManifest.xml) does not already have conflicting entries.

> [!NOTE]
> **Tile Attribution**: OpenStreetMap tiles require © OpenStreetMap contributors attribution by their license. `flutter_map` provides a built-in `RichAttributionWidget` — I will add it. You do not need to register for an API key; OSM tiles are free.

---

## Proposed Changes

### [pubspec.yaml](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/pubspec.yaml) — Dependencies

#### [MODIFY] [pubspec.yaml](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/pubspec.yaml)
Add three new packages under [dependencies](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/.flutter-plugins-dependencies):
```yaml
flutter_map: ^8.1.1
latlong2: ^0.9.1
flutter_map_cancellable_tile_provider: ^3.1.0
```

---

### Domain Layer (new)

#### [NEW] lib/features/map/domain/entities/map_location.dart
Canonical `MapLocation` entity replacing the page-local [Location](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/pages/service_map_page.dart#9-42) class. Adds `latitude` and `longitude` (real coordinates). Keeps all existing fields (`name`, `type`, `address`, `rating`, `reviews`, `distance`, `open`, `hours`, `phone`, `specialties`, `priceLevel`).

#### [NEW] lib/features/map/domain/repositories/map_repository.dart
Abstract interface:
```dart
abstract class MapRepository {
  Future<List<MapLocation>> getNearbyLocations({String? type, String? search});
}
```

#### [NEW] lib/features/map/domain/usecases/get_nearby_locations.dart
Use-case wrapping the repository call, enabling future param injection (radius, user coords).

---

### Data Layer (new)

#### [NEW] lib/features/map/data/models/map_location_model.dart
JSON-serializable model extending `MapLocation`. `fromJson` factory for when the API is ready.

#### [NEW] lib/features/map/data/repositories/map_repository_impl.dart
Implements `MapRepository`. Tries to call `GET /api/map/locations` on the backend. On [ApiException](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/services/api_client.dart#89-98) or connection error, returns curated fallback data with real lat/lng coordinates (same 6 locations, geocoded to realistic positions).

---

### Providers (new + modify)

#### [NEW] lib/features/map/presentation/providers/map_providers.dart
```dart
// User GPS location
final userLocationProvider = AsyncNotifierProvider<UserLocationNotifier, LatLng?>(...)

// Filter + search state
final mapFilterProvider = StateProvider<String>((ref) => 'all');
final mapSearchProvider = StateProvider<String>((ref) => '');

// Derived filtered list
final nearbyLocationsProvider = AsyncNotifierProvider<NearbyLocationsNotifier, List<MapLocation>>(...)

// Selected location
final selectedLocationProvider = StateProvider<MapLocation?>((ref) => null);
```

#### [MODIFY] [app_providers.dart](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/providers/app_providers.dart)
Add `mapRepositoryProvider` pointing to `MapRepositoryImpl`.

---

### Presentation — Map Page (replace)

#### [MODIFY] [service_map_page.dart](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/pages/service_map_page.dart)
**Complete rewrite** using `flutter_map`:
- `FlutterMap` with `TileLayer` → OpenStreetMap
- `MarkerLayer` from `nearbyLocationsProvider` data
- `MapController` for programmatic camera control
- Header overlay (search + filter pills) → reads/writes providers
- FABs: zoom in, zoom out, "center on me"
- Delegates detail sheet to existing widgets (updated imports)
- Removes the fake [MapBackgroundPainter](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/pages/service_map_page.dart#566-677), local [Location](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/pages/service_map_page.dart#9-42) class, and all dead code

#### [NEW] lib/features/map/presentation/widgets/map_marker_layer.dart
Custom `flutter_map` marker builder. Matches the current visual style (orange for workshops, cyan for gas stations). Selected marker is enlarged with glow. Uses `AnimatedScale` for smooth tap feedback.

#### [NEW] lib/features/map/presentation/widgets/map_controls.dart
Floating controls (zoom +/−, and "my location" button). Positioned bottom-right above the detail sheet.

---

### Existing Modal Widgets (minor update)

#### [MODIFY] [place_detail_sheet.dart](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/widgets/map/place_detail_sheet.dart)
- Change import from [service_map_page.dart](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/pages/service_map_page.dart) → `map_location.dart` entity
- Fix "SPECIALTIES" hardcoded string → `Translations.of(context).map.specialties`

#### [MODIFY] [places_list_sheet.dart](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/widgets/map/places_list_sheet.dart)
- Change import from [service_map_page.dart](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/pages/service_map_page.dart) → `map_location.dart` entity

---

### i18n

#### [MODIFY] [en.i18n.json](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/assets/i18n/en.i18n.json)
Add under `"map"`:
```json
"specialties": "Specialties",
"myLocation": "My Location",
"loadingMap": "Loading map...",
"errorLoadingMap": "Could not load locations",
"noResults": "No results found",
"zoomIn": "Zoom In",
"zoomOut": "Zoom Out"
```

#### [MODIFY] [es.i18n.json](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/assets/i18n/es.i18n.json)
Same keys in Spanish.

---

### Android Permissions

#### [MODIFY] android/app/src/main/AndroidManifest.xml
Add (if not present):
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

---

## 📁 Final File Structure

```
lib/
├── features/
│   └── map/
│       ├── domain/
│       │   ├── entities/map_location.dart         [NEW]
│       │   ├── repositories/map_repository.dart   [NEW]
│       │   └── usecases/get_nearby_locations.dart [NEW]
│       ├── data/
│       │   ├── models/map_location_model.dart     [NEW]
│       │   └── repositories/map_repository_impl.dart [NEW]
│       └── presentation/
│           ├── pages/                             (routing stays in lib/pages/)
│           ├── providers/map_providers.dart       [NEW]
│           └── widgets/
│               ├── map_marker_layer.dart          [NEW]
│               └── map_controls.dart              [NEW]
├── pages/
│   └── service_map_page.dart                      [REWRITE]
├── providers/
│   └── app_providers.dart                         [MODIFY - add mapRepositoryProvider]
└── widgets/
    └── map/
        ├── place_detail_sheet.dart                [MODIFY - import swap]
        └── places_list_sheet.dart                 [MODIFY - import swap]
```

---

## Verification Plan

### Static Analysis
```bash
cd /home/danim/Escritorio/Labs/Python/DriverTrack_Frontend
flutter analyze
```
Expected: zero errors, zero warnings about deprecated members.

### i18n Build
```bash
cd /home/danim/Escritorio/Labs/Python/DriverTrack_Frontend
dart run build_runner build --delete-conflicting-outputs
```
Expected: regenerated `translations.g.dart` with no compile errors.

### Manual Verification (Hot Reload)
```bash
flutter run
```
1. Navigate to the **Map** tab → real OSM map tiles should render (requires internet)
2. Tap a marker → [PlaceDetailSheet](file:///home/danim/Escritorio/Labs/Python/DriverTrack_Frontend/lib/widgets/map/place_detail_sheet.dart#9-399) slides up with correct location data
3. Swipe up on bottom sheet → full list expands
4. Tap filter pill "Workshops" → only orange markers remain
5. Type in search bar → markers filter live
6. Tap **"My Location"** FAB → map centers on device GPS / permission dialog shown
7. Tap Navigate button in sheet → SnackBar shows the location name

### Phase 11: Real Distance & UX Polishing

1. **NearbyLocationsNotifier**: Implement Haversine distance calculation using the `Distance` class from `latlong2`. Calculate distance from user GPS to each POI and update the `distance` label (e.g. "450 m", "2.1 km").
2. **List Sorting**: Automatically sort the `PlacesListSheet` results by proximity to the user.
3. **Overpass Error UI**: Implement a SnackBar or Overlay to notify the user if the map server is busy (429/504 errors) instead of showing an empty map.
4. **Interactive Zoom**: Use the `MapController` to fly to a location when selected from the list.
