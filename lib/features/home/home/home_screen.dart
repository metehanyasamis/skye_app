import 'package:flutter/material.dart';
import 'package:skye_app/app/shell/tab_shell.dart';
import 'package:skye_app/features/aircraft/aircraft_listing_screen.dart';
import 'package:skye_app/features/cfi/cfi_listing_screen.dart';
import 'package:skye_app/features/home/widgets/banner_carousel.dart';
import 'package:skye_app/features/home/widgets/helpful_information_section.dart';
import 'package:skye_app/features/home/widgets/instructors_section.dart';
import 'package:skye_app/features/home/widgets/shortcuts_section.dart';
import 'package:skye_app/features/notifications/notifications_screen.dart';
import 'package:skye_app/features/time_building/time_building_listing_screen.dart';
import 'package:skye_app/shared/models/banner_model.dart';
import 'package:skye_app/shared/models/blog_model.dart';
import 'package:skye_app/shared/models/pilot_model.dart';
import 'package:skye_app/shared/services/banner_api_service.dart';
import 'package:skye_app/shared/services/blog_api_service.dart';
import 'package:skye_app/shared/services/pilot_api_service.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';
import 'package:skye_app/shared/widgets/common_header.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';

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

  List<PilotModel> _pilots = [];
  bool _isLoadingPilots = true;
  String? _pilotError;

  @override
  void initState() {
    super.initState();
    _loadBanners();
    _loadBlogPosts();
    _loadPilots();
  }

  Future<void> _loadBanners() async {
    setState(() {
      _isLoadingBanners = true;
      _bannerError = null;
    });

    try {
      final banners = await BannerApiService.instance.getBanners();
      if (mounted) {
        // Sort banners by sortOrder (null values go to end), then by id
        final sortedBanners = List<BannerModel>.from(banners)
          ..sort((a, b) {
            if (a.sortOrder != null && b.sortOrder != null) {
              return a.sortOrder!.compareTo(b.sortOrder!);
            }
            if (a.sortOrder != null) return -1;
            if (b.sortOrder != null) return 1;
            return a.id.compareTo(b.id);
          });

        setState(() {
          _banners = sortedBanners;
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
      // Load blog posts for home screen
      final response = await BlogApiService.instance.getBlogPosts(perPage: 10);
      if (mounted) {
        debugPrint('📰 [HomeScreen] Loaded ${response.data.length} blog posts (total available: ${response.meta.total})');
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

  Future<void> _loadPilots() async {
    setState(() {
      _isLoadingPilots = true;
      _pilotError = null;
    });

    try {
      // Load first page with 10 pilots (instructors only)
      final response = await PilotApiService.instance.getPilots(
        page: 1,
        perPage: 10,
      );
      if (mounted) {
        // Filter to only show instructors (pilots with instructor_ratings)
        final instructors = response.data.where((pilot) => pilot.isInstructor).toList();
        setState(() {
          _pilots = instructors;
          _isLoadingPilots = false;
        });
      }
    } catch (e) {
      debugPrint('❌ [HomeScreen] Failed to load pilots: $e');
      if (mounted) {
        setState(() {
          _isLoadingPilots = false;
          _pilotError = 'Failed to load instructors';
          // Fallback to empty list
          _pilots = [];
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
                          style: const TextStyle(color: AppColors.navy900),
                        ),
                        const TextSpan(
                          text: 'today',
                          style: TextStyle(color: AppColors.blueBright),
                        ),
                        const TextSpan(
                          text: '.',
                          style: TextStyle(color: AppColors.navy900),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Banner carousel
                  BannerCarousel(
                    banners: _banners,
                    isLoading: _isLoadingBanners,
                  ),

                  const SizedBox(height: 20),

                  // Shortcuts section
                  ShortcutsSection(
                    onAircraftTap: () {
                      debugPrint('🧭 [HomeScreen] Shortcut -> AircraftListingScreen');
                      Navigator.of(context).pushNamed(AircraftListingScreen.routeName);
                    },
                    onTimeBuildingTap: () {
                      debugPrint('🧭 [HomeScreen] Shortcut -> TimeBuildingListingScreen');
                      Navigator.of(context).pushNamed(TimeBuildingListingScreen.routeName);
                    },
                    onCfiTap: () {
                      debugPrint('🧭 [HomeScreen] Shortcut -> CfiListingScreen');
                      Navigator.of(context).pushNamed(CfiListingScreen.routeName);
                    },
                    onLogbookTap: () {
                      debugPrint('🧭 [HomeScreen] Logbook (TODO)');
                    },
                  ),

                  const SizedBox(height: 20),

                  // Instructors section
                  InstructorsSection(
                    pilots: _pilots,
                    isLoading: _isLoadingPilots,
                  ),

                  // Helpful Information section
                  HelpfulInformationSection(
                    blogPosts: _blogPosts,
                    isLoading: _isLoadingBlogs,
                    onBlogTap: (blog) {
                      debugPrint('🧭 [HomeScreen] Blog tapped: ${blog.title}');
                      Navigator.of(context).pushNamed(
                        AppRoutes.blogWebView,
                        arguments: {'blog': blog},
                      );
                    },
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
