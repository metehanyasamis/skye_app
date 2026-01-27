
import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';

class ShortcutCard extends StatelessWidget {
  const ShortcutCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showDiamond = false,
    this.comingSoon = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showDiamond;
  final bool comingSoon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: comingSoon ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowBlack4,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
// ... ShortcutCard sınıfı içinde Column bölgesi ...
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1) ÜST: İkon ve Başlık - Dikeyde birbirine göre tam ortalı
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.blueGradientTop, AppColors.blueGradientBottom],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: AppColors.white),
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: AppColors.navy900,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // 2) ALT: Alt metin sağa, ikonun yanına yaslı
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // İçeriği sağa iter
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    subtitle,
                    // textAlign: TextAlign.right kullanarak metni sağa yaslıyoruz
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textGrayLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4), // Ok ile metin arasındaki küçük boşluk
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: AppColors.placeholderBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: AppColors.navy900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}