import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skye_app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('[main] ensureInitialized ✅');

  // FULL EDGE-TO-EDGE
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  debugPrint('[main] edgeToEdge ✅');

  // IMPORTANT: disable enforced contrast + transparent bars
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,

      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,

      statusBarBrightness: Brightness.dark,

      // ANDROID 12+ "dark overlay" issue killer:
      systemNavigationBarContrastEnforced: false,
      systemStatusBarContrastEnforced: false,
    ),
  );
  debugPrint('[main] overlay style ✅');

  runApp(const SkyeApp());
  debugPrint('[main] runApp ✅');
}
