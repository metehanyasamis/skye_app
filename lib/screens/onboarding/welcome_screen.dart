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
            Column(
              children: [
                const SizedBox(height: 48),
                const Center(child: SkyeLogo()),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
                  child: Align(
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
                ),
              ],
            ),

            // ✈️ AIRPLANE — FLOW’DAN ÇIKTI
            Positioned(
              top: size.height * 0.52, // 🔥 kritik satır
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/airplane.png',
                height: 200,
                fit: BoxFit.contain,
              ),
            ),

            // 🔘 ALT CTA — İKİ AŞAMALI GİRİŞ AKIŞI
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Kayıtlı Kullanıcı - Log In (Primary)
                    PrimaryButton(
                      label: "Log In",
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          LoginPhoneScreen.routeName,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Yeni Kullanıcı - Sign Up (Outlined)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Text(
                          "Don't have an account?",
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              CreateAccountPhoneScreen.routeName,
                            );
                          },
                          child: const Text('Sign Up',
                            style: TextStyle(
                            color: AppColors.navy800,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),),
                        )
                      ]
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
