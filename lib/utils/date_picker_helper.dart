import 'package:flutter/material.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/utils/debug_logger.dart';

/// Helper utility for date picker configuration
class DatePickerHelper {
  /// Get themed date picker
  static Future<DateTime?> showThemedDatePicker({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    DebugLogger.log('DatePickerHelper', 'showThemedDatePicker');

    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.navy800,
              onPrimary: AppColors.white,
              onSurface: AppColors.navy900,
              surface: AppColors.white,
              onSurfaceVariant: AppColors.textPrimary,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppColors.white,
              headerBackgroundColor: AppColors.navy800,
              headerForegroundColor: AppColors.white,
              dayStyle: const TextStyle(color: AppColors.navy900),
              weekdayStyle: const TextStyle(color: AppColors.navy900),
              yearStyle: const TextStyle(color: AppColors.navy900),
              todayForegroundColor: WidgetStateProperty.all(AppColors.navy800),
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.white;
                }
                return AppColors.navy900;
              }),
              yearForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.white;
                }
                return AppColors.navy900;
              }),
              todayBorder: const BorderSide(color: AppColors.navy800, width: 1),
              cancelButtonStyle: TextButton.styleFrom(
                foregroundColor: AppColors.navy900,
              ),
              confirmButtonStyle: TextButton.styleFrom(
                foregroundColor: AppColors.navy800,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
