import 'package:flutter/material.dart';

class SkyeBackground extends StatelessWidget {
  const SkyeBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final padding = mediaQuery.padding;
    final screenSize = mediaQuery.size;
    
    // Get full screen dimensions including system UI areas
    final fullHeight = screenSize.height + padding.top + padding.bottom;
    
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image that extends behind system UI
        // Use Positioned with negative insets to cover full screen
        Positioned(
          top: -padding.top,
          bottom: -padding.bottom,
          left: 0,
          right: 0,
          child: SizedBox(
            width: screenSize.width,
            height: fullHeight,
            child: Image.asset(
              'assets/images/sky_bg.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        // Content with SafeArea for proper padding
        child,
      ],
    );
  }
}
