import 'package:flutter/material.dart';

class SkyeBackground extends StatelessWidget {
  const SkyeBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand, // 🔥 ÇOK ÖNEMLİ
      children: [
        Image.asset(
          'assets/images/sky_bg.png',
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        child,
      ],
    );
  }
}
