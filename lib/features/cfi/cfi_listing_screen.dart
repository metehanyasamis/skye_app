import 'package:flutter/material.dart' hide FilterChip;
import 'package:skye_app/app/shell/tab_shell.dart';
import 'package:skye_app/features/cfi/cfi_detail_screen.dart';
import 'package:skye_app/features/cfi/cfi_form_data_holder.dart';
import 'package:skye_app/features/cfi/create_cfi_profile_screen.dart';
import 'package:skye_app/features/cfi/cfi_post_screen.dart';
import 'package:skye_app/features/cfi/widgets/cfi_filter_sheets.dart';
import 'package:skye_app/features/notifications/notifications_screen.dart';
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
import 'package:skye_app/shared/widgets/cfi_card.dart';
import 'package:skye_app/shared/widgets/filter_chip.dart';
import 'package:skye_app/shared/widgets/post_fab.dart';

class CfiListingScreen extends StatefulWidget {
  const CfiListingScreen({super.key});

  static const routeName = '/cfi/listing';

  @override
  State<CfiListingScreen> createState() => _CfiListingScreenState();
}

class _CfiListingScreenState extends State<CfiListingScreen> {
  List<PilotModel> _pilots = [];
  bool _isLoadingPilots = true;
  String? _pilotError;
  Set<int> _favoritedPilotIds = {};

  String? _aircraftType;
  String? _state;
  String? _city;
  String? _airport;
  StateModel? _filterStateModel;
  CityModel? _filterCityModel;
  DateTime? _date;
  bool? _aircraftOwnership;

  List<PilotModel> get _filteredPilots {
    var list = _pilots;
    if (_aircraftType != null && _aircraftType!.trim().isNotEmpty) {
      final term = _aircraftType!.trim().toLowerCase();
      list = list.where((p) {
        return p.pilotProfile?.aircraftExperiences
                .any((e) => e.aircraftType.toLowerCase().contains(term)) ??
            false;
      }).toList();
    }
    if (_state != null && _state!.trim().isNotEmpty) {
      final term = _state!.trim().toLowerCase();
      list = list.where((p) {
        return p.pilotProfile?.location?.toLowerCase().contains(term) ?? false;
      }).toList();
    }
    if (_city != null && _city!.trim().isNotEmpty) {
      final term = _city!.trim().toLowerCase();
      list = list.where((p) {
        return p.pilotProfile?.location?.toLowerCase().contains(term) ?? false;
      }).toList();
    }
    if (_airport != null && _airport!.trim().isNotEmpty) {
      final term = _airport!.trim().toLowerCase();
      list = list.where((p) {
        return p.pilotProfile?.location?.toLowerCase().contains(term) ?? false;
      }).toList();
    }
    if (_aircraftOwnership != null) {
      list = list.where((p) {
        return p.pilotProfile?.aircraftExperiences
                .any((e) => e.ownsAircraft == _aircraftOwnership) ??
            false;
      }).toList();
    }
    return list;
  }

  void _openAircraftTypeSheet() {
    if (_aircraftType != null && _aircraftType!.isNotEmpty) {
      debugPrint('✅ [CfiListingScreen] Aircraft Type chip tapped while selected -> clear filter');
      setState(() => _aircraftType = null);
      return;
    }
    showCfiAircraftTypeSheet(
      context,
      currentValue: _aircraftType,
      onApply: (v) => setState(() {
        _aircraftType = v;
      }),
    );
  }

  void _openStateSheet() {
    if (_state != null && _state!.isNotEmpty) {
      debugPrint('✅ [CfiListingScreen] State chip tapped while selected -> clear filter');
      setState(() {
        _state = null;
        _filterStateModel = null;
        _city = null;
        _filterCityModel = null;
      });
      _loadPilots();
      return;
    }
    showCfiStateSheet(
      context,
      currentValue: _state,
      selectedState: _filterStateModel,
      onApply: (v, model) {
        setState(() {
          _state = v;
          _filterStateModel = model;
          _city = null;
          _filterCityModel = null;
        });
        _loadPilots();
      },
    );
  }

  void _openCitySheet() {
    if (_city != null && _city!.isNotEmpty) {
      debugPrint('✅ [CfiListingScreen] City chip tapped while selected -> clear filter');
      setState(() {
        _city = null;
        _filterCityModel = null;
      });
      _loadPilots();
      return;
    }
    showCfiCitySheet(
      context,
      stateId: _filterStateModel?.id,
      currentValue: _city,
      selectedCity: _filterCityModel,
      onApply: (v, model) {
        setState(() {
          _city = v;
          _filterCityModel = model;
        });
        _loadPilots();
      },
    );
  }

  void _openAirportSheet() {
    if (_airport != null && _airport!.isNotEmpty) {
      debugPrint('✅ [CfiListingScreen] Airport chip tapped while selected -> clear filter');
      setState(() => _airport = null);
      _loadPilots();
      return;
    }
    showCfiAirportSheet(
      context,
      currentValue: _airport,
      cityId: _filterCityModel?.id,
      onApply: (v) {
        setState(() => _airport = v);
        _loadPilots();
      },
    );
  }

  void _openDateSheet() {
    if (_date != null) {
      debugPrint('✅ [CfiListingScreen] Date chip tapped while selected -> clear filter');
      setState(() => _date = null);
      return;
    }
    showCfiDateSheet(
      context,
      currentValue: _date,
      onApply: (v) => setState(() {
        _date = v;
      }),
    );
  }

  void _openAircraftOwnershipSheet() {
    if (_aircraftOwnership != null) {
      debugPrint('✅ [CfiListingScreen] Aircraft Ownership chip tapped while selected -> clear filter');
      setState(() => _aircraftOwnership = null);
      return;
    }
    showCfiAircraftOwnershipSheet(
      context,
      currentValue: _aircraftOwnership,
      onApply: (v) => setState(() {
        _aircraftOwnership = v;
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadPilots();
  }

  Future<void> _loadPilots() async {
    setState(() {
      _isLoadingPilots = true;
      _pilotError = null;
    });

    // Backend location filter: filter chips or user address
    final locationParts = [_state, _city, _airport]
        .whereType<String>()
        .where((s) => s.trim().isNotEmpty)
        .map((s) => s.trim())
        .toList();
    final location = locationParts.isNotEmpty
        ? locationParts.join(', ')
        : (UserAddressService.instance.address.trim().isNotEmpty
            ? UserAddressService.instance.address.trim()
            : null);

    try {
      debugPrint('📍 [CfiListingScreen] _loadPilots location=$location');
      // GET /api/pilots - onaylanan CFI pilotları (pilot_type=pilot, status=approved)
      final response = await PilotApiService.instance.getPilots(
        page: 1,
        perPage: 50,
        pilotType: 'pilot',
        status: 'approved',
        location: location,
      );
      if (mounted) {
        // Fallback client-side filter: sadece instructor_ratings olanları göster
        final instructors = response.data.where((pilot) => pilot.isInstructor).toList();
        setState(() {
          _pilots = instructors;
          _isLoadingPilots = false;
        });
        debugPrint('✅ [CfiListingScreen] Loaded ${_pilots.length} instructors');
        _loadFavorites();
      }
    } catch (e) {
      debugPrint('❌ [CfiListingScreen] Failed to load pilots: $e');
      if (mounted) {
        setState(() {
          _isLoadingPilots = false;
          _pilotError = 'Failed to load instructors';
          _pilots = [];
        });
      }
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final resp = await FavoritesApiService.instance.getFavorites(
        FavoritesApiService.typePilot,
      );
      if (mounted) {
        setState(() => _favoritedPilotIds = resp.pilotIds);
        debugPrint('❤️ [CfiListingScreen] Loaded ${_favoritedPilotIds.length} favorites');
      }
    } catch (e) {
      debugPrint('⚠️ [CfiListingScreen] Failed to load favorites: $e');
    }
  }

  Future<void> _toggleFavorite(int pilotId) async {
    try {
      final result = await FavoritesApiService.instance.toggleFavorite(
        FavoritesApiService.typePilot,
        pilotId,
      );
      if (mounted) {
        setState(() {
          if (result.isFavorited) {
            _favoritedPilotIds.add(pilotId);
          } else {
            _favoritedPilotIds.remove(pilotId);
          }
        });
        debugPrint('❤️ [CfiListingScreen] Toggle favorite pilotId=$pilotId -> ${result.isFavorited}');
      }
    } catch (e) {
      debugPrint('❌ [CfiListingScreen] Toggle favorite failed: $e');
    }
  }

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

          // Filter chips - Aircraft Type, State, City, Airport, Date, Aircraft Ownership
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                FilterChip(
                  label: 'Aircraft Type',
                  icon: Icons.airplanemode_active,
                  isSelected: _aircraftType != null && _aircraftType!.isNotEmpty,
                  onTap: _openAircraftTypeSheet,
                ),
                const SizedBox(width: 7),
                FilterChip(
                  label: 'State',
                  icon: Icons.public,
                  isSelected: _state != null && _state!.isNotEmpty,
                  onTap: _openStateSheet,
                ),
                const SizedBox(width: 7),
                FilterChip(
                  label: 'City',
                  icon: Icons.location_city,
                  isSelected: _city != null && _city!.isNotEmpty,
                  onTap: _openCitySheet,
                ),
                const SizedBox(width: 7),
                FilterChip(
                  label: 'Airport',
                  icon: Icons.flight_takeoff,
                  isSelected: _airport != null && _airport!.isNotEmpty,
                  onTap: _openAirportSheet,
                ),
                const SizedBox(width: 7),
                FilterChip(
                  label: 'Date',
                  icon: Icons.calendar_today,
                  isSelected: _date != null,
                  onTap: _openDateSheet,
                ),
                const SizedBox(width: 7),
                FilterChip(
                  label: 'Aircraft Ownership',
                  icon: Icons.public,
                  isSelected: _aircraftOwnership != null,
                  onTap: _openAircraftOwnershipSheet,
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
                      style: const TextStyle(color: AppColors.blueBright),
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
                              onPressed: _loadPilots,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                        : _filteredPilots.isEmpty
                        ? Center(
                            child: Text(
                              _pilots.isEmpty
                                  ? 'No instructors available'
                                  : 'No instructors match your filters',
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
                              DebugLogger.log(
                                'CfiListingScreen',
                                'build card',
                                {'index': index, 'pilotId': pilot.id},
                              );

                              return CfiCard(
                                pilot: pilot,
                                isFavorited: _favoritedPilotIds.contains(pilot.id),
                                onFavoriteTap: () => _toggleFavorite(pilot.id),
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    CfiDetailScreen.routeName,
                                    arguments: {
                                      'pilot': pilot,
                                      'isFavorited': _favoritedPilotIds.contains(pilot.id),
                                      'pilotType': FavoritesApiService.typePilot,
                                    },
                                  );
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
                bottom: 48,
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
                      CfiFormDataHolder.clear();
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

