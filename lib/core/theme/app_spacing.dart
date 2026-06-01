import 'package:flutter/material.dart';

/// Semantic spacing constants.
/// Use these instead of raw numbers for all padding/margin/gap values.
/// Example: AppSpacing.md instead of 12.0
abstract final class AppSpacing {
  static const double xs     = 4.0;
  static const double small  = 8.0;
  static const double md     = 12.0;
  static const double medium = 16.0;
  static const double lg     = 20.0;
  static const double large  = 24.0;
  static const double xl     = 32.0;
  static const double xxl    = 40.0;
  static const double xxxl   = 48.0;

  // ─── Common EdgeInsets ────────────────────────────────────────────────────
  static const EdgeInsets pagePadding =
      EdgeInsets.symmetric(horizontal: medium, vertical: medium);
  static const EdgeInsets cardPadding =
      EdgeInsets.all(medium);
  static const EdgeInsets listItemPadding =
      EdgeInsets.symmetric(horizontal: medium, vertical: small);
  static const EdgeInsets inputPadding =
      EdgeInsets.symmetric(horizontal: medium, vertical: md);
  static const EdgeInsets chipPadding =
      EdgeInsets.symmetric(horizontal: small, vertical: xs);
}

/// Vertical / horizontal gap widgets.
/// Prefer these over raw SizedBox to keep spacing semantic.
///
/// ```dart
/// AppGap.md()          // vertical 12px
/// AppGap.md(axis: Axis.horizontal)  // horizontal 12px
/// ```
class AppGap extends StatelessWidget {
  final double size;
  final Axis axis;

  const AppGap(this.size, {super.key, this.axis = Axis.vertical});

  // ─── Named constructors ───────────────────────────────────────────────────
  const AppGap.xs({super.key, this.axis = Axis.vertical}) : size = AppSpacing.xs;
  const AppGap.sm({super.key, this.axis = Axis.vertical}) : size = AppSpacing.small;
  const AppGap.md({super.key, this.axis = Axis.vertical}) : size = AppSpacing.md;
  const AppGap.rg({super.key, this.axis = Axis.vertical}) : size = AppSpacing.medium;
  const AppGap.lg({super.key, this.axis = Axis.vertical}) : size = AppSpacing.lg;
  const AppGap.xl({super.key, this.axis = Axis.vertical}) : size = AppSpacing.large;
  const AppGap.xxl({super.key, this.axis = Axis.vertical}) : size = AppSpacing.xl;

  @override
  Widget build(BuildContext context) => axis == Axis.vertical
      ? SizedBox(height: size)
      : SizedBox(width: size);
}
