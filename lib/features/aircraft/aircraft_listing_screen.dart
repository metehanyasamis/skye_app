import 'dart:async';

import 'package:flutter/material.dart' hide FilterChip;
import 'package:skye_app/app/shell/tab_shell.dart';
import 'package:skye_app/features/aircraft/aircraft_detail_screen.dart';
import 'package:skye_app/features/aircraft/aircraft_post_screen.dart';
import 'package:skye_app/features/aircraft/widgets/aircraft_filter_sheets.dart';
import 'package:skye_app/features/notifications/notifications_screen.dart';
import 'package:skye_app/shared/models/aircraft_model.dart';
import 'package:skye_app/shared/models/location_models.dart';
import 'package:skye_app/shared/services/aircraft_api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';
import 'package:skye_app/shared/widgets/aircraft_card.dart';
import 'package:skye_app/shared/widgets/common_header.dart';
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

  String? _searchQuery;
  Timer? _searchDebounce;
  final _searchController = TextEditingController();

  String? _type;
  int? _aircraftTypeId;
  String? _locationState;
  String? _locationCity;
  String? _locationAirport;
  StateModel? _filterStateModel;
  CityModel? _filterCityModel;
  double? _minPrice;
  double? _maxPrice;
  String? _sort; // 'price_asc' | 'price_desc'

  @override
  void initState() {
    super.initState();
    _loadAircrafts();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() {
        _searchQuery = value.trim().isEmpty ? null : value.trim();
        _loadAircrafts();
      });
    });
  }

  void _openRentBuySheet() {
    if (_type != null) {
      debugPrint('✅ [AircraftListingScreen] Rent/Buy chip tapped while selected -> clear filter');
      setState(() {
        _type = null;
        _loadAircrafts();
      });
      return;
    }
    showRentBuySheet(
      context,
      currentType: _type,
      onApply: (type) {
        setState(() {
          _type = type;
          _loadAircrafts();
        });
      },
    );
  }

  void _openAircraftTypeSheet() {
    if (_aircraftTypeId != null) {
      debugPrint('✅ [AircraftListingScreen] Aircraft Type chip tapped while selected -> clear filter');
      setState(() {
        _aircraftTypeId = null;
        _loadAircrafts();
      });
      return;
    }
    showAircraftTypeSheet(
      context,
      currentId: _aircraftTypeId,
      onApply: (id) {
        setState(() {
          _aircraftTypeId = id;
          _loadAircrafts();
        });
      },
    );
  }

  void _openStateSheet() {
    if (_locationState != null && _locationState!.isNotEmpty) {
      debugPrint('✅ [AircraftListingScreen] State chip tapped while selected -> clear filter');
      setState(() {
        _locationState = null;
        _filterStateModel = null;
        _locationCity = null;
        _filterCityModel = null;
        _loadAircrafts();
      });
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
          _loadAircrafts();
        });
      },
    );
  }

  void _openCitySheet() {
    if (_locationCity != null && _locationCity!.isNotEmpty) {
      debugPrint('✅ [AircraftListingScreen] City chip tapped while selected -> clear filter');
      setState(() {
        _locationCity = null;
        _filterCityModel = null;
        _loadAircrafts();
      });
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
          _loadAircrafts();
        });
      },
    );
  }

  void _openAirportSheet() {
    if (_locationAirport != null && _locationAirport!.isNotEmpty) {
      debugPrint('✅ [AircraftListingScreen] Airport chip tapped while selected -> clear filter');
      setState(() {
        _locationAirport = null;
        _loadAircrafts();
      });
      return;
    }
    showAirportSheet(
      context,
      currentValue: _locationAirport,
      cityId: _filterCityModel?.id,
      onApply: (v) {
        setState(() {
          _locationAirport = v;
          _loadAircrafts();
        });
      },
    );
  }

  void _openPriceSheet() {
    if (_minPrice != null || _maxPrice != null || _sort != null) {
      debugPrint('✅ [AircraftListingScreen] Price chip tapped while selected -> clear filter');
      setState(() {
        _minPrice = null;
        _maxPrice = null;
        _sort = null;
        _loadAircrafts();
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
          _loadAircrafts();
        });
      },
    );
  }

  static double _effectivePrice(AircraftModel a) {
    if (a.price != null) return a.price!;
    if (a.wetPrice != null && a.dryPrice != null) {
      return a.wetPrice! < a.dryPrice! ? a.wetPrice! : a.dryPrice!;
    }
    if (a.wetPrice != null) return a.wetPrice!;
    if (a.dryPrice != null) return a.dryPrice!;
    return double.infinity;
  }

  Future<void> _loadAircrafts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final locationParts = [
      _locationState,
      _locationCity,
      _locationAirport,
    ].whereType<String>().where((s) => s.trim().isNotEmpty).map((s) => s.trim()).toList();
    final location = locationParts.isEmpty ? null : locationParts.join(', ');

    try {
      final response = await AircraftApiService.instance.getAircraftListings(
        search: _searchQuery,
        type: _type,
        aircraftTypeId: _aircraftTypeId,
        location: location,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        sort: _sort,
        perPage: 30,
      );
      var list = response.data;
      if (_sort == 'price_asc') {
        list = List<AircraftModel>.from(list)
          ..sort((a, b) => _effectivePrice(a).compareTo(_effectivePrice(b)));
      } else if (_sort == 'price_desc') {
        list = List<AircraftModel>.from(list)
          ..sort((a, b) => _effectivePrice(b).compareTo(_effectivePrice(a)));
      }
      if (mounted) {
        setState(() {
          _aircrafts = list;
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
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    onSubmitted: (_) {
                      setState(() {
                        _searchQuery = _searchController.text.trim().isEmpty
                            ? null
                            : _searchController.text.trim();
                      });
                      _loadAircrafts();
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
                      isSelected: _type != null,
                      onTap: _openRentBuySheet,
                    ),
                    const SizedBox(width: 7),
                    FilterChip(
                      label: 'Aircraft Type',
                      icon: Icons.airplanemode_active,
                      isSelected: _aircraftTypeId != null,
                      onTap: _openAircraftTypeSheet,
                    ),
                    const SizedBox(width: 7),
                    FilterChip(
                      label: 'State',
                      icon: Icons.public,
                      isSelected: _locationState != null && _locationState!.isNotEmpty,
                      onTap: _openStateSheet,
                    ),
                    const SizedBox(width: 7),
                    FilterChip(
                      label: 'City',
                      icon: Icons.location_city,
                      isSelected: _locationCity != null && _locationCity!.isNotEmpty,
                      onTap: _openCitySheet,
                    ),
                    const SizedBox(width: 7),
                    FilterChip(
                      label: 'Airport',
                      icon: Icons.flight_takeoff,
                      isSelected: _locationAirport != null && _locationAirport!.isNotEmpty,
                      onTap: _openAirportSheet,
                    ),
                    const SizedBox(width: 7),
                    FilterChip(
                      label: 'Price',
                      icon: Icons.local_offer,
                      isSelected: _minPrice != null || _maxPrice != null || _sort != null,
                      onTap: _openPriceSheet,
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
                              onPressed: _loadAircrafts,
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
                              return AircraftCard.fromModel(
                                aircraft,
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    AircraftDetailScreen.routeName,
                                    arguments: aircraft.id,
                                  );
                                },
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

