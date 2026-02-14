import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:skye_app/shared/models/pilot_model.dart';
import 'package:skye_app/shared/services/api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/widgets/favorite_button.dart';

/// Safety pilot listing kartı – time building ekranında kullanılır.
class SafetyPilotCard extends StatelessWidget {
  const SafetyPilotCard({
    super.key,
    required this.name,
    required this.rating,
    required this.languages,
    required this.hours,
    required this.instructorRatings,
    required this.otherLicenses,
    required this.location,
    required this.airport,
    required this.price,
    this.pilot,
    this.onTap,
    this.isFavorited = false,
    this.onFavoriteTap,
  });

  /// PilotModel ile oluştur – API’den gelen veri için.
  factory SafetyPilotCard.fromPilot(
    PilotModel pilot, {
    VoidCallback? onTap,
    bool isFavorited = false,
    VoidCallback? onFavoriteTap,
  }) {
    final p = pilot.pilotProfile;
    return SafetyPilotCard(
      pilot: pilot,
      onTap: onTap,
      isFavorited: isFavorited,
      onFavoriteTap: onFavoriteTap,
      name: pilot.displayName,
      rating: p?.rating ?? 0,
      languages: p?.languages.isNotEmpty == true
          ? p!.languages.map((l) => l.languageCode.toUpperCase()).join(', ')
          : 'N/A',
      hours: p?.totalFlightHours != null && p!.totalFlightHours! > 0
          ? '${p.totalFlightHours}+ hours'
          : 'N/A',
      instructorRatings: p?.instructorRatings.isNotEmpty == true
          ? p!.instructorRatings.map((r) => r.ratingCode).join(', ')
          : 'N/A',
      otherLicenses: p?.otherLicenses.isNotEmpty == true
          ? p!.otherLicenses.map((l) => l.licenseCode).join(', ')
          : 'N/A',
      location: p?.location ?? 'N/A',
      airport: 'N/A',
      price: p?.hourlyRate?.toInt() ?? 0,
    );
  }

  final String name;
  final double rating;
  final String languages;
  final String hours;
  final String instructorRatings;
  final String otherLicenses;
  final String location;
  final String airport;
  final int price;
  final PilotModel? pilot;
  final VoidCallback? onTap;
  final bool isFavorited;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final child = _buildContent(context);
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: child,
      );
    }
    return child;
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: Icon(
        Icons.person,
        size: 80,
        color: AppColors.textSecondary,
      ),
    );
  }

  Future<Uint8List?> _loadImageWithAuth(String imageUrl) async {
    try {
      String fullUrl = imageUrl;
      if (!imageUrl.startsWith('http://') && !imageUrl.startsWith('https://')) {
        if (imageUrl.startsWith('/')) {
          fullUrl = 'https://skye.dijicrea.net$imageUrl';
        } else {
          fullUrl = 'https://skye.dijicrea.net/storage/$imageUrl';
        }
      }
      final dio = ApiService.instance.dio;
      final imageDio = Dio();
      imageDio.options.headers.addAll(dio.options.headers);
      imageDio.options.headers['Accept'] = 'image/*';
      final response = await imageDio.get<Uint8List>(
        fullUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      return response.data;
    } catch (e) {
      return null;
    }
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 164,
                height: 170,
                decoration: const BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: pilot?.profilePhotoPath != null
                    ? FutureBuilder<Uint8List?>(
                        future: _loadImageWithAuth(pilot!.profilePhotoPath!),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                              width: 164,
                              height: 170,
                            );
                          }
                          return _buildPlaceholder();
                        },
                      )
                    : _buildPlaceholder(),
              ),
              Positioned(
                bottom: 10,
                right: 8,
                left: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.flight,
                            size: 10,
                            color: Color(0xFF011A44),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Aircraft',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF011A44),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                            color: Color(0xFF011A44),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF011A44),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF353535),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        FavoriteButton(
                          isFavorited: isFavorited,
                          onTap: () {
                            DebugLogger.log(
                              'SafetyPilotCard',
                              'favorite tapped',
                              {'name': name},
                            );
                            onFavoriteTap?.call();
                          },
                          size: 18,
                          color: const Color(0xFF353535),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _SafetyPilotInfoRow(
                      icon: Icons.language_outlined,
                      label: languages,
                    ),
                    const SizedBox(height: 2),
                    _SafetyPilotInfoRow(
                      icon: Icons.access_time_outlined,
                      label: hours,
                    ),
                    const SizedBox(height: 2),
                    _SafetyPilotInfoRow(
                      icon: Icons.flight_outlined,
                      label: instructorRatings,
                    ),
                    const SizedBox(height: 2),
                    _SafetyPilotInfoRow(
                      icon: Icons.workspace_premium_outlined,
                      label: otherLicenses,
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
                              _SafetyPilotInfoRow(
                                icon: Icons.location_on_outlined,
                                label: location,
                              ),
                              const SizedBox(height: 2),
                              _SafetyPilotInfoRow(
                                icon: Icons.local_airport_outlined,
                                label: airport,
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF011A44),
                            ),
                            children: [
                              TextSpan(text: '\$$price/'),
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
          ),
        ],
      ),
    );
  }
}

class _SafetyPilotInfoRow extends StatelessWidget {
  const _SafetyPilotInfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  static const _iconSize = 16.0;
  static const _textColor = Color(0xFF858585);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: _iconSize, color: _textColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w300,
              color: _textColor,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
