import 'package:flutter/material.dart';
import 'package:skye_app/theme/app_colors.dart';

class SkyeLogo extends StatelessWidget {
  const SkyeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/plane_logo.png',
          height: 100,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
        Transform.translate(
          offset: const Offset(0, -15),
          child: const Text(
            'Skye',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}