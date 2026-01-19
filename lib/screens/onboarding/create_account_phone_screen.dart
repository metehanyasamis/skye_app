import 'package:flutter/material.dart';
import 'package:skye_app/screens/onboarding/verification_screen.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/widgets/app_text_field.dart';
import 'package:skye_app/widgets/primary_button.dart';
import 'package:skye_app/widgets/skye_background.dart';

class CreateAccountPhoneScreen extends StatelessWidget {
  const CreateAccountPhoneScreen({super.key});

  static const routeName = '/create-account-phone';

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
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back, color: AppColors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create An Account',
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
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const Spacer(),
                PrimaryButton(
                  label: 'Continue',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const VerificationScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Log In'),
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
