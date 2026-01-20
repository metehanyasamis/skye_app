import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skye_app/screens/home/home_screen.dart';
import 'package:skye_app/screens/login/login_phone_screen.dart';
import 'package:skye_app/screens/onboarding/create_account_phone_screen.dart';
import 'package:skye_app/screens/onboarding/create_account_verification_screen.dart';
import 'package:skye_app/screens/onboarding/personal_information_screen.dart';
import 'package:skye_app/screens/onboarding/usage_details_screen.dart';
import 'package:skye_app/screens/onboarding/welcome_screen.dart';
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
      },
    );
  }
}
