import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';

/// Ortak Post FAB – listing ekranlarında ilan vermek için.
/// Aircraft / Time building / CFI listing ekranlarında kullanılır.
class PostFab extends StatelessWidget {
  const PostFab({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.navy800,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.send_rounded,
              size: 24,
              color: AppColors.white,
            ),
            SizedBox(height: 2),
            Text(
              'Post',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
