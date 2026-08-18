import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// Tema principal de DentisApp.
///
/// Centraliza los tokens semánticos de color, tipografía,
/// espaciado y forma utilizados por la aplicación.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.light(
      primary: AppColors.purple900,
      onPrimary: AppColors.white,

      secondary: AppColors.purple700,
      onSecondary: AppColors.white,

      surface: AppColors.white,
      onSurface: AppColors.black,

      error: AppColors.error,
      onError: AppColors.white,
    );

    return ThemeData(
      useMaterial3: true,

      colorScheme: colorScheme,

      scaffoldBackgroundColor: AppColors.gray100,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.purple900,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),

      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppRadius.md),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppRadius.md),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),

      textTheme: TextTheme(
        titleLarge: AppTextStyles.title.copyWith(
          color: AppColors.black,
        ),
        titleMedium: AppTextStyles.subtitle.copyWith(
          color: AppColors.black,
        ),
        bodyLarge: AppTextStyles.body.copyWith(
          color: AppColors.black,
        ),
        bodyMedium: AppTextStyles.bodySecondary.copyWith(
          color: AppColors.gray700,
        ),
        labelLarge: AppTextStyles.label.copyWith(
          color: AppColors.black,
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.purple900,
        foregroundColor: AppColors.white,
      ),
    );
  }
}