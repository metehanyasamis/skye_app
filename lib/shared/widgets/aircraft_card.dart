import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';

/// Aircraft listing kartı – aircraft ekranında kullanılır.
class AircraftCard extends StatelessWidget {
  const AircraftCard({
    super.key,
    required this.name,
    required this.range,
    required this.type,
    required this.airport,
    required this.seats,
    required this.wetPrice,
    required this.dryPrice,
  });

  final String name;
  final String range;
  final String type;
  final String airport;
  final String seats;
  final String wetPrice;
  final String dryPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 127,
            height: 88,
            decoration: const BoxDecoration(
              color: AppColors.cardLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.flight,
                size: 40,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.labelBlack,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.route,
                            size: 12,
                            color: AppColors.textGray,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            range,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: AppColors.textGray,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.local_offer,
                            size: 12,
                            color: AppColors.textGray,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            type,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: AppColors.textGray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        airport,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: AppColors.labelBlack.withValues(alpha: 0.52),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        seats,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: AppColors.labelBlack.withValues(alpha: 0.52),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF40648D),
                          ),
                          children: [
                            TextSpan(text: '$wetPrice/hr '),
                            const TextSpan(
                              text: 'wet',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w300,
                                color: AppColors.labelBlack60,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF40648D),
                          ),
                          children: [
                            TextSpan(text: '$dryPrice/hr '),
                            const TextSpan(
                              text: 'dry',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w300,
                                color: AppColors.labelBlack60,
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
    );
  }
}
