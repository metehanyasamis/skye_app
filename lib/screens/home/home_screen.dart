import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skye_app/screens/aircraft/aircraft_listing_screen.dart';
import 'package:skye_app/screens/cfi/cfi_listing_screen.dart';
import 'package:skye_app/screens/time_building/time_building_listing_screen.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/widgets/skye_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    debugPrint('🏠 [HomeScreen] build()');

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    debugPrint('✅ [HomeScreen] SystemChrome style applied');

    return Scaffold(
      backgroundColor: AppColors.cfiBackground,
      body: Column(
        children: [
          // Top header
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 12, 16, 12),
            child: Row(
              children: [
                // Logo
                const SkyeLogo(type: 'logo', color: 'blue', height: 120),
                const SizedBox(width: 8),

                // Location
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 18,
                            color: Color(0xFF8F9BB3),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '1 World Wyndam...',
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color(0xFF8F9BB3).withValues(alpha: 0.58),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Notification icon
                SizedBox(
                  width: 24,
                  child: Stack(
                    children: [
                      const Icon(
                        Icons.notifications_outlined,
                        size: 24,
                        color: AppColors.labelBlack,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                          title: 'AIRCRAFT RENTALS/SALES',
                          subtitle: 'advertise your aircraft',
                          onTap: () {
                            debugPrint('🧭 [HomeScreen] Shortcut -> AircraftListingScreen');
                            Navigator.of(context).pushNamed(AircraftListingScreen.routeName);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ShortcutCard(
                          icon: Icons.access_time,
                          title: 'TIME BUILDING',
                          subtitle: 'complete 1500 hours',
                          onTap: () {
                            debugPrint('🧭 [HomeScreen] Shortcut -> TimeBuildingListingScreen');
                            Navigator.of(context).pushNamed(TimeBuildingListingScreen.routeName);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: _ShortcutCard(
                          icon: Icons.flight,
                          title: 'GET LISTED AS A CFI',
                          subtitle: "Be SKYE's top CFI",
                          onTap: () {
                            debugPrint('🧭 [HomeScreen] Shortcut -> CfiListingScreen');
                            Navigator.of(context).pushNamed(CfiListingScreen.routeName);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ShortcutCard(
                          icon: Icons.menu_book,
                          title: 'LOGBOOK',
                          subtitle: 'coming soon',
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

                  const SizedBox(height: 20),

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

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom navigation bar
          Container(
            height: 77,
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.navy900,
              unselectedItemColor: AppColors.textSecondary,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              onTap: (i) => debugPrint('🔽 [HomeScreen] BottomNav tap index=$i'),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
                BottomNavigationBarItem(icon: Icon(Icons.flight), label: 'Flights'),
                BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Logbook'),
                BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
              ],
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
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    debugPrint('🧩 [_ShortcutCard] build title="$title"');

    return GestureDetector(
      onTap: () {
        debugPrint('🟦 [_ShortcutCard] tapped title="$title"');
        onTap();
      },
      child: Container(
        height: 90,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 26,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1B2A41), Color(0xFF53A5D4)],
                ),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(icon, size: 16, color: AppColors.white),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF011A43),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w300,
                color: Color(0xFF838383),
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
