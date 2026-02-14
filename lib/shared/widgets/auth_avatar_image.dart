import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skye_app/shared/services/api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';

/// Avatar image that loads from URL with auth headers (for profile photos).
class AuthAvatarImage extends StatelessWidget {
  const AuthAvatarImage({
    super.key,
    required this.imageUrl,
    this.size = 57,
    this.placeholderIconSize = 40,
  });

  final String imageUrl;
  final double size;
  final double placeholderIconSize;

  Future<Uint8List?> _loadImageWithAuth() async {
    try {
      String fullUrl = imageUrl;
      if (!imageUrl.startsWith('http://') && !imageUrl.startsWith('https://')) {
        final base = ApiService.baseUrl.replaceFirst('/api', '');
        fullUrl = imageUrl.startsWith('/') ? '$base$imageUrl' : '$base/$imageUrl';
      }
      debugPrint('📷 [AuthAvatarImage] Loading: $fullUrl');
      final dio = ApiService.instance.dio;
      final imageDio = Dio();
      imageDio.options.headers.addAll(dio.options.headers);
      imageDio.options.headers['Accept'] = 'image/*';
      final response = await imageDio.get<Uint8List>(
        fullUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.data != null) {
        debugPrint('✅ [AuthAvatarImage] Loaded ${response.data!.length} bytes');
        return response.data;
      }
      return null;
    } catch (e) {
      debugPrint('❌ [AuthAvatarImage] Failed: $e');
      if (e is DioException) {
        debugPrint('   Status: ${e.response?.statusCode}');
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _loadImageWithAuth(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return ClipOval(
            child: Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
              width: size,
              height: size,
            ),
          );
        }
        return CircleAvatar(
          radius: size / 2,
          backgroundColor: AppColors.cardLight,
          child: Icon(Icons.person, size: placeholderIconSize, color: AppColors.textSecondary),
        );
      },
    );
  }
}
