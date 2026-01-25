import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';

/// Reusable back button widget
/// Can be used in AppBar or as a standalone button
class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    this.onPressed,
    this.color,
    this.icon = Icons.chevron_left,
  });

  final VoidCallback? onPressed;
  final Color? color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: color ?? AppColors.labelBlack),
      onPressed: () {
        DebugLogger.log('AppBackButton', 'pressed');
        if (onPressed != null) {
          onPressed!();
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
