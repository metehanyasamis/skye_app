import 'package:flutter/material.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/widgets/primary_button.dart';
import 'package:skye_app/widgets/skye_background.dart';

import '../home/home_screen.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

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
                const Text(
                  'Verification Code',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(4, (index) {
                    final isActive = index == 0;
                    return Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color:
                            isActive ? AppColors.white : AppColors.fieldFill,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        isActive ? '4' : '',
                        style: const TextStyle(
                          color: AppColors.navy900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }),
                ),
                const Spacer(),
                PrimaryButton(
                  label: 'Verify',
                  onPressed: () {
                    // HomeScreen'e git ve önceki tüm sayfaları kapat
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      HomeScreen.routeName,
                          (route) => false,
                    );
                  },
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
