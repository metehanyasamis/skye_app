import 'package:flutter/material.dart';
import 'package:skye_app/screens/login/login_phone_screen.dart';
import 'package:skye_app/screens/onboarding/create_account_phone_screen.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/widgets/primary_button.dart';
import 'package:skye_app/widgets/skye_background.dart';
import 'package:skye_app/widgets/skye_logo.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('🧱 [WelcomeScreen] build');

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent, // 🔥 ŞART
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SkyeBackground(
        child: Stack(
          children: [
            // üst logo + yazılar
            Column(
              children: [
                const SizedBox(height: 80),
                const Center(
                  child: SkyeLogo(
                    type: 'logoText',
                    color: 'white',
                    height: 50,
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 2, 24, 2),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'The Flight\nPlatform Bringing\nTogether the\nPilots of Today\nand Tomorrow',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 36,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ✈️ airplane
            Positioned(
              top: size.height * 0.48,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/airplane.png',
                height: 160,
                fit: BoxFit.contain,
              ),
            ),

            // CTA alanı
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 2, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PrimaryButton(
                      label: "Log In",
                      onPressed: () {
                        debugPrint('➡️ [WelcomeScreen] go LoginPhoneScreen');
                        Navigator.of(context).pushNamed(
                          LoginPhoneScreen.routeName,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                        TextButton(
                          onPressed: () {
                            debugPrint('➡️ [WelcomeScreen] go CreateAccountPhoneScreen');
                            Navigator.of(context).pushNamed(
                              CreateAccountPhoneScreen.routeName,
                            );
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: AppColors.navy800,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
