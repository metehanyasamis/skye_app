import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:skye_app/shared/services/api_service.dart';

/// Safety Pilot application API.
/// Uses the same endpoint as CFI: POST /api/pilot/applications
/// Differentiated by pilot_type: "safety_pilot"
class SafetyPilotApiService {
  SafetyPilotApiService._();

  static final SafetyPilotApiService instance = SafetyPilotApiService._();

  /// Submit safety pilot application.
  /// Endpoint: POST /api/pilot/applications
  /// Request must include pilot_type: "safety_pilot"
  Future<Map<String, dynamic>> submitApplication(Map<String, dynamic> data) async {
    try {
      debugPrint('🧑‍✈️ [SafetyPilotApiService] submitApplication');
      debugPrint('📦 [SafetyPilotApiService] Data: $data');

      final response = await ApiService.instance.dio.post(
        '/pilot/applications',
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
