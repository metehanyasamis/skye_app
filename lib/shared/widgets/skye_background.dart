import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';

class SkyeBackground extends StatelessWidget {
  const SkyeBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    debugPrint('[SkyeBackground] build()');

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image - fixed size, covers full screen
        Positioned.fill(
          child: Image.asset(
            'assets/images/sky_bg.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              debugPrint('[SkyeBackground] sky_bg.png NOT FOUND');
              return const SizedBox.shrink();
            },
          ),
        ),

        // Gradient overlay - subtle, preserves sky photo visibility
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.navy900.withValues(alpha: 0.4),
                  AppColors.blue500.withValues(alpha: 0.3),
                  AppColors.sky100.withValues(alpha: 0.2),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),

        // Content
        child,
      ],
    );
  }
}
