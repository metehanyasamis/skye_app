import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:skye_app/shared/models/pilot_model.dart';
import 'package:skye_app/shared/services/api_service.dart';

/// Pilot API service
/// Handles fetching pilots/instructors from backend
class PilotApiService {
  PilotApiService._();

  static final PilotApiService instance = PilotApiService._();

  /// Get approved CFI pilots for listing (onaylanan CFI pilotları).
  /// 
  /// Endpoint: GET /api/pilots
  /// Query params: page, per_page, pilot_type (pilot=CFI), status (approved)
  /// Response: { "data": [...], "meta": {...}, "links": {...} }
  Future<PilotListResponse> getPilots({
    int? page,
    int? perPage,
    String? pilotType,
    String? status,
  }) async {
    try {
      debugPrint('👨‍✈️ [PilotApiService] getPilots: page=$page, perPage=$perPage, pilotType=$pilotType, status=$status');

      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (perPage != null) queryParams['per_page'] = perPage;
      if (pilotType != null && pilotType.isNotEmpty) queryParams['pilot_type'] = pilotType;
      if (status != null && status.isNotEmpty) queryParams['status'] = status;

      final response = await ApiService.instance.dio.get(
        '/pilots',
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      debugPrint('✅ [PilotApiService] getPilots success');
      debugPrint('📦 [PilotApiService] Response type: ${response.data.runtimeType}');

      // Backend may return either:
      // 1. Direct array: [{...}, {...}]
      // 2. Wrapped format: {"data": [...], "meta": {...}, "links": {...}}
      if (response.data is List) {
        // Direct array format - wrap it
        final pilotsList = response.data as List<dynamic>;
        final pilots = pilotsList
            .map((e) => PilotModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return PilotListResponse(
          data: pilots,
          meta: null,
          links: null,
        );
      } else {
        // Wrapped format
        return PilotListResponse.fromJson(response.data as Map<String, dynamic>);
      }
    } on DioException catch (e) {
      debugPrint('❌ [PilotApiService] getPilots error: ${e.message}');
      rethrow;
    } catch (e, st) {
      debugPrint('❌ [PilotApiService] getPilots unexpected error: $e\n$st');
      rethrow;
    }
  }

  /// Get single pilot by ID
  /// 
  /// Endpoint: GET /api/pilots/{id}
  /// Response: { "data": {...} }
  Future<PilotModel> getPilot(int id) async {
    try {
      debugPrint('👨‍✈️ [PilotApiService] getPilot: id=$id');

      final response = await ApiService.instance.dio.get('/pilots/$id');

      debugPrint('✅ [PilotApiService] getPilot success');

      final data = response.data as Map<String, dynamic>;
      return PilotModel.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [PilotApiService] getPilot error: ${e.message}');
      rethrow;
    } catch (e, st) {
      debugPrint('❌ [PilotApiService] getPilot unexpected error: $e\n$st');
      rethrow;
    }
  }

  /// Get single pilot/CFI/Safety Pilot application details (detay ekranı).
  /// 
  /// Endpoint: GET /api/pilot/applications/{id} (RTF doc)
  /// Response: { "data": { id, pilot_type, full_name, hourly_rate, ... } }
  Future<Map<String, dynamic>> getPilotApplication(int id) async {
    try {
      debugPrint('👨‍✈️ [PilotApiService] getPilotApplication: id=$id');

      final response = await ApiService.instance.dio.get(
        '/pilot/applications/$id',
      );

      debugPrint('✅ [PilotApiService] getPilotApplication success');

      final data = response.data as Map<String, dynamic>?;
      return data?['data'] as Map<String, dynamic>? ?? {};
    } on DioException catch (e) {
      debugPrint('❌ [PilotApiService] getPilotApplication error: ${e.message}');
      rethrow;
    } catch (e, st) {
      debugPrint('❌ [PilotApiService] getPilotApplication unexpected error: $e\n$st');
      rethrow;
    }
  }

  /// List authenticated pilot's applications (pending, approved, etc.).
  /// 
  /// Endpoint: GET /api/pilot/applications (RTF doc)
  /// Response: { "data": [{ id, pilot_type, status, full_name, ... }, ...] }
  Future<List<Map<String, dynamic>>> getPilotApplications() async {
    try {
      debugPrint('👨‍✈️ [PilotApiService] getPilotApplications');

      final response = await ApiService.instance.dio.get('/pilot/applications');

      debugPrint('✅ [PilotApiService] getPilotApplications success');

      final data = response.data as Map<String, dynamic>?;
      final list = data?['data'] as List<dynamic>?;
      return list?.map((e) => e as Map<String, dynamic>).toList() ?? [];
    } on DioException catch (e) {
      debugPrint('❌ [PilotApiService] getPilotApplications error: ${e.message}');
      rethrow;
    } catch (e, st) {
      debugPrint('❌ [PilotApiService] getPilotApplications unexpected error: $e\n$st');
      rethrow;
    }
  }

  /// Submit new pilot application
  /// 
  /// Endpoint: POST /api/pilot/applications
  /// Request body: {
  ///   "package_id": int,
  ///   "pilot_type": string,
  ///   "desired_level": string,
  ///   "license_number": string,
  ///   "base_airport": string,
  ///   "country": string,
  ///   "city": string,
  ///   "address": string,
  ///   "experience_years": int,
  ///   "total_flight_hours": int,
  ///   "hourly_rate": int,
  ///   "notes": string,
  ///   "spoken_languages": [string],
  ///   "instructor_ratings": [string],
  ///   "other_licenses": [string],
  ///   "aircraft_experiences": [{aircraft_type, hours, owns_aircraft}]
  /// }
  Future<Map<String, dynamic>> submitApplication(Map<String, dynamic> data) async {
    try {
      debugPrint('👨‍✈️ [PilotApiService] submitApplication');
      debugPrint('📦 [PilotApiService] Data: $data');

      final response = await ApiService.instance.dio.post(
        '/pilot/applications',
        data: data,
      );

      debugPrint('✅ [PilotApiService] submitApplication success');

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      debugPrint('❌ [PilotApiService] submitApplication error: ${e.message}');
      if (e.response != null) {
        debugPrint('❌ [PilotApiService] Response: ${e.response?.data}');
      }
      rethrow;
    } catch (e, st) {
      debugPrint('❌ [PilotApiService] submitApplication unexpected error: $e\n$st');
      rethrow;
    }
  }
}
