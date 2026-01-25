import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:skye_app/shared/models/banner_model.dart';
import 'package:skye_app/shared/services/api_service.dart';

/// Banner API service
/// Handles fetching banners from backend
class BannerApiService {
  BannerApiService._();

  static final BannerApiService instance = BannerApiService._();

  /// Get all active banners
  /// 
  /// Endpoint: GET /api/banners
  /// Response: { "data": [{ "id": 0, "title": "string", "image_url": "string", "link_url": "string" }] }
  Future<List<BannerModel>> getBanners() async {
    try {
      debugPrint('📢 [BannerApiService] getBanners');

      final response = await ApiService.instance.dio.get('/banners');

      debugPrint('✅ [BannerApiService] getBanners success: ${response.data}');

      final data = response.data as Map<String, dynamic>;
      final bannersList = data['data'] as List<dynamic>? ?? [];

      return bannersList
          .map((json) => BannerModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      debugPrint('❌ [BannerApiService] getBanners error: ${e.message}');
      rethrow;
    } catch (e, st) {
      debugPrint('❌ [BannerApiService] getBanners unexpected error: $e\n$st');
      rethrow;
    }
  }
}
