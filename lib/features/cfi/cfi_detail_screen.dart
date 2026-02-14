import 'package:flutter/material.dart';
import 'package:skye_app/features/cfi/pilot_detail_screen.dart';
import 'package:skye_app/shared/models/pilot_model.dart';
import 'package:skye_app/shared/services/favorites_api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';

/// CFI detay ekranı – GET /api/pilots/{id} endpoint’ini kullanır.
class CfiDetailScreen extends StatelessWidget {
  const CfiDetailScreen({super.key});

  static const routeName = '/cfi/detail';

  @override
  Widget build(BuildContext context) {
    debugPrint('🧑‍✈️ [CfiDetailScreen] build()');

    SystemUIHelper.setLightStatusBar();

    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final pilot = args?['pilot'] as PilotModel?;
    final pilotId = args?['pilotId'] ?? args?['applicationId'];
    final isFavorited = args?['isFavorited'] as bool? ?? false;
    final pilotType = args?['pilotType'] as String? ?? FavoritesApiService.typePilot;
    if (pilot != null) {
      return PilotDetailScreen(
        pilot: pilot,
        pilotType: pilotType,
        initialIsFavorited: isFavorited,
      );
    }
    if (pilotId != null) {
      final id = pilotId is int ? pilotId : int.tryParse(pilotId.toString());
      if (id != null) {
        return PilotDetailScreen(
          pilotId: id,
          pilotType: pilotType,
          initialIsFavorited: isFavorited,
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColors.cfiBackground,
      body: SafeArea(
        top: true,
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.labelBlack),
                      onPressed: () {
                        debugPrint('⬅️ [CfiDetailScreen] Back pressed -> pop()');
                        Navigator.of(context).pop();
                      },
                      style: IconButton.styleFrom(
                        minimumSize: const Size(44, 44),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_border, color: AppColors.labelBlack),
                      onPressed: () {
                        debugPrint('❤️ [CfiDetailScreen] Favorite pressed');
                      },
                      style: IconButton.styleFrom(
                        minimumSize: const Size(44, 44),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 8),

            // Profile picture
            Builder(
              builder: (context) {
                debugPrint('🖼️ [CfiDetailScreen] Profile picture built');
                return Stack(
                  children: [
                    Container(
                      width: 135,
                      height: 135,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                      child: const CircleAvatar(
                        backgroundColor: AppColors.cardLight,
                        child: Icon(
                          Icons.person,
                          size: 80,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 16,
                          color: AppColors.labelBlack,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            // Name
            Builder(
              builder: (context) {
                debugPrint('👤 [CfiDetailScreen] Name built');
                return const Text(
                  'Pelin Doğrul L.R Riberio',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.labelBlack,
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // Badges
            Builder(
              builder: (context) {
                debugPrint('🏷️ [CfiDetailScreen] Badges built');
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      _Badge(icon: Icons.star, text: '4.9'),
                      SizedBox(width: 8),
                      _Badge(icon: Icons.share, text: 'Ny'),
                      SizedBox(width: 8),
                      _Badge(icon: Icons.check_circle, text: 'Aircraft'),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Contact buttons
            Builder(
              builder: (context) {
                debugPrint('📞 [CfiDetailScreen] Contact buttons built');
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ContactButton(
                      icon: Icons.chat,
                      color: const Color(0xFF25D366),
                      onPressed: () {
                        debugPrint('💬 [CfiDetailScreen] WhatsApp button pressed');
                      },
                    ),
                    const SizedBox(width: 8),
                    _ContactButton(
                      icon: Icons.phone,
                      color: AppColors.blue500,
                      onPressed: () {
                        debugPrint('📞 [CfiDetailScreen] Phone button pressed');
                      },
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // Information section
            Builder(
              builder: (context) {
                debugPrint('ℹ️ [CfiDetailScreen] Information section built');
                return _InformationSection();
              },
            ),

            const SizedBox(height: 24),

            // Availability section
            Builder(
              builder: (context) {
                debugPrint('📅 [CfiDetailScreen] Availability section built');
                return _AvailabilitySection();
              },
            ),

            const SizedBox(height: 24),

            // Reviews section
            Builder(
              builder: (context) {
                debugPrint('⭐ [CfiDetailScreen] Reviews section built');
                return _ReviewsSection();
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    debugPrint('🏷️ [_Badge] build text="$text"');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.labelBlack),
          const SizedBox(width: 4),
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

class _ContactButton extends StatelessWidget {
  const _ContactButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    debugPrint('📞 [_ContactButton] build icon=$icon');

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.white),
        onPressed: onPressed,
      ),
    );
  }
}

class _InformationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('ℹ️ [_InformationSection] build');

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
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                // Profile info row
                Builder(
                  builder: (context) {
                    debugPrint('👤 [_InformationSection] Profile row built');
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
                                children: List.generate(5, (index) {
                                  debugPrint('⭐ [_InformationSection] Star built index=$index');
                                  return const Icon(
                                    Icons.star,
                                    size: 12,
                                    color: Color(0xFFFEC84B),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Licenses and Instructor Ratings
                const Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        label: 'Licenses',
                        value: 'PPL, CPL',
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _InfoCard(
                        label: 'Instructor Ratings',
                        value: 'CFI, CFII',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Experience
                const _InfoCard(
                  label: 'Experience',
                  value: '5000+ hours dual given, 13.000+ total flight',
                  isFullWidth: true,
                ),

                const SizedBox(height: 16),

                // Aircraft Type
                const _InfoCard(
                  label: 'Aircraft Type',
                  value: 'C172, PA-29, DA-40',
                  isFullWidth: true,
                ),

                const SizedBox(height: 16),

                // Rate and Location
                const Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        label: 'Rate (per hour)',
                        value: '250 \$',
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _InfoCard(
                        label: 'Location',
                        value: 'Ny, USA',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // About
                const _InfoCard(
                  label: 'About',
                  value: 'Buraya düz yazı gelecek',
                  isFullWidth: true,
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
    debugPrint('🧾 [_InfoCard] build label="$label"');

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

class _AvailabilitySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('📅 [_AvailabilitySection] build');

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
            'Availibility',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.labelBlack,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: Center(
              child: Text(
                'Calendar will be displayed here',
                style: TextStyle(
                  color: AppColors.textGray,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Contact buttons and Get Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ContactButton(
                icon: Icons.chat,
                color: const Color(0xFF25D366),
                onPressed: () {
                  debugPrint('💬 [_AvailabilitySection] WhatsApp button pressed');
                },
              ),
              const SizedBox(width: 8),
              _ContactButton(
                icon: Icons.phone,
                color: AppColors.blue500,
                onPressed: () {
                  debugPrint('📞 [_AvailabilitySection] Phone button pressed');
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                debugPrint('📍 [_AvailabilitySection] Get Location pressed');
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 13),
                side: const BorderSide(color: AppColors.labelBlack),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Get Location',
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

class _ReviewsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('⭐ [_ReviewsSection] build');

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
            'CFI reviews',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.labelBlack,
            ),
          ),
          const SizedBox(height: 20),
          const _ReviewCard(
            name: 'Ivan',
            date: 'May 21, 2022',
            rating: 5,
            review:
            'I flew 30 hours in this aircraft with my instructor. The owner is very attentive!',
          ),
          const SizedBox(height: 16),
          const _ReviewCard(
            name: 'Alexander',
            date: 'May 21, 2022',
            rating: 5,
            review: '',
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
            const SizedBox(height: 8),
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
