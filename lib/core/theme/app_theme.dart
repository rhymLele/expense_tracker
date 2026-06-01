import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../constants/text_styles.dart';
import 'app_theme_extension.dart';

class AppTheme {
  static ThemeData get light {
    // Noto Sans as base font for all textTheme slots
    final notoTextTheme = GoogleFonts.notoSansTextTheme(
      const TextTheme(
        displayLarge:  AppTextStyles.displayLarge,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge:   AppTextStyles.titleLarge,
        titleMedium:  AppTextStyles.titleMedium,
        bodyLarge:    AppTextStyles.bodyLarge,
        bodyMedium:   AppTextStyles.bodyMedium,
        bodySmall:    AppTextStyles.bodySmall,
        labelLarge:   AppTextStyles.labelLarge,
        labelMedium:  AppTextStyles.labelMedium,
        labelSmall:   AppTextStyles.labelSmall,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.primary50,
        secondary: AppColors.primary600,
        secondaryContainer: AppColors.primary100,
        surface: AppColors.bgMuted,
        error: AppColors.error,
        onPrimary: AppColors.background,
        onSecondary: AppColors.background,
        onSurface: AppColors.textPrimary,
        onError: AppColors.background,
        outline: AppColors.stroke,
        outlineVariant: AppColors.strokeSoft,
      ),
      scaffoldBackgroundColor: AppColors.bgPage,
      textTheme: notoTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.notoSans(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          minimumSize: const Size(88, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary600,
          minimumSize: const Size(88, AppSizes.buttonHeight),
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary600,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgMuted,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: AppColors.stroke),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.background,
        indicatorColor: AppColors.primary50,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final active = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.primary600 : AppColors.textMuted,
          );
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primary50,
        labelStyle: AppTextStyles.chip.copyWith(color: AppColors.primary600),
        side: BorderSide.none,
        shape: const StadiumBorder(),
      ),
      extensions: const [AppThemeExtension.light],
    );
  }

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: Color(0xFF1E1E1E),
          error: AppColors.error,
          onPrimary: AppColors.background,
          onSurface: AppColors.background,
        ),
        scaffoldBackgroundColor: const Color(0xFF101828),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF101828),
          foregroundColor: AppColors.background,
          elevation: 0,
        ),
      );
}
