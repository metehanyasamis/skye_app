// lib/utils/system_ui_helper.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Helper for setting system UI overlay style
/// Reduces code duplication across screens
class SystemUIHelper {
  /// Set light status bar (for light backgrounds)
  static void setLightStatusBar() {
    debugPrint('🎛️ [SystemUIHelper] setLightStatusBar()');
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  /// Set dark status bar (for dark backgrounds)
  static void setDarkStatusBar() {
    debugPrint('🎛️ [SystemUIHelper] setDarkStatusBar()');
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  /// Force true edge-to-edge (no system scrim/divider)
  static Future<void> enableEdgeToEdge() async {
    debugPrint('📱 [SystemUIHelper] enableEdgeToEdge()');
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}
