import 'package:flutter/material.dart';
import 'package:skye_app/app/shell/tab_shell.dart';
import 'package:skye_app/features/aircraft/aircraft_listing_screen.dart';
import 'package:skye_app/features/cfi/cfi_listing_screen.dart';
import 'package:skye_app/features/notifications/notifications_screen.dart';
import 'package:skye_app/features/time_building/time_building_listing_screen.dart';
import 'package:skye_app/shared/models/banner_model.dart';
import 'package:skye_app/shared/models/blog_model.dart';
import 'package:skye_app/shared/services/api_service.dart';
import 'package:skye_app/shared/services/banner_api_service.dart';
import 'package:skye_app/shared/services/blog_api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';
import 'package:skye_app/shared/widgets/common_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BannerModel> _banners = [];
  bool _isLoadingBanners = true;
  String? _bannerError;

  List<BlogModel> _blogPosts = [];
  bool _isLoadingBlogs = true;
  String? _blogError;

  @override
  void initState() {
    super.initState();
    _loadBanners();
    _loadBlogPosts();
  }

  Future<void> _loadBanners() async {
    setState(() {
      _isLoadingBanners = true;
      _bannerError = null;
    });

    try {
      final banners = await BannerApiService.instance.getBanners();
      if (mounted) {
        setState(() {
          _banners = banners;
          _isLoadingBanners = false;
        });
      }
    } catch (e) {
      debugPrint('❌ [HomeScreen] Failed to load banners: $e');
      if (mounted) {
        setState(() {
          _isLoadingBanners = false;
          _bannerError = 'Failed to load banners';
          // Fallback to empty list, will show default banners
          _banners = [];
        });
      }
    }
  }

  Future<void> _loadBlogPosts() async {
    setState(() {
      _isLoadingBlogs = true;
      _blogError = null;
    });

    try {
      final response = await BlogApiService.instance.getBlogPosts(perPage: 10);
      if (mounted) {
        setState(() {
          _blogPosts = response.data;
          _isLoadingBlogs = false;
        });
      }
    } catch (e) {
      debugPrint('❌ [HomeScreen] Failed to load blog posts: $e');
      if (mounted) {
        setState(() {
          _isLoadingBlogs = false;
          _blogError = 'Failed to load blog posts';
          // Fallback to empty list
          _blogPosts = [];
        });
      }
    }
  }

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

                  // Promo cards (Banners from API)
                  SizedBox(
                    height: 151,
                    child: _isLoadingBanners
                        ? const Center(child: CircularProgressIndicator())
                        : _banners.isEmpty
                            ? _buildDefaultBanners()
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _banners.length,
                                itemBuilder: (context, index) {
                                  final banner = _banners[index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      right: index < _banners.length - 1 ? 12 : 0,
                                    ),
                                    child: _PromoCard(
                                      banner: banner,
                                      onTap: banner.linkUrl != null
                                          ? () {
                                              // Handle banner link navigation
                                              debugPrint(
                                                  '🧭 [HomeScreen] Banner tapped: ${banner.linkUrl}');
                                              // TODO: Implement navigation based on link_url
                                            }
                                          : null,
                                    ),
                                  );
                                },
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

                  // Helpful informations (Blog posts)
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
                    child: _isLoadingBlogs
                        ? const Center(child: CircularProgressIndicator())
                        : _blogPosts.isEmpty
                            ? _buildDefaultInfoCards()
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _blogPosts.length,
                                itemBuilder: (context, index) {
                                  final blog = _blogPosts[index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      right: index < _blogPosts.length - 1 ? 12 : 0,
                                    ),
                                    child: _InfoCard(
                                      blog: blog,
                                      onTap: () {
                                        // TODO: Navigate to blog detail screen
                                        debugPrint(
                                            '🧭 [HomeScreen] Blog tapped: ${blog.title}');
                                      },
                                    ),
                                  );
                                },
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

  Widget _buildDefaultBanners() {
    return ListView(
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
    );
  }

  Widget _buildDefaultInfoCards() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: const [
        _InfoCard(title: 'Why are the airplanes white?'),
        SizedBox(width: 12),
        _InfoCard(title: '5 interesting facts about flying'),
        SizedBox(width: 12),
        _InfoCard(title: 'We lose a lot of water during a flight'),
      ],
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({
    this.banner,
    this.tag,
    this.title,
    this.gradient,
    this.onTap,
  }) : assert(
          (banner != null) || (tag != null && title != null && gradient != null),
          'Either banner or tag/title/gradient must be provided',
        );

  final BannerModel? banner;
  final String? tag;
  final String? title;
  final Gradient? gradient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isFromBanner = banner != null;
    final displayTag = isFromBanner ? null : tag;
    final displayTitle = isFromBanner ? banner!.title : title;
    final displaySubtitle = isFromBanner ? banner!.subtitle : null;
    final displayGradient = isFromBanner ? null : gradient;
    final imageUrl = isFromBanner ? banner!.mediaUrl : null;

    debugPrint('🧩 [_PromoCard] build title="$displayTitle"');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 343,
        height: 151,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: displayGradient,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background image or gradient
            if (imageUrl != null)
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  headers: _getImageHeaders(),
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('❌ [_PromoCard] Failed to load image: $imageUrl');
                    debugPrint('   Error: $error');
                    // Fallback to gradient if image fails
                    return Container(
                      decoration: BoxDecoration(
                        gradient: displayGradient ??
                            const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF1B2A41), Color(0xFF53A5D4)],
                            ),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      decoration: BoxDecoration(
                        gradient: displayGradient ??
                            const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF1B2A41), Color(0xFF53A5D4)],
                            ),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                ),
              )
            else if (displayGradient != null)
              Container(
                decoration: BoxDecoration(
                  gradient: displayGradient,
                ),
              ),
            // Dark overlay for better text readability when using image
            if (imageUrl != null)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (displayTag != null)
                    Text(
                      displayTag,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.6,
                      ),
                    ),
                  if (displayTag != null) const SizedBox(height: 12),
                  if (displaySubtitle != null)
                    Text(
                      displaySubtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  if (displaySubtitle != null) const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      displayTitle ?? '',
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
      ),
    );
  }

  /// Get headers for image requests (includes authorization if available)
  Map<String, String> _getImageHeaders() {
    final headers = <String, String>{
      'Accept': 'image/*',
    };
    
    // Add authorization header if token exists
    final authToken = ApiService.instance.dio.options.headers['Authorization'];
    if (authToken != null) {
      headers['Authorization'] = authToken as String;
    }
    
    return headers;
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
  const _InfoCard({
    this.blog,
    this.title,
    this.onTap,
  }) : assert(
          blog != null || title != null,
          'Either blog or title must be provided',
        );

  final BlogModel? blog;
  final String? title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final displayTitle = blog?.title ?? title ?? '';
    final imageUrl = blog?.featuredImage;

    debugPrint('🧩 [_InfoCard] build title="$displayTitle"');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        height: 135,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF0085FF),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background image or placeholder
            Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFA1BFFF),
              ),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      headers: _getImageHeaders(),
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.image, size: 50, color: Colors.white),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Icon(Icons.image, size: 50, color: Colors.white),
                    ),
            ),
            // Dark overlay for text readability
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
            ),
            // Title text
            Positioned(
              bottom: 0,
              left: 9,
              right: 9,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  displayTitle,
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
      ),
    );
  }

  /// Get headers for image requests (includes authorization if available)
  Map<String, String> _getImageHeaders() {
    final headers = <String, String>{
      'Accept': 'image/*',
    };
    
    // Add authorization header if token exists
    final authToken = ApiService.instance.dio.options.headers['Authorization'];
    if (authToken != null) {
      headers['Authorization'] = authToken as String;
    }
    
    return headers;
  }
}
