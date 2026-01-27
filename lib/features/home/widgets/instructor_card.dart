import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skye_app/shared/models/pilot_model.dart';
import 'package:skye_app/shared/services/api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';

/// Instructor card widget for displaying instructor information
class InstructorCard extends StatelessWidget {
  const InstructorCard({
    super.key,
    required this.pilot,
    this.distanceInMiles,
    this.onTap,
  });

  final PilotModel pilot;
  final double? distanceInMiles; // Distance in miles from user's selected location
  final VoidCallback? onTap;

  /// Get distance display text
  String? get _distanceText {
    if (distanceInMiles == null) return null;
    return '${distanceInMiles!.toStringAsFixed(1)} miles away';
  }

  @override
  Widget build(BuildContext context) {
    final displayName = pilot.displayName;
    final profilePhotoPath = pilot.profilePhotoPath;
    final distanceText = _distanceText;

    debugPrint('🧩 [InstructorCard] build name="$displayName"');
    if (profilePhotoPath != null) {
      debugPrint('   📸 [InstructorCard] profilePhotoPath: $profilePhotoPath');
    } else {
      debugPrint('   ⚠️ [InstructorCard] profilePhotoPath is null - showing placeholder');
    }

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 90,
        child: Column(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.placeholderGray,
              ),
              clipBehavior: Clip.antiAlias,
              child: profilePhotoPath != null
                  ? FutureBuilder<Uint8List?>(
                      future: _loadImageWithAuth(profilePhotoPath),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          );
                        }
                        return const Center(
                          child: Icon(Icons.person, size: 50, color: AppColors.textSecondary),
                        );
                      },
                    )
                  : const Center(
                      child: Icon(Icons.person, size: 50, color: AppColors.textSecondary),
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              displayName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textGrayMedium,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // Only show distance if user has selected a location
            if (distanceText != null)
              Text(
                distanceText!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: AppColors.textGrayMedium,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }

  /// Load image using Dio (to ensure auth headers are included)
  Future<Uint8List?> _loadImageWithAuth(String imageUrl) async {
    try {
      // Convert relative path to full URL if needed
      String fullUrl = imageUrl;
      if (!imageUrl.startsWith('http://') && !imageUrl.startsWith('https://')) {
        // If it's a relative path, prepend base storage URL
        if (imageUrl.startsWith('/')) {
          fullUrl = 'https://skye.dijicrea.net$imageUrl';
        } else {
          fullUrl = 'https://skye.dijicrea.net/storage/$imageUrl';
        }
      }
      
      debugPrint('🖼️ [InstructorCard] Loading image with Dio: $fullUrl');
      
      final dio = ApiService.instance.dio;
      final authToken = ApiService.instance.getAuthToken();
      debugPrint('🔑 [InstructorCard] Using ApiService Dio, token: ${authToken != null ? "YES" : "NO"}');
      
      final imageDio = Dio();
      imageDio.options.headers.addAll(dio.options.headers);
      imageDio.options.headers['Accept'] = 'image/*';
      
      final response = await imageDio.get<Uint8List>(
        fullUrl,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );
      if (response.data != null) {
        debugPrint('✅ [InstructorCard] Image loaded successfully (${response.data!.length} bytes)');
        return response.data;
      }
      return null;
    } catch (e) {
      debugPrint('❌ [InstructorCard] Failed to load image with Dio: $e');
      if (e is DioException) {
        debugPrint('   Status: ${e.response?.statusCode}');
        debugPrint('   URL: ${e.requestOptions.uri}');
      }
      return null;
    }
  }
}
