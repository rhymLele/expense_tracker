import 'package:flutter/material.dart';

/// LearnSpace design tokens — mint green brand (#5CC691).
/// Mapped 1-to-1 from tokens.css.
class AppColors {
  // ─── Primary (mint green) ────────────────────────────────────────────────────
  static const primary50  = Color(0xFFEFF9F4);
  static const primary100 = Color(0xFFDDF3E5);
  static const primary200 = Color(0xFFCCEDDD);
  static const primary300 = Color(0xFF7DD1A7);
  static const primary400 = Color(0xFF6FCC9C);
  static const primary    = Color(0xFF5CC691); // 500 — MAIN
  static const primary600 = Color(0xFF418D67); // hover
  static const primary700 = Color(0xFF356F52); // pressed
  static const primary800 = Color(0xFF255053);

  // ─── Purple (tag / group) ───────────────────────────────────────────────────
  static const purple50  = Color(0xFFF4EFFE);
  static const purple300 = Color(0xFFB399EC);
  static const purple500 = Color(0xFF764FDB);
  static const purple700 = Color(0xFF4F2EA3);

  // ─── Accent ────────────────────────────────────────────────────────────────
  static const teal    = Color(0xFF449297);
  static const orange  = Color(0xFFE37E36);
  static const info    = Color(0xFF2A6FDB);

  // ─── Semantic ──────────────────────────────────────────────────────────────
  static const success    = Color(0xFF5CC691);
  static const success700 = Color(0xFF418D67);

  static const warning    = Color(0xFFE37E36);
  static const warning700 = Color(0xFFB0860B);
  static const warning50  = Color(0xFFFFFAE7);

  // Flame amber — streak fire icon on green hero background
  static const flameAmber = Color(0xFFFFD89E);

  static const error      = Color(0xFFEB5146); // danger-500
  static const error700   = Color(0xFFB83A30); // danger-700
  static const error50    = Color(0xFFFFEBEA); // danger-50

  // ─── Background / Surface ──────────────────────────────────────────────────
  static const background = Color(0xFFFFFFFF); // white
  static const bgPage     = Color(0xFFF7F7F7); // --color-bg-page
  static const bgMuted    = Color(0xFFF5F5F5); // --color-bg-muted

  static const surface     = Color(0xFFF5F5F5); // alias for bgMuted
  static const surfaceHover = Color(0xFFEEEEEE); // stroke-soft

  // ─── Stroke / Divider ──────────────────────────────────────────────────────
  static const strokeSoft   = Color(0xFFEEEEEE);
  static const stroke       = Color(0xFFEAEAEA);
  static const strokeStrong = Color(0xFFE3E8EF);
  static const divider      = Color(0xFFE7E7ED);

  // ─── Text ──────────────────────────────────────────────────────────────────
  static const textPrimary     = Color(0xFF101828); // --color-fg
  static const textSecondary   = Color(0xFF364152); // --color-fg-secondary
  static const textMuted       = Color(0xFF697586); // --color-fg-muted
  static const textHint        = Color(0xFF9DA4AE); // --color-fg-placeholder
  static const textDisabled    = Color(0xFFB0B0B0); // --color-fg-disabled

  // ─── Shadows (as BoxShadow lists for convenience) ──────────────────────────
  static const List<BoxShadow> shadowSm = [
    BoxShadow(color: Color(0x26101828), blurRadius: 1, offset: Offset(0, 1)),
  ];
  static const List<BoxShadow> shadowMd = [
    BoxShadow(color: Color(0x14101828), blurRadius: 4, offset: Offset(0, 2)),
    BoxShadow(color: Color(0x0F101828), blurRadius: 2, offset: Offset(0, 1)),
  ];
  static const List<BoxShadow> shadowLg = [
    BoxShadow(color: Color(0x14101828), blurRadius: 16, offset: Offset(0, 8)),
    BoxShadow(color: Color(0x0F101828), blurRadius: 4, offset: Offset(0, 2)),
  ];
  static const List<BoxShadow> shadowMintGlow = [
    BoxShadow(color: Color(0x595CC691), blurRadius: 12, offset: Offset(0, 4)),
  ];
}
