import 'package:flutter/material.dart';

class SkyeLogo extends StatelessWidget {
  const SkyeLogo({
    super.key,
    this.type = 'logo',
    this.color = 'white',
    this.height,
    this.width,
  });

  /// Logo tipi: 'logoText' (logo + text), 'logo' (sadece logo)
  final String type;
  
  /// Logo rengi: 'white', 'blue', 'black'
  final String color;
  
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    // Logo tipi ve renge göre asset seç
    String logoAsset;
    
    if (type.toLowerCase() == 'logotext') {
      // Logo + Text versiyonu
      switch (color.toLowerCase()) {
        case 'white':
          logoAsset = 'assets/images/skye_logoText_white.png';
          break;
        case 'blue':
          logoAsset = 'assets/images/skye_logoText_blue.png';
          break;
        case 'black':
          logoAsset = 'assets/images/skye_logoText_black.png';
          break;
        default:
          logoAsset = 'assets/images/skye_logoText_white.png';
      }
    } else {
      // Sadece logo versiyonu
      switch (color.toLowerCase()) {
        case 'white':
          logoAsset = 'assets/images/skye_logo_white.png';
          break;
        case 'blue':
          logoAsset = 'assets/images/skye_logo_blue.png';
          break;
        case 'black':
          logoAsset = 'assets/images/skye_logo_black.png';
          break;
        default:
          logoAsset = 'assets/images/skye_logo_white.png';
      }
    }

    return Image.asset(
      logoAsset,
      height: height ?? 72,
      width: width,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
  }
}
