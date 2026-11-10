import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.black,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.white,
      onPrimaryContainer: AppColors.black,
      secondaryContainer: AppColors.black,
      onSecondaryContainer: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.black,
      tertiary: AppColors.grey,
    ),
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.black,
      elevation: 0,
    ),
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.white,
      onPrimary: AppColors.black,
      primaryContainer: Color(0xFF202020),
      onPrimaryContainer: AppColors.white,
      secondaryContainer: AppColors.white,
      onSecondaryContainer: AppColors.black,
      surface: Color(0xFF121212),
      onSurface: AppColors.white,
      tertiary: AppColors.grey,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121212),
      foregroundColor: AppColors.white,
      elevation: 0,
    ),
  );
}
