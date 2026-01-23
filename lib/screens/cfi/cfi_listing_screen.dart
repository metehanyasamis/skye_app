import 'package:flutter/material.dart' hide FilterChip;
import 'package:skye_app/screens/notifications/notifications_screen.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/utils/debug_logger.dart';
import 'package:skye_app/utils/system_ui_helper.dart';
import 'package:skye_app/widgets/common_header.dart';
import 'package:skye_app/widgets/custom_bottom_nav_bar.dart';
import 'package:skye_app/widgets/filter_chip.dart';
import 'package:skye_app/widgets/section_title.dart';

class CfiListingScreen extends StatelessWidget {
  const CfiListingScreen({super.key});

  static const routeName = '/cfi/listing';

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('CfiListingScreen', 'build()');
    SystemUIHelper.setLightStatusBar();

    return Scaffold(
      backgroundColor: AppColors.cfiBackground,
      body: Column(
        children: [
          // Top header
          CommonHeader(
            locationText: '1 World Wy...',
            onNotificationTap: () {
              DebugLogger.log('CfiListingScreen', 'notification tapped');
              Navigator.of(context).pushNamed(NotificationsScreen.routeName);
            },
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                onChanged: (v) {
                  DebugLogger.log(
                    'CfiListingScreen',
                    'search changed',
                    {'query': v},
                  );
                },
                onSubmitted: (v) {
                  DebugLogger.log(
                    'CfiListingScreen',
                    'search submitted',
                    {'query': v},
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Find by name, city, airport',
                  hintStyle: TextStyle(
                    color: AppColors.labelBlack.withValues(alpha: 0.52),
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                    size: 24,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Filter chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                FilterChip(
                  label: 'Aircraft Brand',
                  icon: Icons.flight,
                  isSelected: true,
                  onTap: () {
                    DebugLogger.log('CfiListingScreen', 'filter tapped', {
                      'filter': 'Aircraft Brand',
                    });
                  },
                ),
                const SizedBox(width: 7),
                FilterChip(
                  label: 'Aircraft Type',
                  icon: Icons.airplanemode_active,
                  isSelected: true,
                  onTap: () {
                    DebugLogger.log('CfiListingScreen', 'filter tapped', {
                      'filter': 'Aircraft Type',
                    });
                  },
                ),
                const SizedBox(width: 7),
                FilterChip(
                  label: 'State',
                  icon: Icons.public,
                  isSelected: false,
                  onTap: () {
                    DebugLogger.log('CfiListingScreen', 'filter tapped', {
                      'filter': 'State',
                    });
                  },
                ),
                const SizedBox(width: 7),
                FilterChip(
                  label: 'City',
                  icon: Icons.location_city,
                  isSelected: false,
                  onTap: () {
                    DebugLogger.log('CfiListingScreen', 'filter tapped', {
                      'filter': 'City',
                    });
                  },
                ),
                const SizedBox(width: 7),
                FilterChip(
                  label: 'Airport',
                  icon: Icons.flight_takeoff,
                  isSelected: false,
                  onTap: () {
                    DebugLogger.log('CfiListingScreen', 'filter tapped', {
                      'filter': 'Airport',
                    });
                  },
                ),
                const SizedBox(width: 7),
                FilterChip(
                  label: 'Date',
                  icon: Icons.calendar_today,
                  isSelected: false,
                  onTap: () {
                    DebugLogger.log('CfiListingScreen', 'filter tapped', {
                      'filter': 'Date',
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Section title
          const SectionTitle(
            prefix: 'Top ',
            highlighted: 'CFI\'s',
            suffix: ' around you',
          ),

          const SizedBox(height: 12),

          // CFI list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 4,
              itemBuilder: (context, index) {
                DebugLogger.log(
                  'CfiListingScreen',
                  'build card',
                  {'index': index},
                );

                return const _CfiCard(
                  name: 'Logan Hawke',
                  experience: '5000+ hours dual given',
                  instructorRatings: 'CFI, CFII',
                  licenses: 'CPL, IR',
                  languages: 'EN,FR',
                  location: 'NY, USA',
                  airport: 'FFL Airport',
                  hourlyRate: '50',
                  rating: '4.9',
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}

class _CfiCard extends StatelessWidget {
  const _CfiCard({
    required this.name,
    required this.experience,
    required this.instructorRatings,
    required this.licenses,
    required this.languages,
    required this.location,
    required this.airport,
    required this.hourlyRate,
    required this.rating,
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

  @override
  Widget build(BuildContext context) {
    debugPrint('👨‍✈️ [_CfiCard] build name="$name" airport="$airport"');

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          DebugLogger.log('CfiCard', 'tapped', {'name': name});
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile picture
            Container(
              width: 164,
              height: 154,
              decoration: const BoxDecoration(
                color: AppColors.cardLight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Stack(
                children: [
                  // Placeholder for profile image
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                      color: AppColors.borderLight,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  // Aircraft badge
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 10,
                            color: AppColors.labelBlack,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Aircraft',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.labelBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.labelBlack,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.favorite_border, size: 20),
                          onPressed: () {
                            DebugLogger.log(
                              'CfiCard',
                              'favorite tapped',
                              {'name': name},
                            );
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      experience,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      instructorRatings,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      licenses,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      languages,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      airport,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Rating badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                size: 12,
                                color: AppColors.labelBlack,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                rating,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.labelBlack,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Hourly rate
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.labelBlack,
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
    );
  }
}
