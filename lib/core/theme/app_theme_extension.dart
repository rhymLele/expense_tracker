import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Custom ThemeExtension that exposes design-system tokens via BuildContext.
/// Registered in AppTheme.light / dark.
///
/// Usage:
///   context.appTypo.heading1
///   context.appSpacing.medium
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final _TypographyTokens typography;
  final _SpacingTokens spacing;
  final _ColorTokens colors;

  const AppThemeExtension({
    required this.typography,
    required this.spacing,
    required this.colors,
  });

  static const light = AppThemeExtension(
    typography: _TypographyTokens(),
    spacing: _SpacingTokens(),
    colors: _ColorTokens(),
  );

  @override
  AppThemeExtension copyWith({
    _TypographyTokens? typography,
    _SpacingTokens? spacing,
    _ColorTokens? colors,
  }) =>
      AppThemeExtension(
        typography: typography ?? this.typography,
        spacing: spacing ?? this.spacing,
        colors: colors ?? this.colors,
      );

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) => this;
}

extension AppThemeContext on BuildContext {
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>() ?? AppThemeExtension.light;
  _TypographyTokens get appTypo => appTheme.typography;
  _SpacingTokens get appSpacing => appTheme.spacing;
  _ColorTokens get appColors => appTheme.colors;
}

// ─── Token bundles ────────────────────────────────────────────────────────────

class _TypographyTokens {
  const _TypographyTokens();

  TextStyle get display   => AppTypography.display;
  TextStyle get heading1  => AppTypography.heading1;
  TextStyle get heading2  => AppTypography.heading2;
  TextStyle get heading3  => AppTypography.heading3;
  TextStyle get title1    => AppTypography.title1;
  TextStyle get title2    => AppTypography.title2;
  TextStyle get bodyLg    => AppTypography.bodyLg;
  TextStyle get bodyText  => AppTypography.bodyText;
  TextStyle get bodySm    => AppTypography.bodySm;
  TextStyle get label     => AppTypography.label;
  TextStyle get labelSm   => AppTypography.labelSm;
  TextStyle get caption   => AppTypography.caption;
}

class _SpacingTokens {
  const _SpacingTokens();

  double get xs     => AppSpacing.xs;
  double get small  => AppSpacing.small;
  double get md     => AppSpacing.md;
  double get medium => AppSpacing.medium;
  double get lg     => AppSpacing.lg;
  double get large  => AppSpacing.large;
  double get xl     => AppSpacing.xl;
  double get xxl    => AppSpacing.xxl;

  EdgeInsets get page     => AppSpacing.pagePadding;
  EdgeInsets get card     => AppSpacing.cardPadding;
  EdgeInsets get listItem => AppSpacing.listItemPadding;
}

class _ColorTokens {
  const _ColorTokens();

  Color get primary   => AppColors.primary;
  Color get error     => AppColors.error;
  Color get success   => AppColors.success;
  Color get warning   => AppColors.warning;
  Color get textPrimary   => AppColors.textPrimary;
  Color get textSecondary => AppColors.textSecondary;
  Color get textHint      => AppColors.textHint;
  Color get surface       => AppColors.surface;
  Color get divider       => AppColors.divider;
}
