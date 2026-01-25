import 'package:flutter/material.dart' hide FilterChip;
import 'package:skye_app/app/shell/tab_shell.dart';
import 'package:skye_app/features/cfi/cfi_detail_screen.dart';
import 'package:skye_app/features/cfi/create_cfi_profile_screen.dart';
import 'package:skye_app/features/cfi/cfi_post_screen.dart';
import 'package:skye_app/features/notifications/notifications_screen.dart';
import 'package:skye_app/shared/models/user_type.dart';
import 'package:skye_app/shared/services/user_type_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';
import 'package:skye_app/shared/widgets/common_header.dart';
import 'package:skye_app/shared/widgets/cfi_card.dart';
import 'package:skye_app/shared/widgets/filter_chip.dart';
import 'package:skye_app/shared/widgets/post_fab.dart';

class CfiListingScreen extends StatelessWidget {
  const CfiListingScreen({super.key});

  static const routeName = '/cfi/listing';

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('CfiListingScreen', 'build()');
    SystemUIHelper.setLightStatusBar();

    return TabShell(
      child: Stack(
        children: [
          Column(
            children: [
              CommonHeader(
                locationText: '1 World Wy...',
                onNotificationTap: () {
                  DebugLogger.log(
                    'CfiListingScreen',
                    'notification tapped',
                  );
                  Navigator.of(context).pushNamed(
                    NotificationsScreen.routeName,
                  );
                },
              ),
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
                style: const TextStyle(
                  color: AppColors.labelBlack,
                  fontSize: 14,
                ),
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
                  filled: true,
                  fillColor: AppColors.white,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
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

          // Section title - left aligned
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                textAlign: TextAlign.left,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.labelBlack,
                  ),
                  children: [
                    TextSpan(text: 'Top '),
                    TextSpan(
                      text: 'CFI\'s',
                      style: TextStyle(color: Color(0xFF007BA7)),
                    ),
                    TextSpan(text: ' around you'),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // CFI list – alt padding: son kart CustomBottomNavBar altında kalmasın
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 60 +
                    MediaQuery.of(context).viewPadding.bottom +
                    16,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                DebugLogger.log(
                  'CfiListingScreen',
                  'build card',
                  {'index': index},
                );

                return CfiCard(
                  name: 'Logan Hawke',
                  experience: '5000+ hours dual given',
                  instructorRatings: 'CFI, CFII',
                  licenses: 'CPL, IR',
                  languages: 'EN,FR',
                  location: 'NY, USA',
                  airport: 'FFL Airport',
                  hourlyRate: '50',
                  rating: '4.9',
                  onTap: () {
                    Navigator.of(context).pushNamed(CfiDetailScreen.routeName);
                  },
                );
              },
            ),
          ),
            ],
          ),
          ValueListenableBuilder<UserType>(
            valueListenable: UserTypeService.instance.userTypeNotifier,
            builder: (context, userType, _) {
              if (userType == UserType.safetyPilot) {
                return const SizedBox.shrink();
              }
              return Positioned(
                bottom: 76,
                right: 16,
                child: PostFab(
                  onTap: () {
                    if (userType == UserType.cfi) {
                      DebugLogger.log(
                        'CfiListingScreen',
                        'Post FAB tapped -> CfiPostScreen',
                      );
                      Navigator.of(context).pushNamed(
                        CfiPostScreen.routeName,
                      );
                    } else {
                      DebugLogger.log(
                        'CfiListingScreen',
                        'Post FAB tapped -> CreateCfiProfileScreen',
                      );
                      Navigator.of(context).pushNamed(
                        CreateCfiProfileScreen.routeName,
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

