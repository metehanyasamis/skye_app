import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Base API service for Skye backend
/// Base URL: https://skye.dijicrea.net/api
class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();

  static const String baseUrl = 'https://skye.dijicrea.net/api';
  static const String _keyAuthToken = 'skye_auth_token';
  
  late final Dio _dio;

  /// Initialize Dio client with base configuration
  void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors for logging in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );
    }

    // Add error interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          debugPrint('❌ [ApiService] Error: ${error.message}');
          debugPrint('   Response: ${error.response?.data}');
          debugPrint('   Status: ${error.response?.statusCode}');
          return handler.next(error);
        },
      ),
    );
  }
// Get Dio instance
  Dio get dio => _dio;

  /// Set authorization token
  Future<void> setAuthToken(String? token) async {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      // Save token to SharedPreferences for persistence
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_keyAuthToken, token);
        debugPrint('🔑 [ApiService] Token saved to SharedPreferences');
      } catch (e, st) {
        debugPrint('⚠️ [ApiService] Failed to save token: $e\n$st');
      }
    } else {
      _dio.options.headers.remove('Authorization');
      // Clear token from SharedPreferences
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_keyAuthToken);
        debugPrint('🔑 [ApiService] Token removed from SharedPreferences');
      } catch (e, st) {
        debugPrint('⚠️ [ApiService] Failed to remove token: $e\n$st');
      }
    }
  }

  /// Clear authorization token
  Future<void> clearAuthToken() async {
    _dio.options.headers.remove('Authorization');
    // Clear token from SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyAuthToken);
      debugPrint('🔑 [ApiService] Token cleared from SharedPreferences');
    } catch (e, st) {
      debugPrint('⚠️ [ApiService] Failed to clear token: $e\n$st');
    }
  }

  /// Restore authorization token from SharedPreferences
  Future<void> restoreAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_keyAuthToken);
      if (token != null && token.isNotEmpty) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
        debugPrint('🔑 [ApiService] Token restored from SharedPreferences (length: ${token.length})');
      } else {
        debugPrint('ℹ️ [ApiService] No token in SharedPreferences – login required for Profile/Edit');
      }
    } catch (e, st) {
      debugPrint('⚠️ [ApiService] Failed to restore token: $e\n$st');
    }
  }

  /// Get current auth token (for image headers)
  String? getAuthToken() {
    final authHeader = _dio.options.headers['Authorization'] as String?;
    if (authHeader != null && authHeader.startsWith('Bearer ')) {
      return authHeader;
    }
    return null;
  }
}
