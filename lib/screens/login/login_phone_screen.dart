import 'package:flutter/material.dart';
import 'package:skye_app/screens/login/login_verification_screen.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/widgets/app_text_field.dart';
import 'package:skye_app/widgets/primary_button.dart';
import 'package:skye_app/widgets/skye_background.dart';
import 'package:skye_app/widgets/skye_logo.dart';

class LoginPhoneScreen extends StatelessWidget {
  const LoginPhoneScreen({super.key});

  static const routeName = '/login-phone';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SkyeBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back,
                          color: AppColors.white),
                    ),
                    const Spacer(),
                    const SkyeLogo(),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Log In',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                const AppTextField(
                  label: 'Phone Number',
                  hint: 'Enter your phone',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 8),
                const Text(
                  'We will send you verification code.',
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const Spacer(),
                PrimaryButton(
                  label: 'Verify',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const LoginVerificationScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
