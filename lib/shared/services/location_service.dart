import 'package:geolocator/geolocator.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';

class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  /// Check if location permission is granted.
  Future<bool> hasPermission() async {
    try {
      final status = await Geolocator.checkPermission();
      DebugLogger.log('LocationService', 'checkPermission', {'status': status.name});
      return status == LocationPermission.whileInUse ||
          status == LocationPermission.always;
    } catch (e) {
      DebugLogger.log('LocationService', 'checkPermission error', {'error': e.toString()});
      return false;
    }
  }

  /// Request location permission. Returns true if granted.
  Future<bool> requestPermission() async {
    try {
      final status = await Geolocator.requestPermission();
      DebugLogger.log('LocationService', 'requestPermission', {'status': status.name});
      return status == LocationPermission.whileInUse ||
          status == LocationPermission.always;
    } catch (e) {
      DebugLogger.log('LocationService', 'requestPermission error', {'error': e.toString()});
      return false;
    }
  }

  /// Check and request permission if needed. Returns true if we have permission.
  Future<bool> ensurePermission() async {
    bool has = await hasPermission();
    if (has) return true;
    return await requestPermission();
  }

  /// Get current position. Returns null if permission denied or error.
  Future<Position?> getCurrentPosition() async {
    try {
      final has = await ensurePermission();
      if (!has) {
        DebugLogger.log('LocationService', 'getCurrentPosition', {'reason': 'no permission'});
        return null;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      DebugLogger.log('LocationService', 'getCurrentPosition', {'lat': pos.latitude, 'lng': pos.longitude});
      return pos;
    } catch (e) {
      DebugLogger.log('LocationService', 'getCurrentPosition error', {'error': e.toString()});
      return null;
    }
  }

  /// Open app location settings.
  Future<bool> openAppSettings() async {
    try {
      return await Geolocator.openAppSettings();
    } catch (e) {
      DebugLogger.log('LocationService', 'openAppSettings error', {'error': e.toString()});
      return false;
    }
  }
}
