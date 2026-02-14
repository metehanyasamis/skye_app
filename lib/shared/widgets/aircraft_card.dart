import 'package:flutter/material.dart';
import 'package:skye_app/shared/models/aircraft_model.dart';
import 'package:skye_app/shared/services/api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/widgets/favorite_button.dart';

/// Aircraft listing kartı – Aircraft ekranında kullanılır.
/// CfiCard yapısı ile tam uyumlu hale getirilmiştir.
class AircraftCard extends StatelessWidget {
  const AircraftCard({
    super.key,
    required this.aircraft,
    this.onTap,
    this.isFavorited = false,
    this.onFavoriteTap,
  });

  /// Factory constructor from AircraftModel
  factory AircraftCard.fromModel(
    AircraftModel aircraft, {
    VoidCallback? onTap,
    bool isFavorited = false,
    VoidCallback? onFavoriteTap,
  }) {
    return AircraftCard(
      aircraft: aircraft,
      onTap: onTap,
      isFavorited: isFavorited,
      onFavoriteTap: onFavoriteTap,
    );
  }

  final AircraftModel aircraft;
  final VoidCallback? onTap;
  final bool isFavorited;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('AircraftCard', 'build()', {'title': aircraft.title});

    final imageUrl = aircraft.coverImageUrl;

    // Veri Formatlama
    final range = aircraft.flightHours != null ? '${aircraft.flightHours} nm' : '750 nm';
    final airport = aircraft.location?.split(',').first.trim() ?? 'KBNA';
    final seats = aircraft.seatCount != null ? '${aircraft.seatCount} Seats' : '4 Seats';
    final type = aircraft.model.isNotEmpty ? aircraft.model : 'ASEL';
    final wetPrice = aircraft.wetPrice?.toStringAsFixed(0) ?? '200';
    final dryPrice = aircraft.dryPrice?.toStringAsFixed(0) ?? '100';

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8), // CfiCard ile aynı (8px)
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBlack4,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          DebugLogger.log('AircraftCard', 'tapped', {'title': aircraft.title});
          onTap?.call();
        },
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. SOL TARAF: Görsel Alanı (CfiCard ile aynı 164px genişlik)
              SizedBox(
                width: 164,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  child: _buildImage(imageUrl),
                ),
              ),

              // 2. SAĞ TARAF: Detaylar
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Başlık ve Favori İkonu
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              aircraft.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.labelBlack,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          FavoriteButton(
                            isFavorited: isFavorited,
                            onTap: onFavoriteTap,
                            size: 18,
                            color: AppColors.labelBlack,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Bilgi Satırları (CfiCard _CfiInfoRow mantığı ile)
                      _buildInfoRow(Icons.route_outlined, range),
                      _buildInfoRow(Icons.location_on_outlined, airport),
                      _buildInfoRow(Icons.people_outline, seats),
                      _buildInfoRow(Icons.local_offer_outlined, type),

                      const SizedBox(height: 12),

                      // Fiyat Alanı (CfiCard Fiyat stili ile aynı)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildPrice(wetPrice, 'wet'),
                          _buildPrice(dryPrice, 'dry'),
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

  /// Görsel Oluşturucu (Tüm kontroller dahil)
  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null) return _buildPlaceholder();
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      headers: _getImageHeaders(),
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.placeholderBg,
      child: const Icon(Icons.flight, size: 50, color: AppColors.textGray),
    );
  }

  /// Bilgi Satırı Tasarımı (CfiCard ile eşlendi)
  Widget _buildInfoRow(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textGray),
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
            ),
          ),
        ],
      ),
    );
  }

  /// Fiyat Tasarımı (CfiCard RichText stili ile eşlendi)
  Widget _buildPrice(String price, String label) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryNavy,
        ),
        children: [
          TextSpan(text: '\$$price/'),
          TextSpan(
            text: label,
            style: const TextStyle(fontWeight: FontWeight.w100),
          ),
        ],
      ),
    );
  }

  Map<String, String> _getImageHeaders() {
    final headers = <String, String>{'Accept': 'image/*'};
    try {
      final authToken = ApiService.instance.getAuthToken();
      if (authToken != null) {
        headers['Authorization'] = authToken;
      }
    } catch (e) {
      debugPrint('❌ [AircraftCard] Error getting auth token: $e');
    }
    return headers;
  }
}