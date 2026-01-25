import 'package:flutter/material.dart';

import 'package:skye_app/features/aircraft/aircraft_detail_screen.dart';
import 'package:skye_app/features/aircraft/aircraft_listing_screen.dart';
import 'package:skye_app/features/aircraft/aircraft_post_screen.dart';
import 'package:skye_app/features/auth/auth/login/login_phone_screen.dart';
import 'package:skye_app/features/auth/auth/login/login_verification_screen.dart';
import 'package:skye_app/features/cfi/cfi_detail_screen.dart';
import 'package:skye_app/features/cfi/cfi_experiences_screen.dart';
import 'package:skye_app/features/cfi/cfi_in_review_screen.dart';
import 'package:skye_app/features/cfi/cfi_informations_screen.dart';
import 'package:skye_app/features/cfi/cfi_listing_screen.dart';
import 'package:skye_app/features/cfi/create_cfi_profile_screen.dart';
import 'package:skye_app/features/cfi/cfi_post_screen.dart';
import 'package:skye_app/features/home/home/home_screen.dart';
import 'package:skye_app/features/notifications/notifications_screen.dart';
import 'package:skye_app/features/auth/auth/sign_up/create_account_phone_screen.dart';
import 'package:skye_app/features/auth/auth/sign_up/create_account_verification_screen.dart';
import 'package:skye_app/features/auth/auth/notification_permission_screen.dart';
import 'package:skye_app/features/auth/auth/sign_up/personal_information_screen.dart';
import 'package:skye_app/features/auth/auth/sign_up/usage_details_screen.dart';
import 'package:skye_app/features/profile/profile_screen.dart';
import 'package:skye_app/features/safety_pilot/create_safety_pilot_profile_screen.dart';
import 'package:skye_app/features/safety_pilot/safety_pilot_experiences_screen.dart';
import 'package:skye_app/features/safety_pilot/safety_pilot_in_review_screen.dart';
import 'package:skye_app/features/safety_pilot/safety_pilot_informations_screen.dart';
import 'package:skye_app/features/time_building/time_building_listing_screen.dart';
import 'package:skye_app/features/auth/auth/welcome_screen.dart';
import 'package:skye_app/features/time_building/time_building_post_screen.dart';

/// Merkezi route yönetimi.
/// Tüm route isimleri ve builder'lar tek yerden yönetilir.
abstract final class AppRoutes {
  AppRoutes._();

  // ─── Onboarding & Auth ───────────────────────────────────────────────────
  static const String welcome = '/welcome';
  static const String createAccountPhone = '/create-account-phone';
  static const String createAccountVerification = '/create-account-verification';
  static const String personalInformation = '/personal-information';
  static const String usageDetails = '/usage-details';
  static const String notificationPermission = '/onboarding/notification-permission';
  static const String loginPhone = '/login-phone';
  static const String loginVerification = '/login-verification';

  // ─── Main (tab shell) ─────────────────────────────────────────────────────
  static const String home = '/home';
  static const String cfiListing = '/cfi/listing';
  static const String aircraftListing = '/aircraft/listing';
  static const String timeBuildingListing = '/time-building/listing';
  static const String profile = '/profile';

  // ─── CFI ──────────────────────────────────────────────────────────────────
  static const String createCfiProfile = '/cfi/create-profile';
  static const String cfiPost = '/cfi/post';
  static const String cfiInformations = '/cfi/informations';
  static const String cfiExperiences = '/cfi/experiences';
  static const String cfiInReview = '/cfi/in-review';
  static const String cfiDetail = '/cfi/detail';

  // ─── Aircraft ─────────────────────────────────────────────────────────────
  static const String aircraftDetail = '/aircraft/detail';
  static const String aircraftPost = '/aircraft/post';

  // ─── Safety Pilot ─────────────────────────────────────────────────────────
  static const String createSafetyPilotProfile = '/safety-pilot/create-profile';
  static const String safetyPilotInformations = '/safety-pilot/informations';
  static const String safetyPilotExperiences = '/safety-pilot/experiences';
  static const String safetyPilotInReview = '/safety-pilot/in-review';

  // ─── Time Building ────────────────────────────────────────────────────────
  static const String timeBuildingPost = '/time-building/post';

  // ─── Other ────────────────────────────────────────────────────────────────
  static const String notifications = '/notifications';

  /// Tab bar ile kullanılan route'lar (sıra önemli).
  static const List<String> tabRoutes = [
    home,
    cfiListing,
    aircraftListing,
    timeBuildingListing,
    profile,
  ];

  /// MaterialApp routes. Auth gate `home` olunca başlangıç AuthGate'dir.
  static Map<String, WidgetBuilder> get routes => {
        welcome: (_) => const WelcomeScreen(),
        createAccountPhone: (_) => const CreateAccountPhoneScreen(),
        createAccountVerification: (_) => const CreateAccountVerificationScreen(),
        personalInformation: (_) => const PersonalInformationScreen(),
        usageDetails: (_) => const UsageDetailsScreen(),
        notificationPermission: (_) => const NotificationPermissionScreen(),
        loginPhone: (_) => const LoginPhoneScreen(),
        loginVerification: (_) => const LoginVerificationScreen(),
        home: (_) => const HomeScreen(),
        cfiListing: (_) => const CfiListingScreen(),
        aircraftListing: (_) => const AircraftListingScreen(),
        timeBuildingListing: (_) => const TimeBuildingListingScreen(),
        profile: (_) => const ProfileScreen(),
        createCfiProfile: (_) => const CreateCfiProfileScreen(),
        cfiPost: (_) => const CfiPostScreen(),
        cfiInformations: (_) => const CfiInformationsScreen(),
        cfiExperiences: (_) => const CfiExperiencesScreen(),
        cfiInReview: (_) => const CfiInReviewScreen(),
        cfiDetail: (_) => const CfiDetailScreen(),
        aircraftDetail: (_) => const AircraftDetailScreen(),
        aircraftPost: (_) => const AircraftPostScreen(),
        createSafetyPilotProfile: (_) => const CreateSafetyPilotProfileScreen(),
        safetyPilotInformations: (_) => const SafetyPilotInformationsScreen(),
        safetyPilotExperiences: (_) => const SafetyPilotExperiencesScreen(),
        safetyPilotInReview: (_) => const SafetyPilotInReviewScreen(),
        timeBuildingPost: (_) => const TimeBuildingPostScreen(),
        notifications: (_) => const NotificationsScreen(),
      };
}
