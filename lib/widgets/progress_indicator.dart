import 'package:flutter/material.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/utils/debug_logger.dart';

/// Reusable progress indicator widget
/// Shows current step and total steps with visual progress bar
/// Uses small circles (10x10) with connecting lines
class ProgressIndicator extends StatelessWidget {
  const ProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('ProgressIndicator', 'build', {
      'currentStep': currentStep,
      'totalSteps': totalSteps,
    });

    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index < currentStep;
        return Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? AppColors.navy800 : AppColors.borderLight,
              ),
            ),
            if (index < totalSteps - 1)
              Container(
                width: 15,
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                color: isActive && index < currentStep - 1
                    ? AppColors.navy800
                    : AppColors.borderLight,
              ),
          ],
        );
      }),
    );
  }
}
