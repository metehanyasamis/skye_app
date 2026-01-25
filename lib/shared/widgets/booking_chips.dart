import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';

/// Reusable booking chips widget
/// Allows single selection of booking options
class BookingChips extends StatelessWidget {
  const BookingChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelectionChanged,
  });

  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: options.map((option) {
        final isSelected = selected == option;

        return GestureDetector(
          onTap: () {
            DebugLogger.log('BookingChips', 'option tapped', {'option': option});
            onSelectionChanged(option);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? AppColors.selectedBlue : AppColors.borderLight,
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              option,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.selectedBlue : AppColors.labelBlack,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
