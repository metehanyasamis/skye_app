import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';

class LocationPermissionDialog extends StatelessWidget {
  const LocationPermissionDialog({
    super.key,
    this.onNoThanks,
    this.onGoToSettings,
  });

  final VoidCallback? onNoThanks;
  final VoidCallback? onGoToSettings;

  @override
  Widget build(BuildContext context) {
    debugPrint('[LocationPermissionDialog] build()');

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Dark overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.7),
            ),
          ),

          // Dialog content
          Center(
            child: Container(
              width: 360.69,
              height: 472.386,
              decoration: BoxDecoration(
                color: AppColors.cfiBackground,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 24.4,
                    offset: const Offset(0, 8),
                    spreadRadius: 14,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 2.6,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 31.21),

                  // Title
                  const Text(
                    'Your location',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B2A41),
                    ),
                  ),

                  const SizedBox(height: 6.39),

                  // Divider
                  Container(
                    height: 1,
                    color: Colors.black.withValues(alpha: 0.1),
                    margin: const EdgeInsets.symmetric(horizontal: 0.5),
                  ),

                  const SizedBox(height: 28.6),

                  // Location icon
                  Container(
                    width: 69.465,
                    height: 69.465,
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
                    child: const Icon(
                      Icons.location_on,
                      size: 40,
                      color: Color(0xFF1B2A41),
                    ),
                  ),

                  const SizedBox(height: 30.47),

                  // Description text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'To center the map on your current\nlocation, update your settings to\n"always" or "while using."',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF1B2A41),
                        height: 25 / 18,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Divider
                  Container(
                    height: 1,
                    color: Colors.black.withValues(alpha: 0.1),
                    margin: const EdgeInsets.symmetric(horizontal: 0.5),
                  ),

                  const SizedBox(height: 20),

                  // Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45.14),
                    child: Column(
                      children: [
                        // Go to settings button
                        SizedBox(
                          width: double.infinity,
                          height: 49.061,
                          child: ElevatedButton(
                            onPressed: () {
                              debugPrint(
                                  '[LocationPermissionDialog] Go to settings tapped');
                              if (onGoToSettings != null) {
                                onGoToSettings!();
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1B2A41),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Go to settings',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // No thanks button
                        TextButton(
                          onPressed: () {
                            debugPrint(
                                '[LocationPermissionDialog] No thanks tapped');
                            if (onNoThanks != null) {
                              onNoThanks!();
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'No thanks',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void show(
      BuildContext context, {
        VoidCallback? onNoThanks,
        VoidCallback? onGoToSettings,
      }) {
    debugPrint('[LocationPermissionDialog] show() called');

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) {
        debugPrint('[LocationPermissionDialog] showDialog builder()');
        return LocationPermissionDialog(
          onNoThanks: onNoThanks,
          onGoToSettings: onGoToSettings,
        );
      },
    );
  }
}
