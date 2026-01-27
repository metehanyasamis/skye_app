import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skye_app/shared/models/blog_model.dart';
import 'package:skye_app/shared/services/api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';

/// Info card widget for displaying blog posts
class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    this.blog,
    this.title,
    this.onTap,
  }) : assert(
          blog != null || title != null,
          'Either blog or title must be provided',
        );

  final BlogModel? blog;
  final String? title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final displayTitle = blog?.title ?? title ?? '';
    final imageUrl = blog?.featuredImage;

    debugPrint('🧩 [InfoCard] build title="$displayTitle"');
    if (imageUrl != null) {
      debugPrint('   📸 [InfoCard] imageUrl: $imageUrl');
    } else {
      debugPrint('   ⚠️ [InfoCard] No imageUrl - showing placeholder');
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        height: 135,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.blueInfo,
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background image or placeholder
            Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.blueInfoLight,
              ),
              child: imageUrl != null
                  ? FutureBuilder<Uint8List?>(
                      future: _loadImageWithAuth(imageUrl),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          );
                        }
                        if (snapshot.hasData && snapshot.data != null) {
                          return Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          );
                        }
                        return const Center(
                          child: Icon(Icons.image, size: 50, color: Colors.white),
                        );
                      },
                    )
                  : const Center(
                      child: Icon(Icons.image, size: 50, color: Colors.white),
                    ),
            ),
            // Dark overlay for text readability
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
            ),
            // Title text
            Positioned(
              bottom: 0,
              left: 9,
              right: 9,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  displayTitle,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Load image using Dio (to ensure auth headers are included)
  Future<Uint8List?> _loadImageWithAuth(String imageUrl) async {
    try {
      debugPrint('🖼️ [InfoCard] Loading image with Dio: $imageUrl');
      
      final dio = ApiService.instance.dio;
      final authToken = ApiService.instance.getAuthToken();
      debugPrint('🔑 [InfoCard] Using ApiService Dio, token: ${authToken != null ? "YES" : "NO"}');
      
      final uri = Uri.parse(imageUrl);
      final imagePath = uri.path;
      debugPrint('🔗 [InfoCard] Image path: $imagePath');
      
      final imageDio = Dio();
      imageDio.options.headers.addAll(dio.options.headers);
      imageDio.options.headers['Accept'] = 'image/*';
      
      debugPrint('📤 [InfoCard] Final request URL: $imageUrl');
      debugPrint('📤 [InfoCard] Final headers: ${imageDio.options.headers}');
      
      final response = await imageDio.get<Uint8List>(
        imageUrl,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );
      if (response.data != null) {
        debugPrint('✅ [InfoCard] Image loaded successfully (${response.data!.length} bytes)');
        return response.data;
      }
      return null;
    } catch (e) {
      debugPrint('❌ [InfoCard] Failed to load image with Dio: $e');
      if (e is DioException) {
        debugPrint('❌ [InfoCard] DioException details:');
        debugPrint('   Status: ${e.response?.statusCode}');
        debugPrint('   Request URL: ${e.requestOptions.uri}');
        debugPrint('   Request headers: ${e.requestOptions.headers}');
        debugPrint('   Response headers: ${e.response?.headers}');
        //debugPrint('   Response data: ${e.response?.data}');
      }
      return null;
    }
  }
}
