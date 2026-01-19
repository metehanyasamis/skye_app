import 'package:flutter/material.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/widgets/primary_button.dart';
import 'package:skye_app/widgets/skye_background.dart';

class LoginVerificationScreen extends StatelessWidget {
  const LoginVerificationScreen({super.key});

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
                  'Log In',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Verification Code',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                Row(
                  children: List.generate(4, (index) {
                    final isActive = index == 0;
                    return Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.white : AppColors.fieldFill,
                        border: Border.all(color: AppColors.divider),
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
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'Log In',
                  onPressed: () {},
                ),
                const Spacer(),
                _NumberPad(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NumberPad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final numbers = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '',
      '0',
      '⌫',
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.7,
      ),
      itemCount: numbers.length,
      itemBuilder: (context, index) {
        final value = numbers[index];
        if (value.isEmpty) {
          return const SizedBox.shrink();
        }
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.navy900,
            ),
          ),
        );
      },
    );
  }
}
