import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skye_app/screens/aircraft/aircraft_detail_screen.dart';
import 'package:skye_app/screens/aircraft/aircraft_listing_screen.dart';
import 'package:skye_app/screens/aircraft/aircraft_post_screen.dart';
import 'package:skye_app/screens/profile/profile_screen.dart';
import 'package:skye_app/screens/safety_pilot/create_safety_pilot_profile_screen.dart';
import 'package:skye_app/screens/safety_pilot/safety_pilot_informations_screen.dart';
import 'package:skye_app/screens/safety_pilot/safety_pilot_experiences_screen.dart';
import 'package:skye_app/screens/safety_pilot/safety_pilot_in_review_screen.dart';
import 'package:skye_app/screens/time_building/time_building_post_screen.dart';
import 'package:skye_app/screens/time_building/time_building_listing_screen.dart';
import 'package:skye_app/screens/cfi/cfi_detail_screen.dart';
import 'package:skye_app/screens/cfi/cfi_experiences_screen.dart';
import 'package:skye_app/screens/cfi/cfi_informations_screen.dart';
import 'package:skye_app/screens/cfi/cfi_in_review_screen.dart';
import 'package:skye_app/screens/cfi/cfi_listing_screen.dart';
import 'package:skye_app/screens/cfi/create_cfi_profile_screen.dart';
import 'package:skye_app/screens/home/home_screen.dart';
import 'package:skye_app/screens/login/login_phone_screen.dart';
import 'package:skye_app/screens/onboarding/create_account_phone_screen.dart';
import 'package:skye_app/screens/onboarding/create_account_verification_screen.dart';
import 'package:skye_app/screens/onboarding/personal_information_screen.dart';
import 'package:skye_app/screens/onboarding/usage_details_screen.dart';
import 'package:skye_app/screens/onboarding/welcome_screen.dart';
import 'package:skye_app/screens/onboarding/notification_permission_screen.dart';
import 'package:skye_app/screens/notifications/notifications_screen.dart';
import 'package:skye_app/theme/app_theme.dart';

class SkyeApp extends StatelessWidget {
  const SkyeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skye',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      builder: (context, child) {
        // Ensure system UI is transparent
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
        );
        
        // Wrap all routes with transparent Material to prevent color flash
        if (child != null) {
          return Material(
            color: Colors.transparent,
            child: child,
          );
        }
        return child ?? const SizedBox.shrink();
      },
      home: const WelcomeScreen(),
      routes: {
        CreateAccountPhoneScreen.routeName: (_) =>
            const CreateAccountPhoneScreen(),
        CreateAccountVerificationScreen.routeName: (_) =>
            const CreateAccountVerificationScreen(),
        PersonalInformationScreen.routeName: (_) =>
            const PersonalInformationScreen(),
        UsageDetailsScreen.routeName: (_) => const UsageDetailsScreen(),
        LoginPhoneScreen.routeName: (_) => const LoginPhoneScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        CreateCfiProfileScreen.routeName: (_) => const CreateCfiProfileScreen(),
        CfiInformationsScreen.routeName: (_) => const CfiInformationsScreen(),
        CfiExperiencesScreen.routeName: (_) => const CfiExperiencesScreen(),
        CfiInReviewScreen.routeName: (_) => const CfiInReviewScreen(),
        CfiListingScreen.routeName: (_) => const CfiListingScreen(),
        CfiDetailScreen.routeName: (_) => const CfiDetailScreen(),
        AircraftListingScreen.routeName: (_) => const AircraftListingScreen(),
        AircraftDetailScreen.routeName: (_) => const AircraftDetailScreen(),
        AircraftPostScreen.routeName: (_) => const AircraftPostScreen(),
        ProfileScreen.routeName: (_) => const ProfileScreen(),
        CreateSafetyPilotProfileScreen.routeName: (_) =>
            const CreateSafetyPilotProfileScreen(),
        SafetyPilotInformationsScreen.routeName: (_) =>
            const SafetyPilotInformationsScreen(),
        SafetyPilotExperiencesScreen.routeName: (_) =>
            const SafetyPilotExperiencesScreen(),
        SafetyPilotInReviewScreen.routeName: (_) =>
            const SafetyPilotInReviewScreen(),
        TimeBuildingPostScreen.routeName: (_) =>
            const TimeBuildingPostScreen(),
        TimeBuildingListingScreen.routeName: (_) =>
            const TimeBuildingListingScreen(),
        NotificationPermissionScreen.routeName: (_) =>
            const NotificationPermissionScreen(),
        NotificationsScreen.routeName: (_) =>
            const NotificationsScreen(),
      },
    );
  }
}
