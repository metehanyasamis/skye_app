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
    final data = json['data'] as Map<String, dynamic>?;
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
            debugPrint('📦 [AuthApiService] Response data: $data');
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

      debugPrint('✅ [AuthApiService] login success: ${response.data}');
      
      final result = LoginResponse.fromJson(response.data as Map<String, dynamic>);
      
      // Set auth token if provided
      if (result.token != null) {
        ApiService.instance.setAuthToken(result.token);
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
        if (howPlanToUseSkye != null) 'how_plan_to_use_skye': howPlanToUseSkye,
        if (aviationPositionDefinition != null) 'aviation_position_definition': aviationPositionDefinition,
        if (howSkyeCanHelp != null) 'how_skye_can_help': howSkyeCanHelp,
      };
      
      final response = await ApiService.instance.dio.post(
        '/auth/complete-registration',
        data: data,
      );

      debugPrint('✅ [AuthApiService] completeRegistration success: ${response.data}');
      
      final result = LoginResponse.fromJson(response.data as Map<String, dynamic>);
      
      // Set auth token if provided
      if (result.token != null) {
        ApiService.instance.setAuthToken(result.token);
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
      ApiService.instance.clearAuthToken();
      
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

  /// Get the authenticated user's profile
  /// 
  /// Endpoint: GET /api/auth/me
  /// Response: { "data": { "id": 1, "name": "...", ... } }
  Future<Map<String, dynamic>> getMe() async {
    try {
      debugPrint('👤 [AuthApiService] getMe');
      
      final response = await ApiService.instance.dio.get('/auth/me');
      
      debugPrint('✅ [AuthApiService] getMe success: ${response.data}');
      
      final data = response.data as Map<String, dynamic>;
      return data['data'] as Map<String, dynamic>? ?? {};
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
