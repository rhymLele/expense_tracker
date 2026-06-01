import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';

/// Semantic typography aliases.
/// Use these instead of raw fontSize/fontWeight anywhere in the UI.
/// Example: AppTypography.heading1 instead of TextStyle(fontSize: 29, fontWeight: FontWeight.w700)
abstract final class AppTypography {
  // ─── Display ──────────────────────────────────────────────────────────────
  static const TextStyle display = AppTextStyles.displayLarge;

  // ─── Heading ──────────────────────────────────────────────────────────────
  static const TextStyle heading1 = AppTextStyles.headlineLarge;   // 29 bold
  static const TextStyle heading2 = AppTextStyles.headlineMedium;  // 24 semi-bold
  static const TextStyle heading3 = AppTextStyles.headlineSmall;   // 22 semi-bold

  // ─── Title ────────────────────────────────────────────────────────────────
  static const TextStyle title1 = AppTextStyles.titleLarge;   // 19 semi-bold
  static const TextStyle title2 = AppTextStyles.titleMedium;  // 17 medium

  // ─── Body ─────────────────────────────────────────────────────────────────
  static const TextStyle bodyLg = AppTextStyles.bodyLarge;    // 19 regular
  static const TextStyle bodyText = AppTextStyles.bodyMedium; // 17 regular
  static const TextStyle bodySm = AppTextStyles.bodySmall;    // 14 secondary

  // ─── Label ────────────────────────────────────────────────────────────────
  static const TextStyle label = AppTextStyles.labelLarge;    // 17 medium
  static const TextStyle labelSm = AppTextStyles.labelMedium; // 14 secondary
  static const TextStyle caption = AppTextStyles.labelSmall;  // 12 hint

  // ─── Variants (colour overrides) ──────────────────────────────────────────
  static TextStyle bodyTextMuted =
      AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary);
  static TextStyle captionError =
      AppTextStyles.labelSmall.copyWith(color: AppColors.error);
  static TextStyle captionSuccess =
      AppTextStyles.labelSmall.copyWith(color: AppColors.success);
}
