import 'package:flutter/material.dart' hide FilterChip;
import 'package:skye_app/screens/notifications/notifications_screen.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/utils/debug_logger.dart';
import 'package:skye_app/utils/system_ui_helper.dart';
import 'package:skye_app/widgets/common_header.dart';
import 'package:skye_app/widgets/custom_bottom_nav_bar.dart';
import 'package:skye_app/widgets/filter_chip.dart';
import 'package:skye_app/widgets/section_title.dart';

class TimeBuildingListingScreen extends StatelessWidget {
  const TimeBuildingListingScreen({super.key});

  static const routeName = '/time-building/listing';

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('TimeBuildingListingScreen', 'build()');
    SystemUIHelper.setLightStatusBar();

    return Scaffold(
      backgroundColor: AppColors.cfiBackground,
      body: Column(
        children: [
          // Top header
          CommonHeader(
            locationText: '1 World Wy...',
            showNotificationDot: true,
            onNotificationTap: () {
              DebugLogger.log('TimeBuildingListingScreen', 'notification tapped');
              Navigator.of(context).pushNamed(NotificationsScreen.routeName);
            },
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    size: 24,
                    color: Color(0xFF222222),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Find Aircraft for Rent/Buy',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF222222).withValues(alpha: 0.28),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Filter chips
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                FilterChip(
                  label: 'Rent/Buy',
                  icon: Icons.shopping_cart,
                  isSelected: true,
                  onTap: () {
                    DebugLogger.log('TimeBuildingListingScreen', 'filter tapped', {
                      'filter': 'Rent/Buy',
                    });
                  },
                ),
                const SizedBox(width: 7),
                FilterChip(
                  label: 'Aircraft Brand',
                  icon: Icons.flight,
                  isSelected: false,
                  onTap: () {
                    DebugLogger.log('TimeBuildingListingScreen', 'filter tapped', {
                      'filter': 'Aircraft Brand',
                    });
                  },
                ),
                const SizedBox(width: 7),
                FilterChip(
                  label: 'Aircraft Type',
                  icon: Icons.flight_takeoff,
                  isSelected: false,
                  onTap: () {
                    DebugLogger.log('TimeBuildingListingScreen', 'filter tapped', {
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
                    DebugLogger.log('TimeBuildingListingScreen', 'filter tapped', {
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
                    DebugLogger.log('TimeBuildingListingScreen', 'filter tapped', {
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
                    DebugLogger.log('TimeBuildingListingScreen', 'filter tapped', {
                      'filter': 'Airport',
                    });
                  },
                ),
                const SizedBox(width: 7),
                FilterChip(
                  label: 'Price',
                  icon: Icons.attach_money,
                  isSelected: false,
                  onTap: () {
                    DebugLogger.log('TimeBuildingListingScreen', 'filter tapped', {
                      'filter': 'Price',
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Section title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const SectionTitle(
                  prefix: 'Top ',
                  highlighted: 'safety pilots',
                  suffix: ' around you',
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    DebugLogger.log(
                      'TimeBuildingListingScreen',
                      'favorite icon tapped',
                    );
                  },
                  child: const Icon(
                    Icons.favorite_border,
                    size: 20,
                    color: Color(0xFF011A44),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Content list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                _SafetyPilotCard(
                  name: 'Logan Hawke',
                  rating: 4.9,
                  languages: 'EN,FR',
                  hours: '5000+ hours dual given',
                  instructorRatings: 'CFI, CFII',
                  otherLicenses: 'CPL, IR',
                  location: 'NY, USA',
                  airport: 'FFL Airport',
                  price: 50,
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}

class _SafetyPilotCard extends StatelessWidget {
  const _SafetyPilotCard({
    required this.name,
    required this.rating,
    required this.languages,
    required this.hours,
    required this.instructorRatings,
    required this.otherLicenses,
    required this.location,
    required this.airport,
    required this.price,
  });

  final String name;
  final double rating;
  final String languages;
  final String hours;
  final String instructorRatings;
  final String otherLicenses;
  final String location;
  final String airport;
  final int price;

  @override
  Widget build(BuildContext context) {
    debugPrint('🧑‍✈️ [_SafetyPilotCard] build name="$name" airport="$airport"');

    return Container(
      height: 154,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile image
          Stack(
            children: [
              Container(
                width: 164,
                height: 154,
                decoration: const BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    size: 80,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              // Rating badge
              Positioned(
                bottom: 14,
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
              ),
            ],
          ),

          // Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
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
                            color: Color(0xFF353535),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          DebugLogger.log(
                            'SafetyPilotCard',
                            'favorite tapped',
                            {'name': name},
                          );
                        },
                        child: const Icon(
                          Icons.favorite_border,
                          size: 18,
                          color: Color(0xFF353535),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Languages
                  Row(
                    children: [
                      const Icon(
                        Icons.language,
                        size: 13,
                        color: Color(0xFF858585),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        languages,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF858585),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Hours
                  Text(
                    hours,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF858585),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Instructor ratings
                  Text(
                    instructorRatings,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF858585),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Other licenses
                  Text(
                    otherLicenses,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF858585),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Bottom row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Location and Airport
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 13,
                                color: Color(0xFF858585),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                location,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFF858585),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.flight_takeoff,
                                size: 13,
                                color: Color(0xFF858585),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                airport,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFF858585),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
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
                          const SizedBox(height: 8),

                          // Aircraft badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
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
                                  color: Colors.black,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Aircraft',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
