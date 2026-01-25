import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:skye_app/shared/models/blog_model.dart';
import 'package:skye_app/shared/services/api_service.dart';

/// Blog API service
/// Handles fetching blog posts from backend
class BlogApiService {
  BlogApiService._();

  static final BlogApiService instance = BlogApiService._();

  /// Get all published blog posts
  /// 
  /// Endpoint: GET /api/blog
  /// Query params: per_page (default: 15)
  /// Response: { "data": [...], "meta": {...} }
  Future<BlogListResponse> getBlogPosts({int? perPage}) async {
    try {
      debugPrint('📰 [BlogApiService] getBlogPosts: perPage=$perPage');

      final queryParams = <String, dynamic>{};
      if (perPage != null) {
        queryParams['per_page'] = perPage;
      }

      final response = await ApiService.instance.dio.get(
        '/blog',
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      debugPrint('✅ [BlogApiService] getBlogPosts success');

      return BlogListResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [BlogApiService] getBlogPosts error: ${e.message}');
      rethrow;
    } catch (e, st) {
      debugPrint('❌ [BlogApiService] getBlogPosts unexpected error: $e\n$st');
      rethrow;
    }
  }

  /// Get single published blog post
  /// 
  /// Endpoint: GET /api/blog/{id}
  /// Response: { "data": {...} }
  Future<BlogModel> getBlogPost(int id) async {
    try {
      debugPrint('📰 [BlogApiService] getBlogPost: id=$id');

      final response = await ApiService.instance.dio.get('/blog/$id');

      debugPrint('✅ [BlogApiService] getBlogPost success');

      final data = response.data as Map<String, dynamic>;
      return BlogModel.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [BlogApiService] getBlogPost error: ${e.message}');
      rethrow;
    } catch (e, st) {
      debugPrint('❌ [BlogApiService] getBlogPost unexpected error: $e\n$st');
      rethrow;
    }
  }
}
