import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'lt_colors.dart';

// All styles use DM Sans (google_fonts). Not const — runtime construction.
abstract final class LtTypography {
  static TextStyle get pageTitle => GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: LtColors.ink,
      );

  static TextStyle get title => GoogleFonts.dmSans(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: LtColors.ink,
      );

  static TextStyle get heading => GoogleFonts.dmSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: LtColors.ink,
      );

  static TextStyle get body => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.65,
        color: LtColors.ink,
      );

  static TextStyle get bodyMed => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: LtColors.ink,
      );

  static TextStyle get bodyBold => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: LtColors.ink,
      );

  static TextStyle get small => GoogleFonts.dmSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: LtColors.textMuted,
      );

  static TextStyle get smallMed => GoogleFonts.dmSans(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: LtColors.textMuted,
      );

  static TextStyle get smallBold => GoogleFonts.dmSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: LtColors.ink,
      );

  static TextStyle get caption => GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: LtColors.textLight,
      );

  static TextStyle get label => GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: LtColors.textLight,
      );

  static TextStyle get micro => GoogleFonts.dmSans(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: LtColors.textLight,
      );
}
