import 'package:flutter/material.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/widgets/skye_logo.dart';

class CommonHeader extends StatelessWidget {
  const CommonHeader({
    super.key,
    this.locationText = '1 World Wy...',
    this.onNotificationTap,
    this.showNotificationDot = false,
    this.logoHeight = 50,
    this.padding,
  });

  final String locationText;
  final VoidCallback? onNotificationTap;
  final bool showNotificationDot;
  final double logoHeight;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return SafeArea(
      bottom: false,
      child: Padding(
        // ✅ status bar’a yapışmayı engeller
        padding: padding ??
            EdgeInsets.fromLTRB(16, topInset > 0 ? 6 : 14, 16, 12),
        child: Row(
          children: [
            // ✅ Logo biraz nefes alsın
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: SkyeLogo(type: 'logo', color: 'blue', height: logoHeight),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.cardLight,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.place, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        locationText,
                        style: const TextStyle(color: AppColors.textSecondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 12),
            GestureDetector(
              onTap: onNotificationTap,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.cardLight,
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(Icons.notifications_none, color: AppColors.navy900),
                    ),
                    if (showNotificationDot)
                      const Positioned(
                        right: 8,
                        top: 8,
                        child: CircleAvatar(radius: 4, backgroundColor: Colors.red),
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
