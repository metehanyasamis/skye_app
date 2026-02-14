import 'package:flutter/foundation.dart';
import 'package:skye_app/shared/models/location_models.dart';
import 'package:skye_app/shared/services/api_service.dart';

/// Location API – states, cities, airports
/// Endpoints: GET /api/states, /api/states/{id}/cities, /api/airports/search, /api/cities/{id}/airports
class LocationApiService {
  LocationApiService._();
  static final LocationApiService instance = LocationApiService._();

  /// GET /api/states – tüm eyaletler
  Future<List<StateModel>> getStates() async {
    try {
      debugPrint('📍 [LocationApiService] getStates');
      final response = await ApiService.instance.dio.get('/states');
      final data = response.data;
      if (data is Map && data['data'] is List) {
        final list = (data['data'] as List)
            .map((e) => StateModel.fromJson(e as Map<String, dynamic>))
            .toList();
        debugPrint('📍 [LocationApiService] getStates success: ${list.length} states');
        return list;
      }
      if (data is List) {
        return (data as List)
            .map((e) => StateModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('❌ [LocationApiService] getStates error: $e');
      rethrow;
    }
  }

  /// GET /api/states/{stateId}/cities – eyalete göre şehirler
  Future<List<CityModel>> getCitiesByState(int stateId) async {
    try {
      debugPrint('📍 [LocationApiService] getCitiesByState: stateId=$stateId');
      final response = await ApiService.instance.dio.get('/states/$stateId/cities');
      final data = response.data;
      if (data is Map && data['data'] is List) {
        final list = (data['data'] as List)
            .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
            .toList();
        debugPrint('📍 [LocationApiService] getCitiesByState success: ${list.length} cities');
        return list;
      }
      if (data is List) {
        return (data as List)
            .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('❌ [LocationApiService] getCitiesByState error: $e');
      rethrow;
    }
  }

  /// GET /api/airports/search – arama veya init listesi
  /// query: min 2 karakter (init=false ise zorunlu)
  /// init: true ise varsayılan liste döner
  /// page: pagination
  Future<List<AirportModel>> searchAirports({
    String? query,
    bool init = false,
    int page = 1,
  }) async {
    try {
      debugPrint('📍 [LocationApiService] searchAirports: query=$query, init=$init, page=$page');
      final params = <String, dynamic>{
        'page': page,
        'per_page': 20,
      };
      if (query != null && query.trim().length >= 2) {
        params['query'] = query.trim();
      }
      if (init && page == 1) {
        params['init'] = true;
      }
      final response = await ApiService.instance.dio.get(
        '/airports/search',
        queryParameters: params,
      );
      final data = response.data;
      if (data is Map && data['data'] is List) {
        final list = (data['data'] as List)
            .map((e) => AirportModel.fromJson(e as Map<String, dynamic>))
            .toList();
        debugPrint('📍 [LocationApiService] searchAirports success: ${list.length} airports (page=$page)');
        return list;
      }
      return [];
    } catch (e) {
      debugPrint('❌ [LocationApiService] searchAirports error: $e');
      rethrow;
    }
  }

  /// GET /api/cities/{cityId}/airports – şehre göre havalimanları
  Future<List<AirportModel>> getAirportsByCity(int cityId) async {
    try {
      debugPrint('📍 [LocationApiService] getAirportsByCity: cityId=$cityId');
      final response = await ApiService.instance.dio.get('/cities/$cityId/airports');
      final data = response.data;
      if (data is Map && data['data'] is List) {
        final list = (data['data'] as List)
            .map((e) => AirportModel.fromJson(e as Map<String, dynamic>))
            .toList();
        debugPrint('📍 [LocationApiService] getAirportsByCity success: ${list.length} airports');
        return list;
      }
      if (data is List) {
        return (data as List)
            .map((e) => AirportModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('❌ [LocationApiService] getAirportsByCity error: $e');
      rethrow;
    }
  }
}
