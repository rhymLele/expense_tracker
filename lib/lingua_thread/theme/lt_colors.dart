import 'package:flutter/material.dart';

abstract final class LtColors {
  // ─── Core palette ─────────────────────────────────────────────────────────
  static const Color ink       = Color(0xFF37352F); // primary text, buttons, active
  static const Color bg        = Color(0xFFFFFFFF); // main background
  static const Color bgSubtle  = Color(0xFFFBFBFA); // cards, sections
  static const Color bgMuted   = Color(0xFFF7F6F3); // inputs, muted surfaces
  static const Color divider   = Color(0xFFEDECE9); // all dividers & borders
  static const Color textMuted = Color(0xFF787774); // secondary text
  static const Color textLight = Color(0xFF9B9A97); // tertiary / placeholders
  static const Color textDim   = Color(0xFFAEACA7); // disabled, rank numbers

  // ─── Gemma (reputation currency) ──────────────────────────────────────────
  static const Color gemmaBg   = Color(0xFFFEF9EC);
  static const Color gemmaText = Color(0xFFA37010);
  static const Color gemmaBord = Color(0xFFF5E0A0);

  // ─── Streak / fire ────────────────────────────────────────────────────────
  static const Color streakBg  = Color(0xFFFEF4EF);
  static const Color streakText = Color(0xFFC2410C);

  // ─── CEFR level badges ────────────────────────────────────────────────────
  static const Color levelABg  = Color(0xFFE8F5E8);
  static const Color levelAText = Color(0xFF1E6B1E);
  static const Color levelBBg  = Color(0xFFEAF2FB);
  static const Color levelBText = Color(0xFF1A4E8F);
  static const Color levelCBg  = Color(0xFFF3ECF9);
  static const Color levelCText = Color(0xFF5E2F8F);

  // ─── Quiz feedback ────────────────────────────────────────────────────────
  static const Color correctBg   = Color(0xFFE8F5E8);
  static const Color correctText = Color(0xFF1A5C1A);
  static const Color correctBord = Color(0xFFA8D8A8);
  static const Color wrongBg     = Color(0xFFFDEEEE);
  static const Color wrongText   = Color(0xFF8B1A1A);
  static const Color wrongBord   = Color(0xFFF5B8B8);

  // ─── Recording ────────────────────────────────────────────────────────────
  static const Color recordRed = Color(0xFFE53E3E);

  // ─── Misc ─────────────────────────────────────────────────────────────────
  static const Color surfaceHigh = Color(0xFFF1F0EF); // disabled button bg
  static const Color bgFafafa    = Color(0xFFFAFAFA); // unread notif / current node row
}
