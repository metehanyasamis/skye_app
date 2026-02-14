import 'package:flutter/material.dart';
import 'package:skye_app/app/routes/app_routes.dart';
import 'package:skye_app/features/aircraft/aircraft_detail_screen.dart';
import 'package:skye_app/features/safety_pilot/safety_pilot_detail_screen.dart';
import 'package:skye_app/shared/models/aircraft_model.dart';
import 'package:skye_app/shared/models/pilot_model.dart';
import 'package:skye_app/shared/services/favorites_api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';
import 'package:skye_app/shared/widgets/aircraft_card.dart';
import 'package:skye_app/shared/widgets/cfi_card.dart';
import 'package:skye_app/shared/widgets/safety_pilot_card.dart';

/// Favorilerim - 3 tab: Favori CFI, Favori Aircraft, Favori Safety Pilot
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  static const routeName = '/profile/favorites';

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<PilotModel> _pilots = [];
  List<AircraftModel> _aircraft = [];
  List<PilotModel> _safetyPilots = [];
  bool _loadingPilots = true;
  bool _loadingAircraft = true;
  bool _loadingSafetyPilots = true;

  @override
  void initState() {
    super.initState();
    debugPrint('📂 [FavoritesScreen] initState()');
    _tabController = TabController(length: 3, vsync: this);
    _loadAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    _loadPilots();
    _loadAircraft();
    _loadSafetyPilots();
  }

  Future<void> _loadPilots() async {
    setState(() => _loadingPilots = true);
    try {
      final resp = await FavoritesApiService.instance.getFavorites(
        FavoritesApiService.typePilot,
      );
      if (mounted) {
        setState(() {
          _pilots = resp.pilots;
          _loadingPilots = false;
        });
        debugPrint('❤️ [FavoritesScreen] Loaded ${_pilots.length} favorite pilots');
      }
    } catch (e) {
      debugPrint('❌ [FavoritesScreen] Failed to load pilots: $e');
      if (mounted) setState(() => _loadingPilots = false);
    }
  }

  Future<void> _loadAircraft() async {
    setState(() => _loadingAircraft = true);
    try {
      final resp = await FavoritesApiService.instance.getFavorites(
        FavoritesApiService.typeAircraft,
      );
      if (mounted) {
        setState(() {
          _aircraft = resp.aircraft;
          _loadingAircraft = false;
        });
        debugPrint('❤️ [FavoritesScreen] Loaded ${_aircraft.length} favorite aircraft');
      }
    } catch (e) {
      debugPrint('❌ [FavoritesScreen] Failed to load aircraft: $e');
      if (mounted) setState(() => _loadingAircraft = false);
    }
  }

  Future<void> _loadSafetyPilots() async {
    setState(() => _loadingSafetyPilots = true);
    try {
      final resp = await FavoritesApiService.instance.getFavorites(
        FavoritesApiService.typeSafetyPilot,
      );
      if (mounted) {
        setState(() {
          _safetyPilots = resp.safetyPilots;
          _loadingSafetyPilots = false;
        });
        debugPrint('❤️ [FavoritesScreen] Loaded ${_safetyPilots.length} favorite safety pilots');
      }
    } catch (e) {
      debugPrint('❌ [FavoritesScreen] Failed to load safety pilots: $e');
      if (mounted) setState(() => _loadingSafetyPilots = false);
    }
  }

  Future<void> _toggleFavoritePilot(int pilotId) async {
    try {
      await FavoritesApiService.instance.toggleFavorite(
        FavoritesApiService.typePilot,
        pilotId,
      );
      if (mounted) {
        setState(() => _pilots = _pilots.where((p) => p.id != pilotId).toList());
      }
    } catch (e) {
      debugPrint('❌ [FavoritesScreen] Toggle pilot failed: $e');
    }
  }

  Future<void> _toggleFavoriteAircraft(int aircraftId) async {
    try {
      await FavoritesApiService.instance.toggleFavorite(
        FavoritesApiService.typeAircraft,
        aircraftId,
      );
      if (mounted) {
        setState(() => _aircraft = _aircraft.where((a) => a.id != aircraftId).toList());
      }
    } catch (e) {
      debugPrint('❌ [FavoritesScreen] Toggle aircraft failed: $e');
    }
  }

  Future<void> _toggleFavoriteSafetyPilot(int pilotId) async {
    try {
      await FavoritesApiService.instance.toggleFavorite(
        FavoritesApiService.typeSafetyPilot,
        pilotId,
      );
      if (mounted) {
        setState(() => _safetyPilots = _safetyPilots.where((p) => p.id != pilotId).toList());
      }
    } catch (e) {
      debugPrint('❌ [FavoritesScreen] Toggle safety pilot failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('📂 [FavoritesScreen] build()');
    SystemUIHelper.setLightStatusBar();

    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.labelBlack),
          onPressed: () {
            debugPrint('⬅️ [FavoritesScreen] Back pressed');
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Favorites',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.labelBlack,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.navy800,
          unselectedLabelColor: AppColors.textGray,
          indicatorColor: AppColors.navy800,
          tabAlignment: TabAlignment.start,
          onTap: (index) {
            debugPrint('📑 [FavoritesScreen] Tab tapped: $index');
          },
          tabs: const [
            Tab(text: 'Favorite CFI'),
            Tab(text: 'Favorite Aircraft'),
            Tab(text: 'Favorite Safety Pilot'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPilotsTab(),
          _buildAircraftTab(),
          _buildSafetyPilotsTab(),
        ],
      ),
    );
  }

  Widget _buildPilotsTab() {
    if (_loadingPilots) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_pilots.isEmpty) {
      return _buildEmptyState(
        icon: Icons.person_outline,
        title: 'Favorite CFI',
        subtitle: 'No favorite CFI added yet',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pilots.length,
      itemBuilder: (context, index) {
        final pilot = _pilots[index];
        return CfiCard(
          pilot: pilot,
          isFavorited: true,
          onFavoriteTap: () => _toggleFavoritePilot(pilot.id),
          onTap: () async {
            await Navigator.of(context).pushNamed(
              AppRoutes.cfiDetail,
              arguments: {
                'pilot': pilot,
                'isFavorited': true,
                'pilotType': FavoritesApiService.typePilot,
              },
            );
            if (mounted) _loadPilots();
          },
        );
      },
    );
  }

  Widget _buildAircraftTab() {
    if (_loadingAircraft) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_aircraft.isEmpty) {
      return _buildEmptyState(
        icon: Icons.flight,
        title: 'Favorite Aircraft',
        subtitle: 'No favorite aircraft added yet',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _aircraft.length,
      itemBuilder: (context, index) {
        final a = _aircraft[index];
        return AircraftCard.fromModel(
          a,
          isFavorited: true,
          onFavoriteTap: () => _toggleFavoriteAircraft(a.id),
          onTap: () async {
            await Navigator.of(context).pushNamed(
              AircraftDetailScreen.routeName,
              arguments: {'id': a.id, 'isFavorited': true},
            );
            if (mounted) _loadAircraft();
          },
        );
      },
    );
  }

  Widget _buildSafetyPilotsTab() {
    if (_loadingSafetyPilots) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_safetyPilots.isEmpty) {
      return _buildEmptyState(
        icon: Icons.person_outline,
        title: 'Favorite Safety Pilot',
        subtitle: 'No favorite Safety Pilot added yet',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _safetyPilots.length,
      itemBuilder: (context, index) {
        final pilot = _safetyPilots[index];
        return SafetyPilotCard.fromPilot(
          pilot,
          isFavorited: true,
          onFavoriteTap: () => _toggleFavoriteSafetyPilot(pilot.id),
          onTap: () async {
            await Navigator.of(context).pushNamed(
              SafetyPilotDetailScreen.routeName,
              arguments: {
                'pilot': pilot,
                'isFavorited': true,
                'pilotType': FavoritesApiService.typeSafetyPilot,
              },
            );
            if (mounted) _loadSafetyPilots();
          },
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: AppColors.textGray),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.labelBlack,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
