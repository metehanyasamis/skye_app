import 'package:flutter/foundation.dart';

/// Centralized debug logging utility
/// Usage: DebugLogger.log('HomeScreen', 'build()');
class DebugLogger {
  static const bool _enabled = kDebugMode;

  static void log(String screen, String message, [Map<String, dynamic>? data]) {
    if (!_enabled) return;
    
    final emoji = _getEmoji(screen);
    final dataStr = data != null ? ' data=$data' : '';
    debugPrint('$emoji [$screen] $message$dataStr');
  }

  static void error(String screen, String message, [Object? error]) {
    if (!_enabled) return;
    debugPrint('❌ [$screen] ERROR: $message${error != null ? ' - $error' : ''}');
  }

  static void success(String screen, String message) {
    if (!_enabled) return;
    debugPrint('✅ [$screen] $message');
  }

  static String _getEmoji(String screen) {
    final lower = screen.toLowerCase();
    if (lower.contains('home')) return '🏠';
    if (lower.contains('aircraft')) return '✈️';
    if (lower.contains('cfi')) return '🧑‍✈️';
    if (lower.contains('profile')) return '👤';
    if (lower.contains('login')) return '🔐';
    if (lower.contains('notification')) return '🔔';
    if (lower.contains('welcome')) return '👋';
    if (lower.contains('safety')) return '🛡️';
    if (lower.contains('time')) return '⏰';
    return '📱';
  }
}
