import 'package:flutter/material.dart';

import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/widgets/custom_bottom_nav_bar.dart';

/// Tab route'ları (AppRoutes ile senkron tutulmalı).
abstract final class TabRoutes {
  TabRoutes._();
  static const String home = '/home';
  static const String cfiListing = '/cfi/listing';
  static const String aircraftListing = '/aircraft/listing';
  static const String timeBuildingListing = '/time-building/listing';
  static const String profile = '/profile';
}

/// Tab bar nav öğeleri. Harici yönetim için tek kaynak.
List<NavItemConfig> get tabNavItems => [
      const NavItemConfig(
        label: 'Home',
        route: TabRoutes.home,
        icon: 'assets/icons/nav_home.png',
      ),
      const NavItemConfig(
        label: 'CFI',
        route: TabRoutes.cfiListing,
        icon: 'assets/icons/nav_cfi.png',
      ),
      const NavItemConfig(
        label: 'Aircraft',
        route: TabRoutes.aircraftListing,
        icon: 'assets/icons/nav_aircraft.png',
      ),
      const NavItemConfig(
        label: 'Time',
        route: TabRoutes.timeBuildingListing,
        icon: 'assets/icons/nav_time.png',
      ),
      const NavItemConfig(
        label: 'Profile',
        route: TabRoutes.profile,
        icon: 'assets/icons/nav_profile.png',
      ),
    ];

/// Tab bar + ortak scaffold yapısı. Tab ekranları [child] ile sarılır.
class TabShell extends StatelessWidget {
  const TabShell({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.cfiBackground,
      body: child,
      bottomNavigationBar: CustomBottomNavBar(items: tabNavItems),
    );
  }
}
