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

  // 🔥 Mapbox token from dart-define
  const token = String.fromEnvironment('MAPBOX_ACCESS_TOKEN');

  if (token.isEmpty) {
    debugPrint('❌ MAPBOX TOKEN NOT PROVIDED');
  } else {
    MapboxOptions.setAccessToken(token);
    debugPrint('[main] Mapbox token set ✅');
  }

  await UserAddressService.instance.load();
  debugPrint('[main] UserAddressService loaded ✅');

  ApiService.instance.init();
  await ApiService.instance.restoreAuthToken();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarContrastEnforced: false,
      systemStatusBarContrastEnforced: false,
    ),
  );

  runApp(const SkyeApp());
}
