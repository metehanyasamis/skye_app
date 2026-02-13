import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:skye_app/shared/services/api_service.dart';

/// API responses
class LoginResponse {
  final String? token;
  final Map<String, dynamic>? user;
  final String? message;

  LoginResponse({
    this.token,
    this.user,
    this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // API response format: { "message": "...", "data": { "user": {...}, "token": "..." } }
    debugPrint('🔍 [LoginResponse] Parsing JSON...');
    debugPrint('🔍 [LoginResponse] JSON keys: ${json.keys.toList()}');
    
    final data = json['data'] as Map<String, dynamic>?;
    debugPrint('🔍 [LoginResponse] Data: $data');
    
    if (data != null) {
      debugPrint('🔍 [LoginResponse] Data keys: ${data.keys.toList()}');
      final token = data['token'] as String?;
      debugPrint('🔍 [LoginResponse] Token from data: ${token != null ? "YES (${token.length} chars)" : "NO"}');
    } else {
      debugPrint('⚠️ [LoginResponse] No "data" key found in JSON!');
      // Try alternative structure: maybe token is directly in json?
      if (json.containsKey('token')) {
        debugPrint('🔍 [LoginResponse] Found token directly in JSON root!');
      }
    }
    
    return LoginResponse(
      token: data?['token'] as String?,
      user: data?['user'] as Map<String, dynamic>?,
      message: json['message'] as String?,
    );
  }
}

class VerificationResponse {
  final bool success;
  final String? message;
  final String? token;
  final Map<String, dynamic>? data;

  VerificationResponse({
    required this.success,
    this.message,
    this.token,
    this.data,
  });

  factory VerificationResponse.fromJson(Map<String, dynamic> json) {
    // API response format: { "message": "..." } or { "message": "...", "data": {...} }
    final message = json['message'] as String? ?? '';
    final data = json['data'] as Map<String, dynamic>?;
    
    // Success is determined by message content or status code (200 = success)
    final isSuccess = message.toLowerCase().contains('success') ||
                     message.toLowerCase().contains('valid') ||
                     message.toLowerCase().contains('sent');
    
    return VerificationResponse(
      success: isSuccess,
      message: message,
      token: data?['token'] as String?,
      data: data,
    );
  }
}

class ApiError {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiError({
    required this.message,
    this.statusCode,
    this.data,
  });

  factory ApiError.fromDioError(DioException error) {
    String message = 'An error occurred';
    int? statusCode;

    if (error.response != null) {
      statusCode = error.response?.statusCode;
      final data = error.response?.data;
      
      if (data is Map<String, dynamic>) {
        // Check for validation errors (422 status)
        if (statusCode == 422 && data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>?;
          if (errors != null && errors.isNotEmpty) {
            // Get first error message from first field
            final firstField = errors.keys.first;
            final fieldErrors = errors[firstField];
            if (fieldErrors is List && fieldErrors.isNotEmpty) {
              message = fieldErrors.first as String;
            } else if (fieldErrors is String) {
              message = fieldErrors;
            } else {
              message = data['message'] as String? ?? 'Validation failed.';
            }
          } else {
            message = data['message'] as String? ?? 'Validation failed.';
          }
        } else {
          // Regular error message
          message = data['message'] as String? ?? 
                   data['error'] as String? ?? 
                   'An error occurred';
        }
      } else if (data is String) {
        message = data;
      } else {
        message = error.response?.statusMessage ?? 'An error occurred';
      }
    } else if (error.type == DioExceptionType.connectionTimeout ||
               error.type == DioExceptionType.receiveTimeout) {
      message = 'Connection timeout. Please try again.';
    } else if (error.type == DioExceptionType.connectionError) {
      message = 'No internet connection. Please check your network.';
    } else {
      message = error.message ?? 'An error occurred';
    }

    return ApiError(
      message: message,
      statusCode: statusCode,
      data: error.response?.data,
    );
  }
}

/// Authentication API service
/// Handles login, signup, verification, etc.
class AuthApiService {
  AuthApiService._();

  static final AuthApiService instance = AuthApiService._();

  /// Send verification code to phone number
  /// 
  /// Endpoint: POST /api/auth/send-code
  /// Body: { "phone": "+15464208735" }
  /// Response: { "message": "Verification code sent successfully." }
  Future<VerificationResponse> sendOtp({
    required String phone,
  }) async {
    try {
      debugPrint('📱 [AuthApiService] sendOtp: $phone');
      
      final response = await ApiService.instance.dio.post(
        '/auth/send-code',
        data: {
          'phone': phone,
        },
      );

      debugPrint('✅ [AuthApiService] sendOtp success: ${response.data}');
      
      // Log OTP code if present in response (for development/testing on emulator)
      final responseData = response.data as Map<String, dynamic>?;
      if (responseData != null) {
        debugPrint('📋 [AuthApiService] Full response: $responseData');
        
        // Check if OTP code is in response (some backends return it for testing)
        if (responseData.containsKey('code') || responseData.containsKey('otp') || responseData.containsKey('verification_code')) {
          final otpCode = responseData['code'] ?? responseData['otp'] ?? responseData['verification_code'];
          debugPrint('🔑 [AuthApiService] ════════════════════════════════════');
          debugPrint('🔑 [AuthApiService] OTP CODE: $otpCode');
          debugPrint('🔑 [AuthApiService] ════════════════════════════════════');
        }
        // Check in data object
        if (responseData.containsKey('data')) {
          final data = responseData['data'] as Map<String, dynamic>?;
          if (data != null) {
            //debugPrint('📦 [AuthApiService] Response data: $data');
            if (data.containsKey('code') || data.containsKey('otp') || data.containsKey('verification_code')) {
              final otpCode = data['code'] ?? data['otp'] ?? data['verification_code'];
              debugPrint('🔑 [AuthApiService] ════════════════════════════════════');
              debugPrint('🔑 [AuthApiService] OTP CODE: $otpCode');
              debugPrint('🔑 [AuthApiService] ════════════════════════════════════');
            }
          }
        }
        
        // If no OTP in response, show message
        final hasCodeInRoot = responseData.containsKey('code') || 
                              responseData.containsKey('otp') || 
                              responseData.containsKey('verification_code');
        final data = responseData['data'] as Map<String, dynamic>?;
        final hasCodeInData = data != null && 
                              (data.containsKey('code') || 
                               data.containsKey('otp') || 
                               data.containsKey('verification_code'));
        
        if (!hasCodeInRoot && !hasCodeInData) {
          debugPrint('⚠️ [AuthApiService] OTP code not found in response. Check SMS or backend logs.');
          debugPrint('⚠️ [AuthApiService] Backend should send OTP via SMS to: $phone');
        }
      }
      
      return VerificationResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [AuthApiService] sendOtp error: ${e.message}');
      throw ApiError.fromDioError(e);
    } catch (e, st) {
      debugPrint('❌ [AuthApiService] sendOtp unexpected error: $e\n$st');
      throw ApiError(
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Verify phone number with 6-digit verification code
  /// 
  /// Endpoint: POST /api/auth/verify-code
  /// Body: { "phone": "+15464208735", "verification_code": "123456" }
  /// Response: { "message": "Verification code is valid." }
  /// Note: This endpoint only verifies the code, it does NOT create a user account.
  /// For sign up, use completeRegistration() after verification.
  Future<VerificationResponse> verifyOtp({
    required String phone,
    required String code,
  }) async {
    try {
      debugPrint('🔐 [AuthApiService] verifyOtp: phone=$phone, code=$code');
      
      final response = await ApiService.instance.dio.post(
        '/auth/verify-code',
        data: {
          'phone': phone,
          'verification_code': code, // API expects 'verification_code' not 'code'
        },
      );

      debugPrint('✅ [AuthApiService] verifyOtp success: ${response.data}');
      
      // If status code is 200, verification is successful
      // Response format: { "message": "Verification code is valid." }
      final result = VerificationResponse(
        success: true, // 200 status code means success
        message: (response.data as Map<String, dynamic>?)?['message'] as String?,
        token: null, // verify-code doesn't return token
        data: response.data as Map<String, dynamic>?,
      );
      
      return result;
    } on DioException catch (e) {
      debugPrint('❌ [AuthApiService] verifyOtp error: ${e.message}');
      throw ApiError.fromDioError(e);
    } catch (e, st) {
      debugPrint('❌ [AuthApiService] verifyOtp unexpected error: $e\n$st');
      throw ApiError(
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Login with phone and password
  /// 
  /// Endpoint: POST /api/auth/login
  /// Body: { "phone": "+15555555555", "password": "pass1234" }
  /// Response: { "message": "Login successful.", "data": { "user": {...}, "token": "..." } }
  Future<LoginResponse> login({
    required String phone,
    required String password,
  }) async {
    try {
      debugPrint('🔐 [AuthApiService] login: phone=$phone');
      
      final response = await ApiService.instance.dio.post(
        '/auth/login',
        data: {
          'phone': phone,
          'password': password,
        },
      );

      debugPrint('✅ [AuthApiService] login success');
      debugPrint('📦 [AuthApiService] Full response data: ${response.data}');
      debugPrint('📦 [AuthApiService] Response type: ${response.data.runtimeType}');
      
      // Check response structure
      if (response.data is Map<String, dynamic>) {
        final responseMap = response.data as Map<String, dynamic>;
        debugPrint('📋 [AuthApiService] Response keys: ${responseMap.keys.toList()}');
        
        if (responseMap.containsKey('data')) {
          final data = responseMap['data'];
          debugPrint('📋 [AuthApiService] Data type: ${data.runtimeType}');
          if (data is Map<String, dynamic>) {
            debugPrint('📋 [AuthApiService] Data keys: ${(data as Map<String, dynamic>).keys.toList()}');
            if ((data as Map<String, dynamic>).containsKey('token')) {
              final tokenValue = (data as Map<String, dynamic>)['token'];
              debugPrint('🔑 [AuthApiService] Token found in data: ${tokenValue != null ? "YES (length: ${tokenValue.toString().length})" : "NO"}');
            } else {
              debugPrint('⚠️ [AuthApiService] No "token" key in data!');
            }
          }
        } else {
          debugPrint('⚠️ [AuthApiService] No "data" key in response!');
        }
      }
      
      final result = LoginResponse.fromJson(response.data as Map<String, dynamic>);
      
      debugPrint('🔑 [AuthApiService] Parsed token: ${result.token != null ? "YES (length: ${result.token!.length})" : "NO"}');
      debugPrint('👤 [AuthApiService] Parsed user: ${result.user != null ? "YES" : "NO"}');
      debugPrint('💬 [AuthApiService] Parsed message: ${result.message ?? "NO"}');
      
      // Set auth token if provided
      if (result.token != null) {
        debugPrint('🔑 [AuthApiService] Saving token to ApiService...');
        await ApiService.instance.setAuthToken(result.token);
        debugPrint('🔑 [AuthApiService] Token saved successfully');
      } else {
        debugPrint('⚠️ [AuthApiService] No token in login response!');
        debugPrint('⚠️ [AuthApiService] This means images will fail with 403!');
      }
      
      return result;
    } on DioException catch (e) {
      debugPrint('❌ [AuthApiService] login error: ${e.message}');
      throw ApiError.fromDioError(e);
    } catch (e, st) {
      debugPrint('❌ [AuthApiService] login unexpected error: $e\n$st');
      throw ApiError(
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Register new user (sends verification code)
  /// 
  /// Endpoint: POST /api/auth/register
  /// Body: { "name": "...", "email": "...", "password": "...", "password_confirmation": "...", 
  ///         "phone": "...", "gender": "...", "how_plan_to_use_skye": "...", 
  ///         "aviation_position_definition": "...", "how_skye_can_help": "..." }
  /// Response: { "message": "A verification code has been sent to your phone." }
  Future<VerificationResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String gender,
    String? howPlanToUseSkye,
    String? aviationPositionDefinition,
    String? howSkyeCanHelp,
  }) async {
    try {
      debugPrint('📝 [AuthApiService] register: phone=$phone, email=$email');
      
      final data = <String, dynamic>{
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'phone': phone,
        'gender': gender,
        if (howPlanToUseSkye != null) 'how_plan_to_use_skye': howPlanToUseSkye,
        if (aviationPositionDefinition != null) 'aviation_position_definition': aviationPositionDefinition,
        if (howSkyeCanHelp != null) 'how_skye_can_help': howSkyeCanHelp,
      };
      
      final response = await ApiService.instance.dio.post(
        '/auth/register',
        data: data,
      );

      debugPrint('✅ [AuthApiService] register success: ${response.data}');
      
      return VerificationResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [AuthApiService] register error: ${e.message}');
      throw ApiError.fromDioError(e);
    } catch (e, st) {
      debugPrint('❌ [AuthApiService] register unexpected error: $e\n$st');
      throw ApiError(
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Complete registration after phone verification
  /// 
  /// Endpoint: POST /api/auth/complete-registration
  /// Body: { "phone": "...", "verification_code": "...", "name": "...", "email": "...", 
  ///         "password": "...", "password_confirmation": "...", "gender": "...", 
  ///         "how_plan_to_use_skye": "...", "aviation_position_definition": "...", 
  ///         "how_skye_can_help": "..." }
  /// Response: { "message": "Registration completed successfully.", "data": { "user": {...}, "token": "..." } }
  Future<LoginResponse> completeRegistration({
    required String phone,
    required String verificationCode,
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String gender,
    String? dateOfBirth,
    String? howPlanToUseSkye,
    String? aviationPositionDefinition,
    String? howSkyeCanHelp,
  }) async {
    try {
      debugPrint('📝 [AuthApiService] completeRegistration: phone=$phone');
      
      final data = <String, dynamic>{
        'phone': phone,
        'verification_code': verificationCode,
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'gender': gender,
        if (dateOfBirth != null && dateOfBirth.isNotEmpty) 'date_of_birth': dateOfBirth,
        if (howPlanToUseSkye != null) 'how_plan_to_use_skye': howPlanToUseSkye,
        if (aviationPositionDefinition != null) 'aviation_position_definition': aviationPositionDefinition,
        if (howSkyeCanHelp != null) 'how_skye_can_help': howSkyeCanHelp,
      };
      
      final response = await ApiService.instance.dio.post(
        '/auth/complete-registration',
        data: data,
      );

      debugPrint('✅ [AuthApiService] completeRegistration success');
      debugPrint('📦 [AuthApiService] Full response data: ${response.data}');
      debugPrint('📦 [AuthApiService] Response type: ${response.data.runtimeType}');
      
      // Check response structure
      if (response.data is Map<String, dynamic>) {
        final responseMap = response.data as Map<String, dynamic>;
        debugPrint('📋 [AuthApiService] Response keys: ${responseMap.keys.toList()}');
        
        if (responseMap.containsKey('data')) {
          final data = responseMap['data'];
          debugPrint('📋 [AuthApiService] Data type: ${data.runtimeType}');
          if (data is Map<String, dynamic>) {
            debugPrint('📋 [AuthApiService] Data keys: ${(data as Map<String, dynamic>).keys.toList()}');
            if ((data as Map<String, dynamic>).containsKey('token')) {
              final tokenValue = (data as Map<String, dynamic>)['token'];
              debugPrint('🔑 [AuthApiService] Token found in data: ${tokenValue != null ? "YES (length: ${tokenValue.toString().length})" : "NO"}');
            } else {
              debugPrint('⚠️ [AuthApiService] No "token" key in data!');
            }
          }
        } else {
          debugPrint('⚠️ [AuthApiService] No "data" key in response!');
        }
      }
      
      final result = LoginResponse.fromJson(response.data as Map<String, dynamic>);
      
      debugPrint('🔑 [AuthApiService] Parsed token: ${result.token != null ? "YES (length: ${result.token!.length})" : "NO"}');
      debugPrint('👤 [AuthApiService] Parsed user: ${result.user != null ? "YES" : "NO"}');
      debugPrint('💬 [AuthApiService] Parsed message: ${result.message ?? "NO"}');
      
      // Set auth token if provided
      if (result.token != null) {
        debugPrint('🔑 [AuthApiService] Saving token to ApiService...');
        await ApiService.instance.setAuthToken(result.token);
        debugPrint('🔑 [AuthApiService] Token saved successfully');
      } else {
        debugPrint('⚠️ [AuthApiService] No token in registration response!');
        debugPrint('⚠️ [AuthApiService] This means images will fail with 403!');
      }
      
      return result;
    } on DioException catch (e) {
      debugPrint('❌ [AuthApiService] completeRegistration error: ${e.message}');
      throw ApiError.fromDioError(e);
    } catch (e, st) {
      debugPrint('❌ [AuthApiService] completeRegistration unexpected error: $e\n$st');
      throw ApiError(
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Logout the current user
  /// 
  /// Endpoint: POST /api/auth/logout
  /// Response: { "message": "Logout successful." }
  Future<void> logout() async {
    try {
      debugPrint('🚪 [AuthApiService] logout');
      
      await ApiService.instance.dio.post('/auth/logout');
      
      // Clear auth token
      await ApiService.instance.clearAuthToken();
      
      debugPrint('✅ [AuthApiService] logout success');
    } on DioException catch (e) {
      debugPrint('❌ [AuthApiService] logout error: ${e.message}');
      // Clear token even if logout fails
      ApiService.instance.clearAuthToken();
      throw ApiError.fromDioError(e);
    } catch (e, st) {
      debugPrint('❌ [AuthApiService] logout unexpected error: $e\n$st');
      ApiService.instance.clearAuthToken();
      throw ApiError(
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Update user profile (name, email, phone, date_of_birth)
  /// Backend: PUT /api/auth/profile 404 -> fallback PUT /api/user, PATCH /api/user
  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      debugPrint('✏️ [AuthApiService] updateProfile');
      final endpoints = ['/auth/profile', '/user'];
      DioException? lastError;
      for (final path in endpoints) {
        try {
          await ApiService.instance.dio.put(path, data: data);
          debugPrint('✅ [AuthApiService] updateProfile success via $path');
          return;
        } on DioException catch (e) {
          if (e.response?.statusCode == 404) {
            debugPrint('⚠️ [AuthApiService] $path not found, trying next');
            lastError = e;
            continue;
          }
          rethrow;
        }
      }
      if (lastError != null) throw lastError!;
    } on DioException catch (e) {
      debugPrint('❌ [AuthApiService] updateProfile error: ${e.message}');
      throw ApiError.fromDioError(e);
    }
  }

  /// Update password
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      debugPrint('🔐 [AuthApiService] updatePassword');
      await ApiService.instance.dio.put('/auth/password', data: {
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': newPasswordConfirmation,
      });
      debugPrint('✅ [AuthApiService] updatePassword success');
    } on DioException catch (e) {
      debugPrint('❌ [AuthApiService] updatePassword error: ${e.message}');
      throw ApiError.fromDioError(e);
    }
  }

  /// Get the authenticated user's profile
  /// 
  /// Endpoint: GET /api/auth/me
  /// Response: { "data": { "id": 1, "name": "...", ... } } or { "data": { "user": {...} } }
  Future<Map<String, dynamic>> getMe() async {
    try {
      debugPrint('👤 [AuthApiService] getMe');
      
      final response = await ApiService.instance.dio.get('/auth/me');
      
      debugPrint('✅ [AuthApiService] getMe success: ${response.data}');
      
      final data = response.data as Map<String, dynamic>?;
      if (data == null) return {};
      Map<String, dynamic>? inner = data['data'] as Map<String, dynamic>? ?? data;
      while (inner != null && inner.containsKey('data')) {
        inner = inner['data'] as Map<String, dynamic>?;
      }
      if (inner == null) return {};
      if (inner.containsKey('user')) {
        final u = inner['user'];
        if (u is Map<String, dynamic>) return u;
      }
      debugPrint('👤 [AuthApiService] getMe user keys: ${inner.keys.toList()}, name=${inner["name"]}, first_name=${inner["first_name"]}');
      return inner;
    } on DioException catch (e) {
      debugPrint('❌ [AuthApiService] getMe error: ${e.message}');
      throw ApiError.fromDioError(e);
    } catch (e, st) {
      debugPrint('❌ [AuthApiService] getMe unexpected error: $e\n$st');
      throw ApiError(
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }
}
