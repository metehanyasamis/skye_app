import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';

class AppTheme {
  static const String _fontFamily = 'WorkSans';

  static ThemeData get light {
    debugPrint('🎨 [AppTheme] building light theme');

    final base = ThemeData.light();

    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.navy800,
        secondary: AppColors.blue500,
        surface: AppColors.navy800,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: base.textTheme.copyWith(
        headlineLarge: const TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        headlineMedium: const TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        titleLarge: const TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        bodyLarge: const TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        bodyMedium: const TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
      ),

      // ✅ burada datePickerTheme yok! (Flutter sürümünde desteklenmiyor)
      // ✅ DatePicker styling'i showDatePicker builder içinde Theme() ile verilecek.

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.fieldFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.white),
        ),
      ),
    );
  }
}
