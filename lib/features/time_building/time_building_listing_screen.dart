import 'package:flutter/material.dart' hide FilterChip;
import 'package:skye_app/app/shell/tab_shell.dart';
import 'package:skye_app/features/notifications/notifications_screen.dart';
import 'package:skye_app/features/safety_pilot/create_safety_pilot_profile_screen.dart';
import 'package:skye_app/features/safety_pilot/safety_pilot_detail_screen.dart';
import 'package:skye_app/features/time_building/time_building_post_screen.dart';
import 'package:skye_app/features/aircraft/widgets/aircraft_filter_sheets.dart';
import 'package:skye_app/features/cfi/widgets/cfi_filter_sheets.dart';
import 'package:skye_app/shared/models/location_models.dart';
import 'package:skye_app/shared/models/pilot_model.dart';
import 'package:skye_app/shared/models/user_type.dart';
import 'package:skye_app/shared/services/favorites_api_service.dart';
import 'package:skye_app/shared/services/pilot_api_service.dart';
import 'package:skye_app/shared/services/user_address_service.dart';
import 'package:skye_app/shared/services/user_type_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';
import 'package:skye_app/shared/widgets/common_header.dart';
import 'package:skye_app/shared/widgets/filter_chip.dart';
import 'package:skye_app/shared/widgets/post_fab.dart';
import 'package:skye_app/shared/widgets/safety_pilot_card.dart';

class TimeBuildingListingScreen extends StatefulWidget {
  const TimeBuildingListingScreen({super.key});

  static const routeName = '/time-building/listing';

  @override
  State<TimeBuildingListingScreen> createState() =>
      _TimeBuildingListingScreenState();
}

class _TimeBuildingListingScreenState extends State<TimeBuildingListingScreen> {
  List<PilotModel> _safetyPilots = [];
  bool _isLoadingPilots = true;
  String? _pilotError;
  Set<int> _favoritedSafetyPilotIds = {};

  String? _aircraftType;
  String? _locationState;
  String? _locationCity;
  String? _locationAirport;
  StateModel? _filterStateModel;
  CityModel? _filterCityModel;
  double? _minPrice;
  double? _maxPrice;
  String? _sort;

  List<PilotModel> get _filteredPilots {
    var list = _safetyPilots;
    if (_aircraftType != null && _aircraftType!.trim().isNotEmpty) {
      final term = _aircraftType!.trim().toLowerCase();
      list = list.where((p) {
        return p.pilotProfile?.aircraftExperiences
                .any((e) => e.aircraftType.toLowerCase().contains(term)) ??
            false;
      }).toList();
    }
    if (_locationState != null && _locationState!.trim().isNotEmpty) {
      final term = _locationState!.trim().toLowerCase();
      list = list.where((p) => p.pilotProfile?.location?.toLowerCase().contains(term) ?? false).toList();
    }
    if (_locationCity != null && _locationCity!.trim().isNotEmpty) {
      final term = _locationCity!.trim().toLowerCase();
      list = list.where((p) => p.pilotProfile?.location?.toLowerCase().contains(term) ?? false).toList();
    }
    if (_locationAirport != null && _locationAirport!.trim().isNotEmpty) {
      final term = _locationAirport!.trim().toLowerCase();
      list = list.where((p) => p.pilotProfile?.location?.toLowerCase().contains(term) ?? false).toList();
    }
    if (_minPrice != null || _maxPrice != null) {
      list = list.where((p) {
        final rate = p.pilotProfile?.hourlyRate;
        if (rate == null) return _minPrice == null;
        if (_minPrice != null && rate < _minPrice!) return false;
        if (_maxPrice != null && rate > _maxPrice!) return false;
        return true;
      }).toList();
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    _loadSafetyPilots();
  }

  Future<void> _loadSafetyPilots() async {
    setState(() {
      _isLoadingPilots = true;
      _pilotError = null;
    });

    final locationParts = [
      _locationState,
      _locationCity,
      _locationAirport,
    ].whereType<String>().where((s) => s.trim().isNotEmpty).map((s) => s.trim()).toList();
    final location = locationParts.isNotEmpty
        ? locationParts.join(', ')
        : (UserAddressService.instance.address.trim().isNotEmpty
            ? UserAddressService.instance.address.trim()
            : null);

    try {
      debugPrint('📍 [TimeBuildingListingScreen] _loadSafetyPilots location=$location');
      // GET /api/pilots – pilot_type=safety_pilot, status=approved
      final response = await PilotApiService.instance.getPilots(
        page: 1,
        perPage: 50,
        pilotType: 'safety_pilot',
        status: 'approved',
        location: location,
      );
      if (mounted) {
        setState(() {
          _safetyPilots = response.data;
          _isLoadingPilots = false;
        });
        debugPrint('✅ [TimeBuildingListingScreen] Loaded ${_safetyPilots.length} safety pilots');
        _loadFavorites();
      }
    } catch (e) {
      debugPrint('❌ [TimeBuildingListingScreen] Failed to load safety pilots: $e');
      if (mounted) {
        setState(() {
          _isLoadingPilots = false;
          _pilotError = 'Failed to load safety pilots';
          _safetyPilots = [];
        });
      }
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final resp = await FavoritesApiService.instance.getFavorites(
        FavoritesApiService.typeSafetyPilot,
      );
      if (mounted) {
        setState(() => _favoritedSafetyPilotIds = resp.safetyPilotIds);
        debugPrint('❤️ [TimeBuildingListingScreen] Loaded ${_favoritedSafetyPilotIds.length} favorites');
      }
    } catch (e) {
      debugPrint('⚠️ [TimeBuildingListingScreen] Failed to load favorites: $e');
    }
  }

  Future<void> _toggleFavorite(int pilotId) async {
    try {
      final result = await FavoritesApiService.instance.toggleFavorite(
        FavoritesApiService.typeSafetyPilot,
        pilotId,
      );
      if (mounted) {
        setState(() {
          if (result.isFavorited) {
            _favoritedSafetyPilotIds.add(pilotId);
          } else {
            _favoritedSafetyPilotIds.remove(pilotId);
          }
        });
        debugPrint('❤️ [TimeBuildingListingScreen] Toggle favorite pilotId=$pilotId -> ${result.isFavorited}');
      }
    } catch (e) {
      debugPrint('❌ [TimeBuildingListingScreen] Toggle favorite failed: $e');
    }
  }

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
                        'TimeBuildingListingScreen',
                        'search changed',
                        {'query': value},
                      );
                    },
                    onSubmitted: (value) {
                      DebugLogger.log(
                        'TimeBuildingListingScreen',
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
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    FilterChip(
                      label: 'Aircraft Type',
                      icon: Icons.airplanemode_active,
                      isSelected: _aircraftType != null && _aircraftType!.isNotEmpty,
                      onTap: () {
                        if (_aircraftType != null && _aircraftType!.isNotEmpty) {
                          debugPrint('✅ [TimeBuildingListingScreen] Aircraft Type chip tapped while selected -> clear filter');
                          setState(() => _aircraftType = null);
                          return;
                        }
                        showCfiAircraftTypeSheet(
                          context,
                          currentValue: _aircraftType,
                          onApply: (v) => setState(() => _aircraftType = v),
                        );
                      },
                    ),
                    const SizedBox(width: 7),
                    FilterChip(
                      label: 'State',
                      icon: Icons.public,
                      isSelected: _locationState != null && _locationState!.isNotEmpty,
                      onTap: () {
                        if (_locationState != null && _locationState!.isNotEmpty) {
                          debugPrint('✅ [TimeBuildingListingScreen] State chip tapped while selected -> clear filter');
                          setState(() {
                            _locationState = null;
                            _filterStateModel = null;
                            _locationCity = null;
                            _filterCityModel = null;
                          });
                          _loadSafetyPilots();
                          return;
                        }
                        showStateSheet(
                          context,
                          currentValue: _locationState,
                          selectedState: _filterStateModel,
                          onApply: (v, model) {
                            setState(() {
                              _locationState = v;
                              _filterStateModel = model;
                              _locationCity = null;
                              _filterCityModel = null;
                            });
                            _loadSafetyPilots();
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 7),
                    FilterChip(
                      label: 'City',
                      icon: Icons.location_city,
                      isSelected: _locationCity != null && _locationCity!.isNotEmpty,
                      onTap: () {
                        if (_locationCity != null && _locationCity!.isNotEmpty) {
                          debugPrint('✅ [TimeBuildingListingScreen] City chip tapped while selected -> clear filter');
                          setState(() {
                            _locationCity = null;
                            _filterCityModel = null;
                          });
                          _loadSafetyPilots();
                          return;
                        }
                        showCitySheet(
                          context,
                          stateId: _filterStateModel?.id,
                          currentValue: _locationCity,
                          selectedCity: _filterCityModel,
                          onApply: (v, model) {
                            setState(() {
                              _locationCity = v;
                              _filterCityModel = model;
                            });
                            _loadSafetyPilots();
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 7),
                    FilterChip(
                      label: 'Airport',
                      icon: Icons.flight_takeoff,
                      isSelected: _locationAirport != null && _locationAirport!.isNotEmpty,
                      onTap: () {
                        if (_locationAirport != null && _locationAirport!.isNotEmpty) {
                          debugPrint('✅ [TimeBuildingListingScreen] Airport chip tapped while selected -> clear filter');
                          setState(() => _locationAirport = null);
                          _loadSafetyPilots();
                          return;
                        }
                        showAirportSheet(
                          context,
                          currentValue: _locationAirport,
                          cityId: _filterCityModel?.id,
                          onApply: (v) {
                            setState(() => _locationAirport = v);
                            _loadSafetyPilots();
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 7),
                    FilterChip(
                      label: 'Price',
                      icon: Icons.attach_money,
                      isSelected: _minPrice != null || _maxPrice != null || _sort != null,
                      onTap: () {
                        if (_minPrice != null || _maxPrice != null || _sort != null) {
                          debugPrint('✅ [TimeBuildingListingScreen] Price chip tapped while selected -> clear filter');
                          setState(() {
                            _minPrice = null;
                            _maxPrice = null;
                            _sort = null;
                          });
                          return;
                        }
                        showPriceSheet(
                          context,
                          minPrice: _minPrice,
                          maxPrice: _maxPrice,
                          currentSort: _sort,
                          onApply: (min, max, sort) {
                            setState(() {
                              _minPrice = min;
                              _maxPrice = max;
                              _sort = sort;
                            });
                          },
                        );
                      },
                    ),
                  ],
              ),
            ),
              const SizedBox(height: 20),
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
                          text: 'safety pilots',
                          style: const TextStyle(color: AppColors.blueBright),
                        ),
                        TextSpan(text: ' around you'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoadingPilots
                    ? const Center(child: CircularProgressIndicator())
                    : _pilotError != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _pilotError!,
                                  style: const TextStyle(color: AppColors.textGray),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _loadSafetyPilots,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          )
                        : _safetyPilots.isEmpty
                            ? Center(
                                child: Text(
                                  'No safety pilots available',
                                  style: const TextStyle(color: AppColors.textGray),
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  bottom: 60 +
                                      MediaQuery.of(context).viewPadding.bottom +
                                      16,
                                ),
                                itemCount: _filteredPilots.length,
                                itemBuilder: (context, index) {
                                  final pilot = _filteredPilots[index];
                                  return Column(
                                    children: [
                                      SafetyPilotCard.fromPilot(
                                        pilot,
                                        isFavorited: _favoritedSafetyPilotIds.contains(pilot.id),
                                        onFavoriteTap: () => _toggleFavorite(pilot.id),
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                            SafetyPilotDetailScreen.routeName,
                                            arguments: {
                                              'pilot': pilot,
                                              'isFavorited': _favoritedSafetyPilotIds.contains(pilot.id),
                                              'pilotType': FavoritesApiService.typeSafetyPilot,
                                            },
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  );
                                },
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
                bottom: 48,
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

