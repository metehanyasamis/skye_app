import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:skye_app/app.dart';
import 'package:skye_app/shared/services/user_address_service.dart';
import 'package:skye_app/shared/services/api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('[main] ensureInitialized ✅');

  await dotenv.load(fileName: ".env");

  final token = dotenv.env['MAPBOX_ACCESS_TOKEN'];

  if (token == null || token.isEmpty) {
    throw Exception("MAPBOX_ACCESS_TOKEN missing in .env");
  }

  MapboxOptions.setAccessToken(token);
  debugPrint('[main] Mapbox token set ✅');

  await UserAddressService.instance.load();
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
