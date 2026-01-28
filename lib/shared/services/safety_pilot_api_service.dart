import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:skye_app/shared/services/api_service.dart';

/// Safety Pilot application API.
/// Backend endpoints (e.g. POST /safety-pilot/applications) to be added when ready.
class SafetyPilotApiService {
  SafetyPilotApiService._();

  static final SafetyPilotApiService instance = SafetyPilotApiService._();

  /// Submit safety pilot application.
  /// Endpoint: POST /safety-pilot/applications (or similar – not yet implemented).
  Future<Map<String, dynamic>> submitApplication(Map<String, dynamic> data) async {
    try {
      debugPrint('🧑‍✈️ [SafetyPilotApiService] submitApplication');
      debugPrint('📦 [SafetyPilotApiService] Data: $data');

      final response = await ApiService.instance.dio.post(
        '/safety-pilot/applications',
        data: data,
      );

      debugPrint('✅ [SafetyPilotApiService] submitApplication success');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      debugPrint('❌ [SafetyPilotApiService] submitApplication error: ${e.message}');
      if (e.response != null) {
        debugPrint('❌ [SafetyPilotApiService] Response: ${e.response?.data}');
      }
      rethrow;
    } catch (e, st) {
      debugPrint('❌ [SafetyPilotApiService] submitApplication unexpected: $e\n$st');
      rethrow;
    }
  }
}
