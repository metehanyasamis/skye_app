import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skye_app/screens/aircraft/aircraft_detail_screen.dart';
import 'package:skye_app/screens/aircraft/aircraft_listing_screen.dart';
import 'package:skye_app/screens/aircraft/aircraft_post_screen.dart';
import 'package:skye_app/screens/login/login_phone_screen.dart';
import 'package:skye_app/screens/profile/profile_screen.dart';
import 'package:skye_app/screens/safety_pilot/create_safety_pilot_profile_screen.dart';
import 'package:skye_app/screens/safety_pilot/safety_pilot_experiences_screen.dart';
import 'package:skye_app/screens/safety_pilot/safety_pilot_in_review_screen.dart';
import 'package:skye_app/screens/safety_pilot/safety_pilot_informations_screen.dart';
import 'package:skye_app/screens/time_building/time_building_listing_screen.dart';
import 'package:skye_app/screens/time_building/time_building_post_screen.dart';
import 'package:skye_app/screens/cfi/cfi_detail_screen.dart';
import 'package:skye_app/screens/cfi/cfi_experiences_screen.dart';
import 'package:skye_app/screens/cfi/cfi_informations_screen.dart';
import 'package:skye_app/screens/cfi/cfi_in_review_screen.dart';
import 'package:skye_app/screens/cfi/cfi_listing_screen.dart';
import 'package:skye_app/screens/cfi/create_cfi_profile_screen.dart';
import 'package:skye_app/screens/home/home_screen.dart';
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
    debugPrint('[SkyeApp] build()');

    return MaterialApp(
      title: 'Skye',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      builder: (context, child) {
        debugPrint('[SkyeApp] builder() child=${child.runtimeType}');

        // Ensure system UI is transparent
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
        );

        if (child == null) {
          debugPrint('[SkyeApp] builder() child is null');
          return const SizedBox.shrink();
        }

        // Wrap all routes with transparent Material to prevent color flash
        return Material(
          color: Colors.transparent,
          child: child,
        );
      },
      home: const WelcomeScreen(),
      routes: {
        CreateAccountPhoneScreen.routeName: (_) {
          debugPrint('[Route] ${CreateAccountPhoneScreen.routeName}');
          return const CreateAccountPhoneScreen();
        },
        CreateAccountVerificationScreen.routeName: (_) {
          debugPrint('[Route] ${CreateAccountVerificationScreen.routeName}');
          return const CreateAccountVerificationScreen();
        },
        PersonalInformationScreen.routeName: (_) {
          debugPrint('[Route] ${PersonalInformationScreen.routeName}');
          return const PersonalInformationScreen();
        },
        UsageDetailsScreen.routeName: (_) {
          debugPrint('[Route] ${UsageDetailsScreen.routeName}');
          return const UsageDetailsScreen();
        },

        LoginPhoneScreen.routeName: (_) {
          debugPrint('[Route] ${LoginPhoneScreen.routeName}');
          return const LoginPhoneScreen();
        },

        HomeScreen.routeName: (_) {
          debugPrint('[Route] ${HomeScreen.routeName}');
          return const HomeScreen();
        },
        CreateCfiProfileScreen.routeName: (_) {
          debugPrint('[Route] ${CreateCfiProfileScreen.routeName}');
          return const CreateCfiProfileScreen();
        },
        CfiInformationsScreen.routeName: (_) {
          debugPrint('[Route] ${CfiInformationsScreen.routeName}');
          return const CfiInformationsScreen();
        },
        CfiExperiencesScreen.routeName: (_) {
          debugPrint('[Route] ${CfiExperiencesScreen.routeName}');
          return const CfiExperiencesScreen();
        },
        CfiInReviewScreen.routeName: (_) {
          debugPrint('[Route] ${CfiInReviewScreen.routeName}');
          return const CfiInReviewScreen();
        },
        CfiListingScreen.routeName: (_) {
          debugPrint('[Route] ${CfiListingScreen.routeName}');
          return const CfiListingScreen();
        },
        CfiDetailScreen.routeName: (_) {
          debugPrint('[Route] ${CfiDetailScreen.routeName}');
          return const CfiDetailScreen();
        },
        AircraftListingScreen.routeName: (_) {
          debugPrint('[Route] ${AircraftListingScreen.routeName}');
          return const AircraftListingScreen();
        },
        AircraftDetailScreen.routeName: (_) {
          debugPrint('[Route] ${AircraftDetailScreen.routeName}');
          return const AircraftDetailScreen();
        },
        AircraftPostScreen.routeName: (_) {
          debugPrint('[Route] ${AircraftPostScreen.routeName}');
          return const AircraftPostScreen();
        },
        ProfileScreen.routeName: (_) {
          debugPrint('[Route] ${ProfileScreen.routeName}');
          return const ProfileScreen();
        },
        CreateSafetyPilotProfileScreen.routeName: (_) {
          debugPrint('[Route] ${CreateSafetyPilotProfileScreen.routeName}');
          return const CreateSafetyPilotProfileScreen();
        },
        SafetyPilotInformationsScreen.routeName: (_) {
          debugPrint('[Route] ${SafetyPilotInformationsScreen.routeName}');
          return const SafetyPilotInformationsScreen();
        },
        SafetyPilotExperiencesScreen.routeName: (_) {
          debugPrint('[Route] ${SafetyPilotExperiencesScreen.routeName}');
          return const SafetyPilotExperiencesScreen();
        },
        SafetyPilotInReviewScreen.routeName: (_) {
          debugPrint('[Route] ${SafetyPilotInReviewScreen.routeName}');
          return const SafetyPilotInReviewScreen();
        },
        TimeBuildingPostScreen.routeName: (_) {
          debugPrint('[Route] ${TimeBuildingPostScreen.routeName}');
          return const TimeBuildingPostScreen();
        },
        TimeBuildingListingScreen.routeName: (_) {
          debugPrint('[Route] ${TimeBuildingListingScreen.routeName}');
          return const TimeBuildingListingScreen();
        },
        NotificationPermissionScreen.routeName: (_) {
          debugPrint('[Route] ${NotificationPermissionScreen.routeName}');
          return const NotificationPermissionScreen();
        },
        NotificationsScreen.routeName: (_) {
          debugPrint('[Route] ${NotificationsScreen.routeName}');
          return const NotificationsScreen();
        },
      },
    );
  }
}
