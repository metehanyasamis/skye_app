import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:skye_app/app.dart';
import 'package:skye_app/shared/config/mapbox_config.dart' as mapbox_cfg;
import 'package:skye_app/shared/services/user_address_service.dart';
import 'package:skye_app/shared/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('[main] ensureInitialized ✅');

  await mapbox_cfg.resolveMapboxToken();
  final token = mapbox_cfg.effectiveMapboxToken;
  if (token.isNotEmpty) {
    MapboxOptions.setAccessToken(token);
    debugPrint('[main] Mapbox token set ✅');
  }

  await UserAddressService.instance.load();
  debugPrint('[main] UserAddressService loaded ✅');

  // Initialize API service
  ApiService.instance.init();
  debugPrint('[main] ApiService initialized ✅');
  
  // Restore auth token from SharedPreferences
  await ApiService.instance.restoreAuthToken();
  debugPrint('[main] Auth token restored ✅');

  // FULL EDGE-TO-EDGE
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  debugPrint('[main] edgeToEdge ✅');

  // IMPORTANT: disable enforced contrast + transparent bars
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,

      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,

      statusBarBrightness: Brightness.light,

      // ANDROID 12+ "dark overlay" issue killer:
      systemNavigationBarContrastEnforced: false,
      systemStatusBarContrastEnforced: false,
    ),
  );
  debugPrint('[main] overlay style ✅');

  runApp(const SkyeApp());
  debugPrint('[main] runApp ✅');
}
