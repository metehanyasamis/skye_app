import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';

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

  @override
  void initState() {
    super.initState();
    debugPrint('📂 [FavoritesScreen] initState()');
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          _FavoritesTabContent(
            icon: Icons.person_outline,
            title: 'Favorite CFI',
            subtitle: 'No favorite CFI added yet',
          ),
          _FavoritesTabContent(
            icon: Icons.flight,
            title: 'Favorite Aircraft',
            subtitle: 'No favorite aircraft added yet',
          ),
          _FavoritesTabContent(
            icon: Icons.person_outline,
            title: 'Favorite Safety Pilot',
            subtitle: 'No favorite Safety Pilot added yet',
          ),
        ],
      ),
    );
  }
}

class _FavoritesTabContent extends StatelessWidget {
  const _FavoritesTabContent({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.textGray,
            ),
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
