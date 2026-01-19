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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent, // 🔥 ŞART
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SkyeBackground(
        child: Stack(
          children: [
            // 🔹 ÜST İÇERİK (LOGO + TEXT)
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 15,
                left: 24,
                right: 24,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Center(child: SkyeLogo()),
                  const SizedBox(height: 48),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'The Flight\nPlatform Bringing\nTogether the\nPilots of Today\nand Tomorrow',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 36,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ✈️ AIRPLANE — FLOW’DAN ÇIKTI
            Positioned(
              top: size.height * 0.52, // 🔥 kritik satır
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/airplane.png',
                height: 220,
                fit: BoxFit.contain,
              ),
            ),

            // 🔘 ALT CTA — ZATEN DOĞRUYDU
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PrimaryButton(
                      label: "Let's fly.",
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          CreateAccountPhoneScreen.routeName,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildAuthOption(
                      context,
                      label: "Already have an account? ",
                      actionText: "Log In",
                      onTap: () => Navigator.of(context)
                          .pushNamed(LoginPhoneScreen.routeName),
                    ),
                    const SizedBox(height: 8),
                    _buildAuthOption(
                      context,
                      label: "Don't have an account? ",
                      actionText: "Sign Up",
                      onTap: () => Navigator.of(context)
                          .pushNamed(CreateAccountPhoneScreen.routeName),
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


  Widget _buildAuthOption(
    BuildContext context, {
    required String label,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.navy700.withOpacity(0.9),
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: const TextStyle(
              color: AppColors.navy800,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
