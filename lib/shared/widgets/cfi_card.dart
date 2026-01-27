import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:skye_app/shared/models/pilot_model.dart';
import 'package:skye_app/shared/services/api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';

/// CFI listing kartı – CFI ekranında kullanılır.
class CfiCard extends StatelessWidget {
  const CfiCard({
    super.key,
    required this.pilot,
    this.onTap,
  });

  final PilotModel pilot;
  final VoidCallback? onTap;

  /// Check if pilot owns aircraft
  bool get _hasAircraft {
    final profile = pilot.pilotProfile;
    if (profile == null) return false;
    return profile.aircraftExperiences.any((exp) => exp.ownsAircraft);
  }

  /// Get instructor ratings as comma-separated string
  String get _instructorRatingsText {
    final profile = pilot.pilotProfile;
    if (profile == null || profile.instructorRatings.isEmpty) {
      return '';
    }
    return profile.instructorRatings
        .map((r) => r.ratingCode)
        .join(', ');
  }

  /// Get other licenses as comma-separated string
  String get _licensesText {
    final profile = pilot.pilotProfile;
    if (profile == null || profile.otherLicenses.isEmpty) {
      return 'N/A';
    }
    return profile.otherLicenses.map((l) => l.licenseCode).join(', ');
  }

  /// Get languages as comma-separated string
  String get _languagesText {
    final profile = pilot.pilotProfile;
    if (profile == null || profile.languages.isEmpty) {
      return 'N/A';
    }
    return profile.languages.map((l) => l.languageCode.toUpperCase()).join(', ');
  }

  /// Get experience text
  String get _experienceText {
    final profile = pilot.pilotProfile;
    if (profile == null) return 'N/A';
    
    final hours = profile.totalFlightHours;
    if (hours != null && hours > 0) {
      return '$hours+ hours dual given';
    }
    
    final years = profile.experienceYears;
    if (years != null && years > 0) {
      return '$years+ years experience';
    }
    
    return 'N/A';
  }

  /// Get hourly rate text
  String get _hourlyRateText {
    final profile = pilot.pilotProfile;
    if (profile == null || profile.hourlyRate == null) {
      return 'N/A';
    }
    return profile.hourlyRate!.toStringAsFixed(0);
  }

  /// Get location text
  String get _locationText {
    final profile = pilot.pilotProfile;
    return profile?.location ?? 'N/A';
  }

  /// Get airport text (for now, placeholder - may need separate field)
  String get _airportText {
    // TODO: Add airport field to PilotProfile if available
    return 'N/A';
  }

  /// Get rating score text
  String? get _ratingScoreText {
    final profile = pilot.pilotProfile;
    if (profile == null || profile.rating == null) {
      return null;
    }
    return profile.rating!.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final displayName = pilot.displayName;
    final profilePhotoPath = pilot.profilePhotoPath;
    final ratingScore = _ratingScoreText;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          DebugLogger.log('CfiCard', 'tapped', {'pilotId': pilot.id, 'name': displayName});
          onTap?.call();
        },
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profil foto – zemine oturur, yükseklik içeriğe göre
              SizedBox(
                width: 130,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Positioned.fill(
                      child: Container(
                        width: 164,
                        decoration: const BoxDecoration(
                          color: AppColors.borderLight,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
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
                                    child: Icon(
                                      Icons.person,
                                      size: 60,
                                      color: AppColors.textSecondary,
                                    ),
                                  );
                                },
                              )
                            : const Center(
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                      ),
                    ),
                    // Aircraft + Rating – profil fotosu sağ altında, yan yana
                    Positioned(
                      bottom: 10,
                      right: 8,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Aircraft badge - only show if pilot owns aircraft
                          if (_hasAircraft) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: AppColors.borderBlack10,
                                  width: 1,
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 10,
                                    color: AppColors.primaryNavy,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Aircraft',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.primaryNavy,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          // Rating badge - only show if rating score exists
                          if (ratingScore != null) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 12,
                                    color: AppColors.primaryNavy,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    ratingScore,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.primaryNavy,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Detaylar – fiyat location/airport ile aynı satır hizasında
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              displayName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.labelBlack,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              DebugLogger.log(
                                'CfiCard',
                                'favorite tapped',
                                {'pilotId': pilot.id, 'name': displayName},
                              );
                            },
                            child: const Icon(
                              Icons.favorite_border,
                              size: 18,
                              color: AppColors.labelBlack,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _CfiInfoRow(
                        icon: Icons.access_time_outlined,
                        label: _experienceText,
                      ),
                      if (_instructorRatingsText.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        _CfiInfoRow(
                          icon: Icons.flight_outlined,
                          label: _instructorRatingsText,
                        ),
                      ],
                      const SizedBox(height: 2),
                      _CfiInfoRow(
                        icon: Icons.workspace_premium_outlined,
                        label: _licensesText,
                      ),
                      const SizedBox(height: 2),
                      _CfiInfoRow(
                        icon: Icons.language_outlined,
                        label: _languagesText,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _CfiInfoRow(
                                  icon: Icons.location_on_outlined,
                                  label: _locationText,
                                ),
                                const SizedBox(height: 2),
                                _CfiInfoRow(
                                  icon: Icons.local_airport_outlined,
                                  label: _airportText,
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryNavy,
                              ),
                              children: [
                                TextSpan(text: '${_hourlyRateText}\$/'),
                                const TextSpan(
                                  text: 'hour',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

      debugPrint('🖼️ [CfiCard] Loading image with Dio: $fullUrl');

      final dio = ApiService.instance.dio;
      final authToken = ApiService.instance.getAuthToken();
      debugPrint('🔑 [CfiCard] Using ApiService Dio, token: ${authToken != null ? "YES" : "NO"}');

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
        debugPrint('✅ [CfiCard] Image loaded successfully (${response.data!.length} bytes)');
        return response.data;
      }
      return null;
    } catch (e) {
      debugPrint('❌ [CfiCard] Failed to load image with Dio: $e');
      if (e is DioException) {
        debugPrint('   Status: ${e.response?.statusCode}');
        debugPrint('   URL: ${e.requestOptions.uri}');
      }
      return null;
    }
  }
}

class _CfiInfoRow extends StatelessWidget {
  const _CfiInfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  static const _iconSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: _iconSize, color: AppColors.textGray),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w300,
              color: AppColors.textGray,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
