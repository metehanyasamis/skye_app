import 'package:geocoding/geocoding.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';

/// Reverse geocode (lat, lng) to Placemark. Use when structured data (street, city, state) is needed.
Future<Placemark?> reverseGeocodeToPlacemark(double lat, double lng) async {
  try {
    final placemarks = await placemarkFromCoordinates(lat, lng);
    if (placemarks.isEmpty) return null;
    DebugLogger.log('GeocodingHelper', 'reverseGeocodeToPlacemark', {'address': placemarks.first.street});
    return placemarks.first;
  } catch (e) {
    DebugLogger.log('GeocodingHelper', 'reverseGeocodeToPlacemark error', {'error': e.toString()});
    return null;
  }
}

/// Reverse geocode (lat, lng) to address string.
Future<String?> reverseGeocode(double lat, double lng) async {
  try {
    final placemarks = await placemarkFromCoordinates(lat, lng);
    if (placemarks.isEmpty) return null;
    final p = placemarks.first;
    final parts = <String>[
      if (p.street != null && p.street!.isNotEmpty) p.street!,
      if (p.subLocality != null && p.subLocality!.isNotEmpty) p.subLocality!,
      if (p.locality != null && p.locality!.isNotEmpty) p.locality!,
      if (p.administrativeArea != null && p.administrativeArea!.isNotEmpty) p.administrativeArea!,
      if (p.country != null && p.country!.isNotEmpty) p.country!,
    ];
    final address = parts.join(', ');
    DebugLogger.log('GeocodingHelper', 'reverseGeocode', {'address': address});
    return address.isNotEmpty ? address : '$lat, $lng';
  } catch (e) {
    DebugLogger.log('GeocodingHelper', 'reverseGeocode error', {'error': e.toString()});
    return '$lat, $lng';
  }
}
