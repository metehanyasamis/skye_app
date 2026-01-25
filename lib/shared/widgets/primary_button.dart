import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.child,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    debugPrint('[PrimaryButton] build() label="$label" enabled=${onPressed != null}');

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          debugPrint('[PrimaryButton] onPressed() label="$label"');
          if (onPressed != null) onPressed!();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navy800,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.navy700,
          disabledForegroundColor: AppColors.white.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: child ??
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
      ),
    );
  }
}
