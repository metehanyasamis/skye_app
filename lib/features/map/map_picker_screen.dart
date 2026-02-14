import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:skye_app/shared/services/location_service.dart';
import 'package:skye_app/shared/services/user_address_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/widgets/location_permission_dialog.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';

import '../../shared/config/mapbox_config.dart';

/// USA center (approximate geographic center)
const double _usaCenterLat = 39.8283;
const double _usaCenterLng = -98.5795;

/// Result of map picker: formatted address string
typedef MapPickerResult = String;

/// Full-screen map for picking a location.
/// Flow: 1) Saved address → show 2) Location permission → current 3) Else USA center
class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({
    super.key,
    this.savedAddress,
    this.initialLat,
    this.initialLng,
  });

  final String? savedAddress;
  final double? initialLat;
  final double? initialLng;

  static const routeName = '/map-picker';

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  MapboxMap? _mapboxMap;
  bool _isLoadingAddress = false;
  bool _hasAnimated = false;

  // Search autocomplete
  final _searchController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  List<({double lat, double lng, Placemark placemark})> _suggestions = [];
  bool _showSuggestions = false;
  Timer? _debounce;
  Timer? _idleDebounce;
  bool _isUpdatingFromMap = false;
  final _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    DebugLogger.log('MapPickerScreen', 'initState()');
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_isUpdatingFromMap) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _fetchSuggestions);
  }

  Future<void> _fetchSuggestions() async {
    final q = _searchController.text.trim();
    if (q.length < 3) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }
    try {
      final locations = await locationFromAddress(q);
      if (!mounted || locations.isEmpty) {
        if (mounted) setState(() => _suggestions = []);
        return;
      }
      final results = <({double lat, double lng, Placemark placemark})>[];
      for (var i = 0; i < locations.length && i < 5; i++) {
        final loc = locations[i];
        final placemarks = await placemarkFromCoordinates(loc.latitude, loc.longitude);
        if (placemarks.isNotEmpty) {
          results.add((lat: loc.latitude, lng: loc.longitude, placemark: placemarks.first));
        }
      }
      if (mounted) {
        setState(() {
          _suggestions = results;
          _showSuggestions = true;
        });
      }
    } catch (e) {
      DebugLogger.log('MapPickerScreen', 'fetchSuggestions error', {'error': e.toString()});
      if (mounted) setState(() => _suggestions = []);
    }
  }

  Future<void> _initCenter() async {
    double lat = _usaCenterLat;
    double lng = _usaCenterLng;
    if (widget.initialLat != null && widget.initialLng != null) {
      lat = widget.initialLat!;
      lng = widget.initialLng!;
      _reverseGeocode(lat, lng);
    } else if (widget.savedAddress != null && widget.savedAddress!.trim().isNotEmpty) {
      try {
        final locations = await locationFromAddress(widget.savedAddress!);
        if (locations.isNotEmpty) {
          lat = locations.first.latitude;
          lng = locations.first.longitude;
          _reverseGeocode(lat, lng);
        }
      } catch (_) {}
    } else {
      final hasPerm = await LocationService.instance.hasPermission();
      if (hasPerm) {
        final pos = await LocationService.instance.getCurrentPosition();
        if (pos != null) {
          lat = pos.latitude;
          lng = pos.longitude;
          _reverseGeocode(lat, lng);
        }
      }
    }
    _flyTo(lat, lng);
    if (!_hasAnimated && mounted) {
      setState(() => _hasAnimated = true);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _idleDebounce?.cancel();
    _searchFocusNode.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _mapboxMap?.dispose();
    DebugLogger.log('MapPickerScreen', 'dispose()');
    super.dispose();
  }

  Future<void> _reverseGeocode(double lat, double lng) async {
    if (_searchFocusNode.hasFocus) return;
    setState(() => _isLoadingAddress = true);
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (mounted && placemarks.isNotEmpty && !_searchFocusNode.hasFocus) {
        _isUpdatingFromMap = true;
        final p = placemarks.first;
        _streetController.text = p.street ?? '';
        _cityController.text = p.locality ?? '';
        _stateController.text = p.administrativeArea ?? '';
        _zipController.text = p.postalCode ?? '';
        _searchController.text = _formatAddress(p);
        _isUpdatingFromMap = false;
      }
    } catch (e) {
      DebugLogger.log('MapPickerScreen', 'reverseGeocode error', {'error': e.toString()});
    }
    if (mounted) setState(() => _isLoadingAddress = false);
  }

  String _formatAddress(Placemark p) {
    final parts = <String>[
      if (p.street != null && p.street!.isNotEmpty) p.street!,
      if (p.locality != null && p.locality!.isNotEmpty) p.locality!,
      if (p.administrativeArea != null && p.administrativeArea!.isNotEmpty) p.administrativeArea!,
      if (p.postalCode != null && p.postalCode!.isNotEmpty) p.postalCode!,
    ];
    return parts.join(', ');
  }

  void _fillFromPlacemark(Placemark p, double lat, double lng) {
    _isUpdatingFromMap = true;
    _streetController.text = p.street ?? '';
    _cityController.text = p.locality ?? '';
    _stateController.text = p.administrativeArea ?? '';
    _zipController.text = p.postalCode ?? '';
    _searchController.text = _formatAddress(p);
    _isUpdatingFromMap = false;
    setState(() => _showSuggestions = false);
    _flyTo(lat, lng);
  }

  Future<void> _flyTo(double lat, double lng) async {
    final point = Point(coordinates: Position(lng, lat));
    if (_mapboxMap != null) {
      await _mapboxMap!.flyTo(
        CameraOptions(center: point, zoom: 14.0),
        MapAnimationOptions(duration: 600, startDelay: 0),
      );
    }
  }

  Future<void> _zoomIn() async {
    if (_mapboxMap == null) return;
    try {
      final state = await _mapboxMap!.getCameraState();
      final center = state.center;
      final zoom = state.zoom;
      if (center != null) {
        final coords = center.coordinates;
        final lat = coords.lat.toDouble();
        final lng = coords.lng.toDouble();
        final newZoom = (zoom + 1).clamp(1.0, 20.0);
        await _mapboxMap!.flyTo(
          CameraOptions(
            center: Point(coordinates: Position(lng, lat)),
            zoom: newZoom,
          ),
          MapAnimationOptions(duration: 200, startDelay: 0),
        );
        debugPrint('🔍 [MapPickerScreen] zoomIn: $zoom -> $newZoom');
      }
    } catch (e) {
      debugPrint('❌ [MapPickerScreen] zoomIn error: $e');
    }
  }

  Future<void> _zoomOut() async {
    if (_mapboxMap == null) return;
    try {
      final state = await _mapboxMap!.getCameraState();
      final center = state.center;
      final zoom = state.zoom;
      if (center != null) {
        final coords = center.coordinates;
        final lat = coords.lat.toDouble();
        final lng = coords.lng.toDouble();
        final newZoom = (zoom - 1).clamp(1.0, 20.0);
        await _mapboxMap!.flyTo(
          CameraOptions(
            center: Point(coordinates: Position(lng, lat)),
            zoom: newZoom,
          ),
          MapAnimationOptions(duration: 200, startDelay: 0),
        );
        debugPrint('🔍 [MapPickerScreen] zoomOut: $zoom -> $newZoom');
      }
    } catch (e) {
      debugPrint('❌ [MapPickerScreen] zoomOut error: $e');
    }
  }

  Future<void> _onMapIdle() async {
    _idleDebounce?.cancel();
    _idleDebounce = Timer(const Duration(milliseconds: 300), () async {
      if (_mapboxMap == null || !mounted) return;
      try {
        final state = await _mapboxMap!.getCameraState();
        final center = state.center;
        if (center != null) {
          final coords = center.coordinates;
          final lat = coords.lat.toDouble();
          final lng = coords.lng.toDouble();
          await _reverseGeocode(lat, lng);
        }
      } catch (_) {}
    });
  }

  void _onMapTap(MapContentGestureContext context) {
    final point = context.point;
    final coords = point.coordinates;
    final lat = coords.lat.toDouble();
    final lng = coords.lng.toDouble();
    DebugLogger.log('MapPickerScreen', 'onMapTap', {'lat': lat, 'lng': lng});
    _reverseGeocode(lat, lng);
  }

  Future<void> _onMyLocationTap() async {
    DebugLogger.log('MapPickerScreen', 'My Location tapped');
    final hasPerm = await LocationService.instance.hasPermission();
    if (!hasPerm) {
      final granted = await LocationService.instance.ensurePermission();
      if (!granted && mounted) {
        LocationPermissionDialog.show(
          context,
          onGoToSettings: () async {
            Navigator.of(context).pop();
            await LocationService.instance.openAppSettings();
          },
          onNoThanks: () => Navigator.of(context).pop(),
        );
      }
    }
    final pos = await LocationService.instance.getCurrentPosition();
    if (pos != null && mounted) {
      _flyTo(pos.latitude, pos.longitude);
      _reverseGeocode(pos.latitude, pos.longitude);
    }
  }

  void _onConfirm() {
    final street = _streetController.text.trim();
    final city = _cityController.text.trim();
    final state = _stateController.text.trim();
    final zip = _zipController.text.trim();
    final parts = [street, city, state, zip].where((s) => s.isNotEmpty);
    final address = parts.join(', ');
    DebugLogger.log('MapPickerScreen', 'onConfirm', {'address': address});
    if (address.isNotEmpty) {
      UserAddressService.instance.setStructuredAddress(
        street: street,
        city: city,
        state: state,
        zip: zip,
      );
    }
    Navigator.of(context).pop(address.isNotEmpty ? address : null);
  }

  String get _formattedAddress {
    final parts = [
      _streetController.text.trim(),
      _cityController.text.trim(),
      _stateController.text.trim(),
      _zipController.text.trim(),
    ].where((s) => s.isNotEmpty);
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('MapPickerScreen', 'build()');
    final token = MapboxConfig.accessToken;
    if (token.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Select Location'),
          centerTitle: true,
          backgroundColor: AppColors.navy800,
          foregroundColor: AppColors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 64, color: AppColors.grayPrimary),
                const SizedBox(height: 16),
                Text(
                  'Mapbox token is not configured.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: AppColors.grayPrimary),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final initialCenter = Point(
      coordinates: Position(
        widget.initialLng ?? _usaCenterLng,
        widget.initialLat ?? _usaCenterLat,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      appBar: AppBar(
        title: const Text('Select Location'),
        centerTitle: true,
        backgroundColor: AppColors.navy800,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _onMyLocationTap,
            tooltip: 'My Location',
          ),
        ],
      ),
      body: AnimatedOpacity(
        opacity: _hasAnimated ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: Column(
          children: [
            // Top card: Search + Street, City, State, ZIP
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.labelBlack.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Search location
                  TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Search location',
                      hintStyle: const TextStyle(fontSize: 14, color: AppColors.grayDark),
                      prefixIcon: const Icon(Icons.search, color: AppColors.grayPrimary, size: 20),
                      filled: true,
                      fillColor: AppColors.placeholderBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    style: const TextStyle(fontSize: 14, color: AppColors.labelBlack),
                    onTap: () => setState(() => _showSuggestions = _suggestions.isNotEmpty),
                  ),
                  if (_showSuggestions && _suggestions.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ..._suggestions.map((s) => ListTile(
                      dense: true,
                      title: Text(
                        _formatAddress(s.placemark),
                        style: const TextStyle(fontSize: 13, color: AppColors.labelBlack),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => _fillFromPlacemark(s.placemark, s.lat, s.lng),
                    )),
                  ],
                  const SizedBox(height: 12),
                  // Street
                  _buildField(_streetController, 'Street', Icons.signpost),
                  const SizedBox(height: 8),
                  // City - State
                  Row(
                    children: [
                      Expanded(
                        child: _buildField(_cityController, 'City', Icons.location_city),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('–', style: TextStyle(color: AppColors.grayPrimary, fontSize: 16)),
                      ),
                      Expanded(
                        child: _buildField(_stateController, 'State', Icons.map),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // ZIP
                  _buildField(_zipController, 'ZIP', Icons.pin_drop),
                ],
              ),
            ),
            // Map
            Expanded(
              child: Stack(
                children: [
                  MapWidget(
                    key: const ValueKey('mapPicker'),
                    cameraOptions: CameraOptions(
                      center: initialCenter,
                      zoom: 4.0,
                    ),
                    onMapCreated: (mapboxMap) async {
                      _mapboxMap = mapboxMap;
                      DebugLogger.log('MapPickerScreen', 'onMapCreated');
                      try {
                        await mapboxMap.logo.updateSettings(LogoSettings(enabled: false));
                        await mapboxMap.attribution.updateSettings(AttributionSettings(enabled: false));
                        await mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
                      } catch (_) {}
                      _initCenter();
                    },
                    onMapIdleListener: (_) => _onMapIdle(),
                    onTapListener: _onMapTap,
                  ),
                  // Zoom in/out buttons (right side)
                  Positioned(
                    right: 16,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ZoomButton(
                            icon: Icons.add,
                            onPressed: () async {
                              DebugLogger.log('MapPickerScreen', 'zoom in');
                              await _zoomIn();
                            },
                          ),
                          const SizedBox(height: 8),
                          _ZoomButton(
                            icon: Icons.remove,
                            onPressed: () async {
                              DebugLogger.log('MapPickerScreen', 'zoom out');
                              await _zoomOut();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Center marker
                  Center(
                    child: IgnorePointer(
                      child: Icon(
                        Icons.place,
                        size: 48,
                        color: AppColors.navy800.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                  if (_isLoadingAddress)
                    const Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                SizedBox(width: 12),
                                Text('Getting address...', style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Bottom: hint + confirm
            Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.white,
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Tap on the map to select a location',
                      style: TextStyle(fontSize: 12, color: AppColors.grayPrimary),
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      label: 'Confirm Address',
                      onPressed: _formattedAddress.isNotEmpty ? _onConfirm : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12, color: AppColors.grayPrimary),
        prefixIcon: Icon(icon, size: 18, color: AppColors.grayPrimary),
        filled: true,
        fillColor: AppColors.placeholderBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      style: const TextStyle(fontSize: 13, color: AppColors.labelBlack),
      onChanged: (_) => setState(() {}),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  const _ZoomButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 2,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Icon(icon, size: 22, color: AppColors.navy800),
        ),
      ),
    );
  }
}
