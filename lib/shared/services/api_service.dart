import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Base API service for Skye backend
/// Base URL: https://skye.dijicrea.net/api
class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();

  static const String baseUrl = 'https://skye.dijicrea.net/api';
  
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

  /// Get Dio instance
  Dio get dio => _dio;

  /// Set authorization token
  void setAuthToken(String? token) {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  /// Clear authorization token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}
