import 'package:flutter/material.dart';

/// App Color Scheme
/// Defines all colors used throughout the application
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors - Warm, food-inspired palette
  static const Color primary = Color(0xFFE63946); // Vibrant red/coral
  static const Color primaryLight = Color(0xFFF77F7F);
  static const Color primaryDark = Color(0xFFC1121F);
  
  // Secondary Colors
  static const Color secondary = Color(0xFFF77F00); // Warm orange
  static const Color secondaryLight = Color(0xFFFFA64D);
  static const Color secondaryDark = Color(0xFFCC6600);
  
  // Accent Colors
  static const Color accent = Color(0xFF06A77D); // Fresh green
  static const Color accentLight = Color(0xFF4ECCA3);
  static const Color accentDark = Color(0xFF048A68);
  
  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1D1D1D);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);
  
  // Status Colors
  static const Color success = Color(0xFF06A77D);
  static const Color warning = Color(0xFFFFB800);
  static const Color error = Color(0xFFE63946);
  static const Color info = Color(0xFF2196F3);
  
  // Border & Divider Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFE5E5E5);
  
  // Shadow Colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);
  
  // Disabled Colors
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color disabledText = Color(0xFF9E9E9E);
  
  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
  
  // Card Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x1A000000);
  
  // Input Field Colors
  static const Color inputBackground = Color(0xFFF5F5F5);
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color inputBorderFocused = Color(0xFFE63946);
  
  // Rating/Star Colors
  static const Color rating = Color(0xFFFFB800);
  static const Color ratingEmpty = Color(0xFFE0E0E0);
}

/// App Color Scheme for Material 3
class AppColorScheme {
  static ColorScheme get lightColorScheme => ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.primaryDark,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textOnSecondary,
        secondaryContainer: AppColors.secondaryLight,
        onSecondaryContainer: AppColors.secondaryDark,
        tertiary: AppColors.accent,
        onTertiary: AppColors.textOnPrimary,
        tertiaryContainer: AppColors.accentLight,
        onTertiaryContainer: AppColors.accentDark,
        error: AppColors.error,
        onError: AppColors.textOnPrimary,
        errorContainer: AppColors.error,
        onErrorContainer: AppColors.textOnPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        onSurfaceVariant: AppColors.textSecondary,
        outline: AppColors.border,
        outlineVariant: AppColors.divider,
        shadow: AppColors.shadow,
        scrim: AppColors.overlay,
        inverseSurface: AppColors.textPrimary,
        onInverseSurface: AppColors.surface,
        inversePrimary: AppColors.primaryLight,
        surfaceTint: AppColors.primary,
      );
  
  static ColorScheme get darkColorScheme => ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primaryLight,
        onPrimary: AppColors.textPrimary,
        primaryContainer: AppColors.primaryDark,
        onPrimaryContainer: AppColors.textOnPrimary,
        secondary: AppColors.secondaryLight,
        onSecondary: AppColors.textPrimary,
        secondaryContainer: AppColors.secondaryDark,
        onSecondaryContainer: AppColors.textOnSecondary,
        tertiary: AppColors.accentLight,
        onTertiary: AppColors.textPrimary,
        tertiaryContainer: AppColors.accentDark,
        onTertiaryContainer: AppColors.textOnPrimary,
        error: AppColors.error,
        onError: AppColors.textOnPrimary,
        errorContainer: AppColors.error,
        onErrorContainer: AppColors.textOnPrimary,
        surface: const Color(0xFF1D1D1D),
        onSurface: const Color(0xFFFAFAFA),
        onSurfaceVariant: const Color(0xFFBDBDBD),
        outline: const Color(0xFF6B6B6B),
        outlineVariant: const Color(0xFF4A4A4A),
        shadow: AppColors.shadow,
        scrim: AppColors.overlay,
        inverseSurface: const Color(0xFFFAFAFA),
        onInverseSurface: AppColors.textPrimary,
        inversePrimary: AppColors.primary,
        surfaceTint: AppColors.primaryLight,
      );
}

