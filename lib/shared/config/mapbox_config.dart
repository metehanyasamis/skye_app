import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapboxConfig {
  static String get accessToken =>
      dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';
}


/*
/// Mapbox access token for map display.
/// Priority: 1) --dart-define=ACCESS_TOKEN=xxx  2) AndroidManifest/Info.plist
/// Run with: flutter run --dart-define ACCESS_TOKEN=pk.your_token_here
/// Or add token to AndroidManifest (com.mapbox.token) and Info.plist (MBXAccessToken).
const String mapboxAccessToken = String.fromEnvironment(
  'ACCESS_TOKEN',
  defaultValue: '',
);

/// Token read from native (Android manifest / iOS Info.plist). Set by [resolveMapboxToken].
String? _resolvedNativeToken;

/// Effective token: dart-define first, else native manifest/plist.
String get effectiveMapboxToken =>
    mapboxAccessToken.isNotEmpty ? mapboxAccessToken : (_resolvedNativeToken ?? '');

const _channel = MethodChannel('com.skye.app/mapbox_config');

/// Resolve token from native when dart-define is not provided. Call in main() before runApp.
Future<void> resolveMapboxToken() async {
  if (mapboxAccessToken.isNotEmpty) return;
  try {
    final String? token = await _channel.invokeMethod<String>('getMapboxAccessToken');
    if (token != null && token.trim().isNotEmpty) {
      _resolvedNativeToken = token.trim();
    }
  } on PlatformException catch (_) {
    // Channel not available or method failed
  } catch (_) {}
}

 */
