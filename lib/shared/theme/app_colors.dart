import 'package:flutter/material.dart';

class AppColors {
  // Primary Color Palette
  static const primaryBlue = Color(0xFF346A9A); // Ana mavi
  static const darkBlue = Color(0xFF2B4E71); // Koyu mavi
  static const white = Color(0xFFFFFFFF); // Beyaz

  // Navy variations (based on darkBlue #2B4E71)
  static const navy900 = Color(0xFF1B2A41); // En koyu
  static const navy800 = Color(0xFF2B4E71); // Ana koyu mavi (darkBlue)
  static const navy700 = Color(0xFF3A5F85); // Orta koyu

  // Blue variations (based on primaryBlue #346A9A)
  static const blue500 = Color(0xFF346A9A); // Ana mavi (primaryBlue)
  static const blue400 = Color(0xFF4A7BA8); // Açık mavi
  static const blue300 = Color(0xFF5F8BB5); // Daha açık mavi
  static const blueBright = Color(0xFF007BA7); // Parlak mavi (home screen, buttons)
  static const blueInfo = Color(0xFF0085FF); // Bilgi mavisi (info card border)
  static const blueInfoLight = Color(0xFFA1BFFF); // Açık bilgi mavisi (info card background)
  static const blueGradientLight = Color(0xFF53A5D4); // Gradient açık mavi
  static const blueGradientTop = Color(0xFF4A688C); // Gradient üst (shortcut cards)
  static const blueGradientBottom = Color(0xFF7CA6CC); // Gradient alt (shortcut cards)

  // Background colors
  static const sky100 = Color(0xFFE9EEF5); // Açık mavi-gri arka plan
  static const homeBackground = Color(0xFFF5F7FB); // Ana sayfa arka planı
  static const cfiBackground = Color(0xFFF2F2F7); // CFI ekran arka planı

  // Text colors
  static const textPrimary = Color(0xFFF2F5F9); // Birincil metin (açık)
  static const textSecondary = Color(0xFFB7C4D6); // İkincil metin
  static const textGray = Color(0xFFC4C4C4); // Gri metin
  static const textGrayMedium = Color(0xFF838383); // Orta gri metin (instructor cards)
  static const textGrayLight = Color(0xFF8F9BB3); // Açık gri metin (section titles, subtitles)
  static const labelBlack = Color(0xFF12121D); // Siyah etiket
  static const labelBlack60 = Color(0x9912121D); // %60 opak siyah
  static const labelDarkSecondary = Color(0x752B4E71); // %75 opak koyu mavi
  static const primaryBlack = Color(0xFF181D27); // Birincil siyah
  static const grayDark = Color(0xFFABABAB); // Koyu gri
  static const grayPrimary = Color(0xFF555555); // Birincil gri

  // UI element colors
  static const fieldFill = Color(0xFF243B5C); // Form alanı dolgu
  static const divider = Color(0xFF2A4262); // Ayırıcı çizgi
  static const cardBlue = Color(0xFF325D86); // Kart mavi
  static const cardLight = Color(0xFFE8EEF6); // Açık kart
  static const borderLight = Color(0xFFE1E7F0); // Açık kenarlık
  static const selectedBlue = Color(0xFF346A9A); // Seçili mavi (primaryBlue)
  static const primaryNavy = Color(0xFF011A44); // Primary navy (CFI card badges)
  static const borderBlack10 = Color(0x1A000000); // Black with 10% opacity (border)
  static const shadowBlack4 = Color(0x0A000000); // Black with 4% opacity (shadow)
  static const placeholderBg = Color(0xFFF0F4F8); // Placeholder background
  static const placeholderGray = Color(0xFFD9D9D9); // Placeholder gri (instructor card, profile placeholders)
  
  // Additional colors
  static const redDot = Color(0xFFFF0000); // Kırmızı nokta (bildirim)
}
