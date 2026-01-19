import 'package:flutter/material.dart';
import 'package:skye_app/screens/home/home_screen.dart';
import 'package:skye_app/screens/login/login_phone_screen.dart';
import 'package:skye_app/screens/onboarding/create_account_phone_screen.dart';
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
      home: const WelcomeScreen(),
      routes: {
        CreateAccountPhoneScreen.routeName: (_) =>
            const CreateAccountPhoneScreen(),
        LoginPhoneScreen.routeName: (_) => const LoginPhoneScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
      },
    );
  }
}
