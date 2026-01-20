import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skye_app/theme/app_colors.dart';

class AppTheme {
  static ThemeData get light {
    final base = ThemeData.light();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.navy900,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.navy800,
        secondary: AppColors.blue500,
        surface: AppColors.navy800,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        headlineLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
      ),
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
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.white,
        headerBackgroundColor: AppColors.navy800,
        headerForegroundColor: AppColors.white,
        dayStyle: const TextStyle(color: AppColors.navy900),
        weekdayStyle: const TextStyle(color: AppColors.navy900),
        yearStyle: const TextStyle(color: AppColors.navy900),
        todayForegroundColor: MaterialStateProperty.all(AppColors.navy800),
        dayForegroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.white; // Seçili tarih için beyaz
          }
          return AppColors.navy900; // Normal tarihler için koyu
        }),
        yearForegroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.white; // Seçili yıl için beyaz
          }
          return AppColors.navy900; // Normal yıllar için koyu
        }),
        todayBorder: const BorderSide(color: AppColors.navy800, width: 1),
        cancelButtonStyle: TextButton.styleFrom(
          foregroundColor: AppColors.navy900,
        ),
        confirmButtonStyle: TextButton.styleFrom(
          foregroundColor: AppColors.navy800,
        ),
      ),
    );
  }
}
