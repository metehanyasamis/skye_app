import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';

/// Reusable rating chips widget
/// Allows selection of multiple rating options
/// Uses circular chips design
class RatingChips extends StatelessWidget {
  const RatingChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelectionChanged,
  });

  final List<String> options;
  final Set<String> selected;
  final ValueChanged<Set<String>> onSelectionChanged;

  void _toggleOption(String option) {
    final isEmpty = option.isEmpty;
    if (isEmpty) {
      DebugLogger.log('RatingChips', 'add new rating tapped');
      // TODO: Show dialog to add new rating
      return;
    }

    final newSelection = Set<String>.from(selected);
    if (newSelection.contains(option)) {
      newSelection.remove(option);
    } else {
      newSelection.add(option);
    }
    DebugLogger.log('RatingChips', 'selection changed', {'selected': newSelection.toList()});
    onSelectionChanged(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: options.map((option) {
        final isEmpty = option.isEmpty;
        final isSelected = !isEmpty && selected.contains(option);

        return GestureDetector(
          onTap: () => _toggleOption(option),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.selectedBlue : AppColors.white,
              border: Border.all(
                color: isSelected ? AppColors.selectedBlue : AppColors.borderLight,
                width: 1,
              ),
            ),
            child: isEmpty
                ? null
                : Center(
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                        color: isSelected ? AppColors.white : AppColors.labelBlack,
                      ),
                    ),
                  ),
          ),
        );
      }).toList(),
    );
  }
}
