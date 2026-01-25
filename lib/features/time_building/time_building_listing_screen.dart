import 'package:flutter/material.dart' hide FilterChip;
import 'package:skye_app/app/shell/tab_shell.dart';
import 'package:skye_app/features/notifications/notifications_screen.dart';
import 'package:skye_app/features/safety_pilot/create_safety_pilot_profile_screen.dart';
import 'package:skye_app/features/time_building/time_building_post_screen.dart';
import 'package:skye_app/shared/models/user_type.dart';
import 'package:skye_app/shared/services/user_type_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';
import 'package:skye_app/shared/widgets/common_header.dart';
import 'package:skye_app/shared/widgets/filter_chip.dart';
import 'package:skye_app/shared/widgets/post_fab.dart';
import 'package:skye_app/shared/widgets/safety_pilot_card.dart';
import 'package:skye_app/shared/widgets/section_title.dart';

class TimeBuildingListingScreen extends StatelessWidget {
  const TimeBuildingListingScreen({super.key});

  static const routeName = '/time-building/listing';

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('TimeBuildingListingScreen', 'build()');
    SystemUIHelper.setLightStatusBar();

    return TabShell(
      child: Stack(
        children: [
          Column(
            children: [
              CommonHeader(
                locationText: '1 World Wy...',
                showNotificationDot: true,
                onNotificationTap: () {
                  DebugLogger.log(
                    'TimeBuildingListingScreen',
                    'notification tapped',
                  );
                  Navigator.of(context).pushNamed(
                    NotificationsScreen.routeName,
                  );
                },
              ),
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
                        DebugLogger.log(
                          'TimeBuildingListingScreen',
                          'filter tapped',
                          {'filter': 'Rent/Buy'},
                        );
                      },
                    ),
                    const SizedBox(width: 7),
                    FilterChip(
                      label: 'Aircraft Brand',
                      icon: Icons.flight,
                      isSelected: false,
                      onTap: () {
                        DebugLogger.log(
                          'TimeBuildingListingScreen',
                          'filter tapped',
                          {'filter': 'Aircraft Brand'},
                        );
                      },
                    ),
                    const SizedBox(width: 7),
                    FilterChip(
                      label: 'Aircraft Type',
                      icon: Icons.flight_takeoff,
                      isSelected: false,
                      onTap: () {
                        DebugLogger.log(
                          'TimeBuildingListingScreen',
                          'filter tapped',
                          {'filter': 'Aircraft Type'},
                        );
                      },
                    ),
                    const SizedBox(width: 7),
                    FilterChip(
                      label: 'State',
                      icon: Icons.public,
                      isSelected: false,
                      onTap: () {
                        DebugLogger.log(
                          'TimeBuildingListingScreen',
                          'filter tapped',
                          {'filter': 'State'},
                        );
                      },
                    ),
                    const SizedBox(width: 7),
                    FilterChip(
                      label: 'City',
                      icon: Icons.location_city,
                      isSelected: false,
                      onTap: () {
                        DebugLogger.log(
                          'TimeBuildingListingScreen',
                          'filter tapped',
                          {'filter': 'City'},
                        );
                      },
                    ),
                    const SizedBox(width: 7),
                    FilterChip(
                      label: 'Airport',
                      icon: Icons.flight_takeoff,
                      isSelected: false,
                      onTap: () {
                        DebugLogger.log(
                          'TimeBuildingListingScreen',
                          'filter tapped',
                          {'filter': 'Airport'},
                        );
                      },
                    ),
                    const SizedBox(width: 7),
                    FilterChip(
                      label: 'Price',
                      icon: Icons.attach_money,
                      isSelected: false,
                      onTap: () {
                        DebugLogger.log(
                          'TimeBuildingListingScreen',
                          'filter tapped',
                          {'filter': 'Price'},
                        );
                      },
                    ),
                ],
              ),
            ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const SectionTitle(
                      prefix: 'Top ',
                      highlighted: 'safety pilots',
                      suffix: ' around you',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 60 +
                        MediaQuery.of(context).viewPadding.bottom +
                        16,
                  ),
                  children: const [
                    SafetyPilotCard(
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
          ValueListenableBuilder<UserType>(
            valueListenable: UserTypeService.instance.userTypeNotifier,
            builder: (context, userType, _) {
              if (userType == UserType.cfi) {
                return const SizedBox.shrink();
              }
              return Positioned(
                bottom: 76,
                right: 16,
                child: PostFab(
                  onTap: () {
                    if (userType == UserType.safetyPilot) {
                      DebugLogger.log(
                        'TimeBuildingListingScreen',
                        'Post FAB tapped -> TimeBuildingPostScreen',
                      );
                      Navigator.of(context).pushNamed(
                        TimeBuildingPostScreen.routeName,
                      );
                    } else {
                      DebugLogger.log(
                        'TimeBuildingListingScreen',
                        'Post FAB tapped -> CreateSafetyPilotProfileScreen',
                      );
                      Navigator.of(context).pushNamed(
                        CreateSafetyPilotProfileScreen.routeName,
                      );
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

