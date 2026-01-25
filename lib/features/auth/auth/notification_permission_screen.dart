import 'package:flutter/material.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';
import 'package:skye_app/shared/theme/app_colors.dart';

class NotificationPermissionScreen extends StatelessWidget {
  const NotificationPermissionScreen({super.key});

  static const routeName = '/onboarding/notification-permission';

  @override
  Widget build(BuildContext context) {
    debugPrint('🧱 [NotificationPermissionScreen] build');

    // Set status bar style for light background
    SystemUIHelper.setLightStatusBar();

    return Scaffold(
      backgroundColor: AppColors.cfiBackground,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.58),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 79),

            // Notification icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(
                      Icons.notifications_outlined,
                      size: 32,
                      color: Color(0xFF1B2A41),
                    ),
                  ),

                  // Notification dot
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF1B2A41),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 44),

            // Title
            const Text(
              'Turn on\nnotifications?',
              style: TextStyle(
                fontSize: 31,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 52),

            // Description
            SizedBox(
              width: 343.838,
              child: Text(
                "Don't miss important messages like check-in details and account activity",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black.withValues(alpha: 0.62),
                  height: 26 / 18,
                ),
              ),
            ),

            const Spacer(),

            // Primary button
            Center(
              child: SizedBox(
                width: 330,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint('🔔 [NotificationPermissionScreen] Yes notify me tapped');
                    // TODO: Request notification permission
                    // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B2A41),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Yes, notify me',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 42),

            // Skip button
            Center(
              child: TextButton(
                onPressed: () {
                  debugPrint('⏭️ [NotificationPermissionScreen] Skip tapped');
                  // TODO: Skip notification permission
                  // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1B2A41),
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF1B2A41),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
