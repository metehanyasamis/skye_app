import 'package:flutter/material.dart';
import 'package:skye_app/app/shell/tab_shell.dart';
import 'package:skye_app/features/aircraft/aircraft_listing_screen.dart';
import 'package:skye_app/features/cfi/cfi_listing_screen.dart';
import 'package:skye_app/features/notifications/notifications_screen.dart';
import 'package:skye_app/features/time_building/time_building_listing_screen.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';
import 'package:skye_app/shared/widgets/common_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('HomeScreen', 'build()');
    SystemUIHelper.setLightStatusBar();

    return TabShell(
      child: Column(
        children: [
          // Top header - using CommonHeader widget
          CommonHeader(
            locationText: '1 World Wyndam...',
            showNotificationDot: true,
            onNotificationTap: () {
              DebugLogger.log('HomeScreen', 'notification tapped');
              Navigator.of(context).pushNamed(NotificationsScreen.routeName);
            },
          ),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // Main heading
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      children: [
                        TextSpan(
                          text: "Let's fly ",
                          style: TextStyle(color: Color(0xFF1B2A41)),
                        ),
                        TextSpan(
                          text: 'today',
                          style: TextStyle(color: Color(0xFF007BA7)),
                        ),
                        TextSpan(
                          text: '.',
                          style: TextStyle(color: Color(0xFF1B2A41)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Promo cards
                  SizedBox(
                    height: 151,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        _PromoCard(
                          tag: 'BEFORE USE',
                          title: 'Ready to meet your instructor?',
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF1B2A41), Color(0xFF53A5D4)],
                          ),
                        ),
                        SizedBox(width: 12),
                        _PromoCard(
                          tag: 'ONBOARD',
                          title: 'All about time building.',
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF204298), Color(0xFF8F9BB3)],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Shortcuts
                  const Text(
                    'SHORTCUTS',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8F9BB3),
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _ShortcutCard(
                          icon: Icons.flight_takeoff,
                          title: 'AIRCRAFT RENTALS/\nSALES',
                          subtitle: 'advertise your aircraft',
                          onTap: () {
                            debugPrint('🧭 [HomeScreen] Shortcut -> AircraftListingScreen');
                            Navigator.of(context).pushNamed(AircraftListingScreen.routeName);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ShortcutCard(
                          icon: Icons.access_time,
                          title: 'TIME BUILDING',
                          subtitle: 'complete 1500 hours',
                          //showDiamond: true,
                          onTap: () {
                            debugPrint('🧭 [HomeScreen] Shortcut -> TimeBuildingListingScreen');
                            Navigator.of(context).pushNamed(TimeBuildingListingScreen.routeName);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _ShortcutCard(
                          icon: Icons.flight,
                          title: 'GET LISTED AS A CFI',
                          subtitle: "Be SKYE's top CFI",
                          //showDiamond: true,
                          onTap: () {
                            debugPrint('🧭 [HomeScreen] Shortcut -> CfiListingScreen');
                            Navigator.of(context).pushNamed(CfiListingScreen.routeName);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ShortcutCard(
                          icon: Icons.menu_book,
                          title: 'LOGBOOK',
                          subtitle: 'coming soon',
                          comingSoon: true,
                          onTap: () {
                            debugPrint('🧭 [HomeScreen] Shortcut -> Logbook (TODO)');
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Instructors near you header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'INSTRUCTORS NEAR YOU',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8F9BB3),
                          letterSpacing: 0.6,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          debugPrint('🧭 [HomeScreen] See All -> CfiListingScreen');
                          Navigator.of(context).pushNamed(CfiListingScreen.routeName);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8F9BB3),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    height: 173,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        _InstructorCard(name: 'Ebru K.', distance: '33 mile away'),
                        SizedBox(width: 12),
                        _InstructorCard(name: 'Ömer K.', distance: '5 mile away'),
                        SizedBox(width: 12),
                        _InstructorCard(name: 'Nezih L.', distance: '5 mile away'),
                        SizedBox(width: 12),
                        _InstructorCard(name: 'Muzeum', distance: '14 mile away'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 2),

                  // Helpful informations
                  const Text(
                    'HELPFUL INFORMATIONS',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8F9BB3),
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 135,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        _InfoCard(title: 'Why are the airplanes white?'),
                        SizedBox(width: 12),
                        _InfoCard(title: '5 interesting facts about flying'),
                        SizedBox(width: 12),
                        _InfoCard(title: 'We lose a lot of water during a flight'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({
    required this.tag,
    required this.title,
    required this.gradient,
  });

  final String tag;
  final String title;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    debugPrint('🧩 [_PromoCard] build tag="$tag"');

    return Container(
      width: 343,
      height: 151,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tag,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              child: const Icon(
                Icons.play_circle_fill,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showDiamond = false,
    this.comingSoon = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showDiamond;
  final bool comingSoon;

  // Tasarıma uygun renkler
  static const _gradientLight = Color(0xFF53A5D4);
  static const _gradientDark = Color(0xFF1B2A41);
  static const _titleColor = Color(0xFF0D1B2A); // Daha koyu bir lacivert
  static const _subtitleColor = Color(0xFF9E9E9E); // Daha hafif bir gri

  static const _arrowBg = Color(0xFFF0F4F8);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: comingSoon ? null : onTap,
      child: Container(
        height: 96,
        padding: const EdgeInsets.fromLTRB(8, 8, 14, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_gradientLight, _gradientDark],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: _titleColor,
                      height: 1.2,
                      letterSpacing: 0.4,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: _subtitleColor,
                              height: 1.3,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: _arrowBg,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: comingSoon ? _subtitleColor : _titleColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InstructorCard extends StatelessWidget {
  const _InstructorCard({
    required this.name,
    required this.distance,
  });

  final String name;
  final String distance;

  @override
  Widget build(BuildContext context) {
    debugPrint('🧩 [_InstructorCard] build name="$name"');

    return SizedBox(
      width: 90,
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFFD9D9D9),
            ),
            child: const Center(
              child: Icon(Icons.person, size: 50, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF838383),
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            distance,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: Color(0xFF838383),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    debugPrint('🧩 [_InfoCard] build title="$title"');

    return Container(
      width: 110,
      height: 135,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF0085FF),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFA1BFFF),
            ),
            child: const Center(
              child: Icon(Icons.image, size: 50, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 9,
            right: 9,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
