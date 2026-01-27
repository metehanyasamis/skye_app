import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skye_app/shared/models/banner_model.dart';
import 'package:skye_app/shared/services/api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';

/// Promo card widget for displaying banners
class PromoCard extends StatelessWidget {
  const PromoCard({
    super.key,
    this.banner,
    this.tag,
    this.title,
    this.gradient,
    this.onTap,
  }) : assert(
          (banner != null) || (tag != null && title != null && gradient != null),
          'Either banner or tag/title/gradient must be provided',
        );

  final BannerModel? banner;
  final String? tag;
  final String? title;
  final Gradient? gradient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isFromBanner = banner != null;
    final displayTag = isFromBanner ? null : tag;
    final displayTitle = isFromBanner ? banner!.title : title;
    final displaySubtitle = isFromBanner ? banner!.subtitle : null;
    final displayGradient = isFromBanner ? null : gradient;
    final imageUrl = isFromBanner ? banner!.mediaUrl : null;

    debugPrint('🧩 [PromoCard] build title="$displayTitle"');
    if (isFromBanner) {
      debugPrint('   📸 [PromoCard] imageUrl: $imageUrl');
      debugPrint('   🎬 [PromoCard] type: ${banner!.type}');
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        width: 343,
        height: 151,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: displayGradient,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background image or gradient
            if (imageUrl != null)
              Positioned.fill(
                child: FutureBuilder<Uint8List?>(
                  future: _loadImageWithAuth(imageUrl),
                  builder: (context, snapshot) {
                    // Show image if loaded successfully
                    if (snapshot.hasData && snapshot.data != null) {
                      return Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      );
                    }
                    // Show gradient background (no progress indicator) while loading or on error
                    return Container(
                      decoration: BoxDecoration(
                        gradient: displayGradient ??
                            const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.navy900, AppColors.blueGradientLight],
                            ),
                      ),
                    );
                  },
                ),
              )
            else if (displayGradient != null)
              Container(
                decoration: BoxDecoration(
                  gradient: displayGradient,
                ),
              ),
            // Dark overlay for better text readability when using image
            if (imageUrl != null)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (displayTag != null)
                    Text(
                      displayTag,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.6,
                      ),
                    ),
                  if (displayTag != null) const SizedBox(height: 12),
                  if (displaySubtitle != null)
                    Text(
                      displaySubtitle,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  if (displaySubtitle != null) const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      displayTitle ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Video play icon - only show if banner type is 'video'
            if (isFromBanner && banner!.type == 'video')
              Positioned(
                bottom: 7,
                right: 7,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withValues(alpha: 0.2),
                  ),
                  child: const Icon(
                    Icons.play_circle_fill,
                    color: AppColors.white,
                    size: 30,
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
      debugPrint('🖼️ [PromoCard] Loading image with Dio: $imageUrl');
      
      final dio = ApiService.instance.dio;
      final authToken = ApiService.instance.getAuthToken();
      debugPrint('🔑 [PromoCard] Using ApiService Dio, token: ${authToken != null ? "YES" : "NO"}');
      
      final uri = Uri.parse(imageUrl);
      final imagePath = uri.path;
      debugPrint('🔗 [PromoCard] Image path: $imagePath');
      
      final imageDio = Dio();
      imageDio.options.headers.addAll(dio.options.headers);
      imageDio.options.headers['Accept'] = 'image/*';
      
      debugPrint('📤 [PromoCard] Final request URL: $imageUrl');
      debugPrint('📤 [PromoCard] Final headers: ${imageDio.options.headers}');
      
      final response = await imageDio.get<Uint8List>(
        imageUrl,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );
      if (response.data != null) {
        debugPrint('✅ [PromoCard] Image loaded successfully (${response.data!.length} bytes)');
        return response.data;
      }
      return null;
    } catch (e) {
      debugPrint('❌ [PromoCard] Failed to load image with Dio: $e');
      if (e is DioException) {
        debugPrint('❌ [PromoCard] DioException details:');
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
