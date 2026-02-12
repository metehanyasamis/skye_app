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
  /// Query: search, type, aircraft_type_id, aircraft_brand, location, min_price, max_price, sort, per_page
  /// sort: 'price_asc' | 'price_desc'
  Future<AircraftListResponse> getAircraftListings({
    String? search,
    String? type,
    int? aircraftTypeId,
    String? aircraftBrand,
    String? location,
    double? minPrice,
    double? maxPrice,
    String? sort,
    int? perPage,
  }) async {
    try {
      debugPrint('✈️ [AircraftApiService] getAircraftListings');

      final queryParams = <String, dynamic>{};
      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }
      if (type != null && type.isNotEmpty) {
        queryParams['type'] = type;
      }
      if (aircraftTypeId != null) {
        queryParams['aircraft_type_id'] = aircraftTypeId;
      }
      if (aircraftBrand != null && aircraftBrand.trim().isNotEmpty) {
        queryParams['aircraft_brand'] = aircraftBrand.trim();
      }
      if (location != null && location.trim().isNotEmpty) {
        queryParams['location'] = location.trim();
      }
      if (minPrice != null) {
        queryParams['min_price'] = minPrice;
      }
      if (maxPrice != null) {
        queryParams['max_price'] = maxPrice;
      }
      if (sort != null && sort.isNotEmpty) {
        queryParams['sort'] = sort;
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
