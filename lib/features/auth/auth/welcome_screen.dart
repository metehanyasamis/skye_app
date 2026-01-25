// lib/screens/onboarding/welcome_screen.dart
import 'package:flutter/material.dart';

import 'package:skye_app/features/auth/auth/login/login_phone_screen.dart';
import 'package:skye_app/features/auth/auth/sign_up/create_account_phone_screen.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/widgets/base_scaffold.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';
import 'package:skye_app/shared/widgets/skye_background.dart';
import 'package:skye_app/shared/widgets/skye_logo.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('🧱 [WelcomeScreen] build()');

    final size = MediaQuery.of(context).size;
    final topInset = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;

    debugPrint(
      '📐 [WelcomeScreen] size=$size topInset=$topInset bottomInset=$bottomInset keyboardInset=$keyboardInset',
    );

    return BaseScaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      extendBody: true,
      setDarkStatusBar: true,
      child: SkyeBackground(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ✅ TOP CONTENT
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: topInset + 10),
                  const Center(
                    child: SkyeLogo(
                      type: 'logoText',
                      color: 'white',
                      height: 50,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 2, 24, 2),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'The Flight\nPlatform Bringing\nTogether the\nPilots of Today\nand Tomorrow',
                        style:
                        Theme.of(context).textTheme.headlineLarge?.copyWith(
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

            // ✅ CTA FOOTER (bottom safe area + keyboard aware)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 12,
                  bottom: keyboardInset > 0 ? keyboardInset : (bottomInset + 24),
                ),
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
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                        TextButton(
                          onPressed: () {
                            debugPrint(
                              '➡️ [WelcomeScreen] go CreateAccountPhoneScreen',
                            );
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
