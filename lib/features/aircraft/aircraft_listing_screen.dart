import 'package:flutter/material.dart' hide FilterChip;
import 'package:skye_app/app/shell/tab_shell.dart';
import 'package:skye_app/features/aircraft/aircraft_detail_screen.dart';
import 'package:skye_app/features/aircraft/aircraft_post_screen.dart';
import 'package:skye_app/features/notifications/notifications_screen.dart';
import 'package:skye_app/shared/models/aircraft_model.dart';
import 'package:skye_app/shared/services/aircraft_api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';
import 'package:skye_app/shared/widgets/common_header.dart';
import 'package:skye_app/shared/widgets/aircraft_card.dart';
import 'package:skye_app/shared/widgets/filter_chip.dart';
import 'package:skye_app/shared/widgets/post_fab.dart';

class AircraftListingScreen extends StatefulWidget {
  const AircraftListingScreen({super.key});

  static const routeName = '/aircraft/listing';

  @override
  State<AircraftListingScreen> createState() => _AircraftListingScreenState();
}

class _AircraftListingScreenState extends State<AircraftListingScreen> {
  List<AircraftModel> _aircrafts = [];
  bool _isLoading = true;
  String? _error;
  String? _selectedType; // 'sale' or 'rental'

  @override
  void initState() {
    super.initState();
    _loadAircrafts();
  }

  Future<void> _loadAircrafts({String? type}) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _selectedType = type;
    });

    try {
      final response = await AircraftApiService.instance.getAircraftListings(
        type: type,
        perPage: 50,
      );
      if (mounted) {
        setState(() {
          _aircrafts = response.data;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ [AircraftListingScreen] Failed to load aircrafts: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to load aircrafts';
          _aircrafts = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('AircraftListingScreen', 'build()');
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
                    'AircraftListingScreen',
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
                    style: const TextStyle(
                      color: AppColors.labelBlack,
                      fontSize: 14,
                    ),
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
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    FilterChip(
                      label: 'Rent/Buy',
                      icon: Icons.attach_money,
                      isSelected: _selectedType == null,
                      onTap: () {
                        DebugLogger.log('AircraftListingScreen', 'filter tapped', {
                          'filter': 'Rent/Buy',
                        });
                        _loadAircrafts();
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

          // Section title - left aligned
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.labelBlack,
                  ),
                  children: [
                    TextSpan(text: 'Top '),
                    TextSpan(
                      text: 'aircrafts',
                      style: const TextStyle(color: AppColors.blueBright),
                    ),
                    TextSpan(text: ' around you'),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Aircraft list – alt padding: son kart CustomBottomNavBar altında kalmasın
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => _loadAircrafts(type: _selectedType),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _aircrafts.isEmpty
                        ? const Center(
                            child: Text('No aircrafts found'),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 60 +
                                  MediaQuery.of(context).viewPadding.bottom +
                                  16,
                            ),
                            itemCount: _aircrafts.length,
                            itemBuilder: (context, index) {
                              final aircraft = _aircrafts[index];
                              return GestureDetector(
                                onTap: () {
                                  DebugLogger.log(
                                    'AircraftListingScreen',
                                    'aircraft card tapped',
                                    {'id': aircraft.id, 'title': aircraft.title},
                                  );
                                  Navigator.of(context).pushNamed(
                                    AircraftDetailScreen.routeName,
                                    arguments: aircraft.id,
                                  );
                                },
                                child: AircraftCard.fromModel(aircraft),
                              );
                            },
                          ),
          ),
            ],
          ),
          Positioned(
            bottom: 76,
            right: 16,
            child: PostFab(
              onTap: () {
                DebugLogger.log(
                  'AircraftListingScreen',
                  'Post FAB tapped -> AircraftPostScreen',
                );
                Navigator.of(context).pushNamed(
                  AircraftPostScreen.routeName,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

