import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';

/// CFI listing kartı – CFI ekranında kullanılır.
class CfiCard extends StatelessWidget {
  const CfiCard({
    super.key,
    required this.name,
    required this.experience,
    required this.instructorRatings,
    required this.licenses,
    required this.languages,
    required this.location,
    required this.airport,
    required this.hourlyRate,
    required this.rating,
    this.onTap,
  });

  final String name;
  final String experience;
  final String instructorRatings;
  final String licenses;
  final String languages;
  final String location;
  final String airport;
  final String hourlyRate;
  final String rating;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          DebugLogger.log('CfiCard', 'tapped', {'name': name});
          onTap?.call();
        },
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profil foto – zemine oturur, yükseklik içeriğe göre
              SizedBox(
                width: 164,
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
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                // Aircraft + Rating – profil fotosu sağ altında, yan yana (Figma ek1)
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
                              rating,
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
                            name,
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
                              {'name': name},
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
                      label: experience,
                    ),
                    const SizedBox(height: 2),
                    _CfiInfoRow(
                      icon: Icons.flight_outlined,
                      label: instructorRatings,
                    ),
                    const SizedBox(height: 2),
                    _CfiInfoRow(
                      icon: Icons.workspace_premium_outlined,
                      label: licenses,
                    ),
                    const SizedBox(height: 2),
                    _CfiInfoRow(
                      icon: Icons.language_outlined,
                      label: languages,
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
                                label: location,
                              ),
                              const SizedBox(height: 2),
                              _CfiInfoRow(
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
                              color: AppColors.primaryNavy,
                            ),
                            children: [
                              TextSpan(text: '$hourlyRate\$/'),
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
