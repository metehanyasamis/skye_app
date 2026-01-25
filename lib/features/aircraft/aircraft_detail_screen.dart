import 'package:flutter/material.dart';

import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';

class AircraftDetailScreen extends StatelessWidget {
  const AircraftDetailScreen({super.key});

  static const routeName = '/aircraft/detail';

  @override
  Widget build(BuildContext context) {
    debugPrint('🛩️ [AircraftDetailScreen] build() started');

    SystemUIHelper.setLightStatusBar();
    debugPrint('✅ [AircraftDetailScreen] SystemChrome.setSystemUIOverlayStyle applied');

    return Scaffold(
      backgroundColor: AppColors.cfiBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top header with back and favorite
            Builder(
              builder: (context) {
                debugPrint('🧩 [AircraftDetailScreen] Header built');
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: AppColors.labelBlack),
                        onPressed: () {
                          debugPrint('⬅️ [AircraftDetailScreen] Back pressed -> pop()');
                          Navigator.of(context).pop();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite_border, color: AppColors.labelBlack),
                        onPressed: () {
                          debugPrint('❤️ [AircraftDetailScreen] Favorite pressed');
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            // Aircraft image
            Builder(
              builder: (context) {
                debugPrint('🖼️ [AircraftDetailScreen] Aircraft image container built');
                return Container(
                  height: 243,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.flight,
                      size: 120,
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // Badges
            Builder(
              builder: (context) {
                debugPrint('🏷️ [AircraftDetailScreen] Badges row built');
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: const [
                      _Badge(icon: Icons.star, text: '4.9'),
                      SizedBox(width: 8),
                      _Badge(text: 'Airport: NY'),
                      SizedBox(width: 8),
                      _Badge(text: 'Seats: 4'),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            Builder(
              builder: (context) {
                debugPrint('ℹ️ [AircraftDetailScreen] Information section built');
                return _InformationSection();
              },
            ),

            const SizedBox(height: 16),

            Builder(
              builder: (context) {
                debugPrint('⭐ [AircraftDetailScreen] Reviews section built');
                return _ReviewsSection();
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    this.icon,
    required this.text,
  });

  final IconData? icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    debugPrint('🏷️ [_Badge] build text="$text" icon=${icon != null}');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: AppColors.labelBlack),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.labelBlack,
            ),
          ),
        ],
      ),
    );
  }
}

class _InformationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('ℹ️ [_InformationSection] build started');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.labelBlack,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                // Owner profile row
                Builder(
                  builder: (context) {
                    debugPrint('👤 [_InformationSection] Owner row built');
                    return Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundColor: AppColors.cardLight,
                          child: Icon(Icons.person, color: AppColors.textSecondary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pelin Doğrul L.R Riberio',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.labelBlack,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  ...List.generate(5, (index) {
                                    debugPrint('⭐ [_InformationSection] Owner star built index=$index');
                                    return const Icon(
                                      Icons.star,
                                      size: 12,
                                      color: Color(0xFFFEC84B),
                                    );
                                  }),
                                  const SizedBox(width: 4),
                                  const Text(
                                    '5',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.labelBlack,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.phone, color: AppColors.blue500),
                          onPressed: () {
                            debugPrint('📞 [_InformationSection] Phone icon pressed');
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Airplane and Range
                Builder(
                  builder: (context) {
                    debugPrint('🧾 [_InformationSection] Airplane + Range row built');
                    return Row(
                      children: const [
                        Expanded(
                          child: _InfoCard(
                            label: 'Airplane',
                            value: 'Cessna 172',
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _InfoCard(
                            label: 'Range',
                            value: '750 NM',
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Explanation
                Builder(
                  builder: (context) {
                    debugPrint('📝 [_InformationSection] Explanation card built');
                    return const _InfoCard(
                      label: 'Explanation',
                      value: 'Nezih Levent ve Ömer Bey dünyanın en iyi kaptan pilotlarıdır.',
                      isFullWidth: true,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.label,
    required this.value,
    this.isFullWidth = false,
  });

  final String label;
  final String value;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    debugPrint('🧾 [_InfoCard] build label="$label" fullWidth=$isFullWidth');

    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.cfiBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF667085),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.labelBlack,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('⭐ [_ReviewsSection] build started');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aircraft reviews',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.labelBlack,
            ),
          ),
          const SizedBox(height: 16),
          Builder(
            builder: (context) {
              debugPrint('🧩 [_ReviewsSection] ReviewCard(ivan) built');
              return const _ReviewCard(
                name: 'Ivan',
                date: 'May 21, 2022',
                rating: 5,
                review:
                'I flew 30 hours in this aircraft with my instructor. The owner is very attentive!',
              );
            },
          ),
          const SizedBox(height: 16),
          Builder(
            builder: (context) {
              debugPrint('🧩 [_ReviewsSection] ReviewCard(alexander) built');
              return const _ReviewCard(
                name: 'Alexander',
                date: 'May 21, 2022',
                rating: 5,
                review: '',
              );
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                debugPrint('📋 [_ReviewsSection] All reviews pressed');
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 13),
                side: const BorderSide(color: AppColors.labelBlack),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'All reviews',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.labelBlack,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.name,
    required this.date,
    required this.rating,
    required this.review,
  });

  final String name;
  final String date;
  final int rating;
  final String review;

  @override
  Widget build(BuildContext context) {
    debugPrint('🗣️ [_ReviewCard] build name="$name" rating=$rating reviewEmpty=${review.isEmpty}');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF475159).withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.cardLight,
                child: Icon(Icons.person, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.labelBlack,
                      ),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF82898F),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ...List.generate(rating, (index) {
                debugPrint('⭐ [_ReviewCard] Star built name="$name" index=$index');
                return const Icon(
                  Icons.star,
                  size: 12,
                  color: Color(0xFFFEC84B),
                );
              }),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.labelBlack,
                ),
              ),
            ],
          ),
          if (review.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              review,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF475467),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
