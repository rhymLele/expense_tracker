import 'package:flutter/material.dart';

/// Notion-inspired color palette.
/// Đặc trưng: đen ấm (#37352F thay vì #000), nền trắng tinh, surface kem nhẹ.
class AppColors {
  // ─── Core ─────────────────────────────────────────────────────────────────
  static const primary        = Color(0xFF37352F); // Notion warm black
  static const primaryDark    = Color(0xFF191919); // Notion dark mode bg
  static const secondary      = Color(0xFF787774); // Notion gray
  // ─── Background / Surface ─────────────────────────────────────────────────
  static const background     = Color(0xFFFFFFFF); // Notion page bg
  static const backgroundDark = Color(0xFF191919); // Notion dark bg
  static const surface        = Color(0xFFF7F6F3); // Notion sidebar/card
  static const surfaceHover   = Color(0xFFF1F1EF); // Notion hover state
  // ─── Text ─────────────────────────────────────────────────────────────────
  static const textPrimary    = Color(0xFF37352F); // Notion main text
  static const textSecondary  = Color(0xFF787774); // Notion muted text
  static const textHint       = Color(0xFF9B9A97); // Notion placeholder
  // ─── Semantic ─────────────────────────────────────────────────────────────
  static const error          = Color(0xFFE03E3E); // Notion red
  static const success        = Color(0xFF0F7B6C); // Notion green
  static const warning        = Color(0xFFDFAB01); // Notion yellow
  // ─── UI ───────────────────────────────────────────────────────────────────
  static const divider        = Color(0xFFE9E9E7); // Notion border
  static const transparent    = Colors.transparent;
}
