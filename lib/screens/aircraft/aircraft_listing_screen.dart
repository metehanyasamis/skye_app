import 'package:flutter/material.dart' hide FilterChip;
import 'package:skye_app/screens/notifications/notifications_screen.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/utils/debug_logger.dart';
import 'package:skye_app/utils/system_ui_helper.dart';
import 'package:skye_app/widgets/common_header.dart';
import 'package:skye_app/widgets/custom_bottom_nav_bar.dart';
import 'package:skye_app/widgets/filter_chip.dart';
import 'package:skye_app/widgets/section_title.dart';

class AircraftListingScreen extends StatelessWidget {
  const AircraftListingScreen({super.key});

  static const routeName = '/aircraft/listing';

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('AircraftListingScreen', 'build()');
    SystemUIHelper.setLightStatusBar();

    return Scaffold(
      backgroundColor: AppColors.cfiBackground,
      body: Column(
        children: [
          // Top header
          CommonHeader(
            locationText: '1 World Wy...',
            onNotificationTap: () {
              DebugLogger.log('AircraftListingScreen', 'notification tapped');
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
                onChanged: (value) {
                  DebugLogger.log(
                    'AircraftListingScreen',
                    'search changed',
                    {'query': value},
                  );
                },
                onSubmitted: (value) {
                  DebugLogger.log(
                    'AircraftListingScreen',
                    'search submitted',
                    {'query': value},
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Find Aircraft for Rent/Buy',
                  hintStyle: TextStyle(
                    color: AppColors.labelBlack.withValues(alpha: 0.28),
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.flight,
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
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                FilterChip(
                  label: 'Rent/Buy',
                  icon: Icons.attach_money,
                  isSelected: true,
                  onTap: () {
                    DebugLogger.log('AircraftListingScreen', 'filter tapped', {
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
                    DebugLogger.log('AircraftListingScreen', 'filter tapped', {
                      'filter': 'Aircraft Brand',
                    });
                  },
                ),
                const SizedBox(width: 7),
                FilterChip(
                  label: 'Aircraft Type',
                  icon: Icons.airplanemode_active,
                  isSelected: false,
                  onTap: () {
                    DebugLogger.log('AircraftListingScreen', 'filter tapped', {
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
                    DebugLogger.log('AircraftListingScreen', 'filter tapped', {
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
                    DebugLogger.log('AircraftListingScreen', 'filter tapped', {
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
                    DebugLogger.log('AircraftListingScreen', 'filter tapped', {
                      'filter': 'Airport',
                    });
                  },
                ),
                const SizedBox(width: 7),
                FilterChip(
                  label: 'Price',
                  icon: Icons.local_offer,
                  isSelected: false,
                  onTap: () {
                    DebugLogger.log('AircraftListingScreen', 'filter tapped', {
                      'filter': 'Price',
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
            highlighted: 'aircrafts',
            suffix: ' around you',
          ),

          const SizedBox(height: 12),

          // Aircraft list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 3,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    DebugLogger.log(
                      'AircraftListingScreen',
                      'aircraft card tapped',
                      {'index': index},
                    );
                  },
                  child: const _AircraftCard(
                    name: 'AeroVena',
                    range: '750 nm',
                    type: 'ASEL',
                    airport: 'KBNA',
                    seats: '4 Seats',
                    wetPrice: '200',
                    dryPrice: '100',
                  ),
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

class _AircraftCard extends StatelessWidget {
  const _AircraftCard({
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
    debugPrint('🛩️ [_AircraftCard] build name="$name" airport="$airport"');

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Aircraft image
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

          // Content
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
