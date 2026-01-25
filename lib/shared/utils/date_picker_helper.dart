import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';

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

    const colorScheme = ColorScheme.light(
      primary: AppColors.navy800,
      onPrimary: AppColors.white,
      onSurface: AppColors.navy900,
      surface: AppColors.white,
      onSurfaceVariant: AppColors.textPrimary,
    );

    final pickerTheme = DatePickerThemeData(
      backgroundColor: AppColors.white,
      headerBackgroundColor: AppColors.navy800,
      headerForegroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      dayStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      weekdayStyle: const TextStyle(
        color: AppColors.navy900,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      yearStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      todayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.white;
        }
        return AppColors.navy800;
      }),
      todayBorder: const BorderSide(color: AppColors.navy800, width: 1),
      dayOverlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.transparent;
        }
        return null;
      }),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.navy800;
        }
        return null;
      }),
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.white;
        }
        return AppColors.navy900;
      }),
      yearOverlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.transparent;
        }
        return null;
      }),
      yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.navy800;
        }
        return null;
      }),
      yearForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.white;
        }
        return AppColors.navy900;
      }),
      cancelButtonStyle: TextButton.styleFrom(
        foregroundColor: AppColors.navy900,
      ),
      confirmButtonStyle: TextButton.styleFrom(
        foregroundColor: AppColors.navy800,
      ),
    );

    final theme = ThemeData.light(useMaterial3: true).copyWith(
      colorScheme: colorScheme,
      datePickerTheme: pickerTheme,
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.white;
            }
            return AppColors.navy900;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.navy800;
            }
            return null;
          }),
        ),
      ),
    );

    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (_, child) {
        return Theme(data: theme, child: child!);
      },
    );
  }
}
