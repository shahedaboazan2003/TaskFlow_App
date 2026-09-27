import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.robotoFlexTextTheme();
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        onPrimary: AppColors.lightOnPrimary,
        primaryContainer: AppColors.lightPrimaryContainer,
        onPrimaryContainer: AppColors.lightOnPrimaryContainer,
        secondary: AppColors.lightSecondary,
        onSecondary: AppColors.lightOnSecondary,
        secondaryContainer: AppColors.lightSecondaryContainer,
        onSecondaryContainer: AppColors.lightOnSecondaryContainer,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightOnSurface,
        onSurfaceVariant: AppColors.lightOnSurfaceVariant,
        outline: AppColors.lightOutline,
        outlineVariant: AppColors.lightOutlineVariant,
        error: AppColors.lightError,
        onError: AppColors.lightOnError,
        errorContainer: AppColors.lightErrorContainer,
        onErrorContainer: AppColors.lightOnErrorContainer,
        surfaceContainerLow: AppColors.lightSurfaceContainerLow,
        surfaceContainer: AppColors.lightSurfaceContainer,
        surfaceContainerHigh: AppColors.lightSurfaceContainerHigh,
        surfaceContainerHighest: AppColors.lightSurfaceContainerHighest,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(fontSize: 57, fontWeight: FontWeight.w400, letterSpacing: -0.25),
        displayMedium: baseTextTheme.displayMedium?.copyWith(fontSize: 45, fontWeight: FontWeight.w400, letterSpacing: 0),
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(fontSize: 32, fontWeight: FontWeight.w400, letterSpacing: 0),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(fontSize: 28, fontWeight: FontWeight.w400, letterSpacing: 0),
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(fontSize: 24, fontWeight: FontWeight.w400, letterSpacing: 0),
        titleLarge: baseTextTheme.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.w500, letterSpacing: 0),
        titleMedium: baseTextTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15),
        titleSmall: baseTextTheme.titleSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        bodySmall: baseTextTheme.bodySmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
        labelLarge: baseTextTheme.labelLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
        labelMedium: baseTextTheme.labelMedium?.copyWith(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5),
        labelSmall: baseTextTheme.labelSmall?.copyWith(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.lightOnPrimary,
          textStyle: baseTextTheme.labelLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
          minimumSize: const Size.fromHeight(40), // Based on Stitch M3 FAB/Buttons
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999), // rounded-full from Stitch
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent, // Default Outlined
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.lightOnSurfaceVariant),
        floatingLabelStyle: const TextStyle(color: AppColors.lightPrimary),
      ),
    );
  }

  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.robotoFlexTextTheme(ThemeData.dark().textTheme);
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkOnPrimary,
        primaryContainer: AppColors.darkPrimaryContainer,
        onPrimaryContainer: AppColors.darkOnPrimaryContainer,
        secondary: AppColors.darkSecondary,
        onSecondary: AppColors.darkOnSecondary,
        secondaryContainer: AppColors.darkSecondaryContainer,
        onSecondaryContainer: AppColors.darkOnSecondaryContainer,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
        onSurfaceVariant: AppColors.darkOnSurfaceVariant,
        outline: AppColors.darkOutline,
        outlineVariant: AppColors.darkOutlineVariant,
        error: AppColors.darkError,
        onError: AppColors.darkOnError,
        errorContainer: AppColors.darkErrorContainer,
        onErrorContainer: AppColors.darkOnErrorContainer,
        surfaceContainer: AppColors.darkSurfaceContainer,
        surfaceContainerHigh: AppColors.darkSurfaceContainerHigh,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(fontSize: 57, fontWeight: FontWeight.w400, letterSpacing: -0.25),
        displayMedium: baseTextTheme.displayMedium?.copyWith(fontSize: 45, fontWeight: FontWeight.w400, letterSpacing: 0),
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(fontSize: 32, fontWeight: FontWeight.w400, letterSpacing: 0),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(fontSize: 28, fontWeight: FontWeight.w400, letterSpacing: 0),
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(fontSize: 24, fontWeight: FontWeight.w400, letterSpacing: 0),
        titleLarge: baseTextTheme.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.w500, letterSpacing: 0),
        titleMedium: baseTextTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15),
        titleSmall: baseTextTheme.titleSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        bodySmall: baseTextTheme.bodySmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
        labelLarge: baseTextTheme.labelLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
        labelMedium: baseTextTheme.labelMedium?.copyWith(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5),
        labelSmall: baseTextTheme.labelSmall?.copyWith(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkOnPrimary,
          textStyle: baseTextTheme.labelLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
          minimumSize: const Size.fromHeight(40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.darkOnSurfaceVariant),
        floatingLabelStyle: const TextStyle(color: AppColors.darkPrimary),
      ),
    );
  }
}
