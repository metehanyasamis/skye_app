import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:skye_app/shared/models/aircraft_model.dart';
import 'package:skye_app/shared/services/api_service.dart';

/// Aircraft type model for filter/selector
class AircraftTypeModel {
  final int id;
  final String code;
  final String name;

  AircraftTypeModel({
    required this.id,
    required this.code,
    required this.name,
  });

  factory AircraftTypeModel.fromJson(Map<String, dynamic> json) {
    return AircraftTypeModel(
      id: json['id'] as int,
      code: (json['code'] ?? json['icao'] ?? '').toString(),
      name: (json['name'] ?? json['model_name'] ?? json['model'] ?? '').toString(),
    );
  }
}

/// Aircraft API service
/// Handles fetching aircraft listings from backend
class AircraftApiService {
  AircraftApiService._();

  static final AircraftApiService instance = AircraftApiService._();

  static final List<AircraftTypeModel> _fallbackTypes = [
    AircraftTypeModel(id: 1, code: 'C172', name: 'Cessna 172 Skyhawk'),
    AircraftTypeModel(id: 2, code: 'PA-28', name: 'Piper PA-28 Cherokee'),
    AircraftTypeModel(id: 3, code: 'DA-40', name: 'Diamond DA-40'),
    AircraftTypeModel(id: 4, code: 'C152', name: 'Cessna 152'),
    AircraftTypeModel(id: 5, code: 'SR20', name: 'Cirrus SR20'),
    AircraftTypeModel(id: 6, code: 'SR22', name: 'Cirrus SR22'),
  ];

  /// Get aircraft types list
  /// Endpoint: GET /aircraft-types (fallback to static list on error)
  /// page: pagination (backend may support page/per_page)
  Future<List<AircraftTypeModel>> getAircraftTypes({int page = 1}) async {
    try {
      debugPrint('✈️ [AircraftApiService] getAircraftTypes page=$page');
      final response = await ApiService.instance.dio.get(
        '/aircraft-types',
        queryParameters: {'page': page, 'per_page': 20},
      );
      debugPrint('✅ [AircraftApiService] getAircraftTypes success');
      final data = response.data;
      if (data is Map && data['data'] != null) {
        final list = data['data'] as List<dynamic>;
        return list.map((e) => AircraftTypeModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      if (data is List && (data as List).isNotEmpty) {
        return (data as List<dynamic>).map((e) => AircraftTypeModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return _fallbackTypes;
    } on DioException catch (e) {
      debugPrint('❌ [AircraftApiService] getAircraftTypes error: ${e.message}, using fallback');
      return _fallbackTypes;
    } catch (e, st) {
      debugPrint('❌ [AircraftApiService] getAircraftTypes unexpected: $e\n$st, using fallback');
      return _fallbackTypes;
    }
  }

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
