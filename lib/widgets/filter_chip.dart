import 'package:flutter/material.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/utils/debug_logger.dart';

/// Reusable filter chip widget
/// Used in listing screens for filtering options
class FilterChip extends StatelessWidget {
  const FilterChip({
    super.key,
    required this.label,
    required this.icon,
    this.isSelected = false,
    this.onTap,
    this.iconSize,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final effectiveIconSize = iconSize ?? (label == 'City' ? 16.0 : 24.0);
    
    return GestureDetector(
      onTap: () {
        DebugLogger.log('FilterChip', 'tapped', {'label': label, 'selected': isSelected});
        onTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.navy800 : AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: effectiveIconSize,
              color: isSelected ? AppColors.white : AppColors.labelBlack,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? AppColors.white : AppColors.labelBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
