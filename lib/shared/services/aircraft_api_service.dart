import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:skye_app/shared/models/aircraft_model.dart';
import 'package:skye_app/shared/services/api_service.dart';

/// Aircraft API service
/// Handles fetching aircraft listings from backend
class AircraftApiService {
  AircraftApiService._();

  static final AircraftApiService instance = AircraftApiService._();

  /// Get all approved and active aircraft listings
  /// 
  /// Endpoint: GET /api/aircraft-listings
  /// Query params: type (sale/rental), per_page (default: 15)
  /// Response: { "data": [...], "meta": {...} }
  Future<AircraftListResponse> getAircraftListings({
    String? type, // 'sale' or 'rental'
    int? perPage,
  }) async {
    try {
      debugPrint('✈️ [AircraftApiService] getAircraftListings: type=$type, perPage=$perPage');

      final queryParams = <String, dynamic>{};
      if (type != null) {
        queryParams['type'] = type;
      }
      if (perPage != null) {
        queryParams['per_page'] = perPage;
      }

      final response = await ApiService.instance.dio.get(
        '/aircraft-listings',
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      debugPrint('✅ [AircraftApiService] getAircraftListings success');

      return AircraftListResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [AircraftApiService] getAircraftListings error: ${e.message}');
      rethrow;
    } catch (e, st) {
      debugPrint('❌ [AircraftApiService] getAircraftListings unexpected error: $e\n$st');
      rethrow;
    }
  }

  /// Get single aircraft listing
  /// 
  /// Endpoint: GET /api/aircraft-listings/{id}
  /// Response: { "data": {...} }
  Future<AircraftModel> getAircraftListing(int id) async {
    try {
      debugPrint('✈️ [AircraftApiService] getAircraftListing: id=$id');

      final response = await ApiService.instance.dio.get('/aircraft-listings/$id');

      debugPrint('✅ [AircraftApiService] getAircraftListing success');

      final data = response.data as Map<String, dynamic>;
      return AircraftModel.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [AircraftApiService] getAircraftListing error: ${e.message}');
      rethrow;
    } catch (e, st) {
      debugPrint('❌ [AircraftApiService] getAircraftListing unexpected error: $e\n$st');
      rethrow;
    }
  }

  /// Create aircraft listing
  ///
  /// Endpoint: POST /api/aircraft-listings
  /// Body: { title, model, base_airport?, location?, seat_count?, listing_type?, wet_price?, dry_price?, ... }
  Future<AircraftModel> createAircraftListing(Map<String, dynamic> body) async {
    try {
      debugPrint('✈️ [AircraftApiService] createAircraftListing');

      final response = await ApiService.instance.dio.post(
        '/aircraft-listings',
        data: body,
      );

      debugPrint('✅ [AircraftApiService] createAircraftListing success');

      final data = response.data as Map<String, dynamic>;
      return AircraftModel.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [AircraftApiService] createAircraftListing error: ${e.message}');
      if (e.response != null) {
        debugPrint('❌ [AircraftApiService] Response: ${e.response?.data}');
      }
      rethrow;
    } catch (e, st) {
      debugPrint('❌ [AircraftApiService] createAircraftListing unexpected: $e\n$st');
      rethrow;
    }
  }
}
