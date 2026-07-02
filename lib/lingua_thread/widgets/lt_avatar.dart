import 'package:flutter/material.dart';

import '../theme/lt_colors.dart';
import '../theme/lt_typography.dart';

// Deterministic color palette — keyed by initials pair.
const _kAvatarColors = <String, Color>{
  'SC': Color(0xFFEFE5D5),
  'YT': Color(0xFFD5E5EF),
  'DP': Color(0xFFD5EFDA),
  'MJ': Color(0xFFEFD5E5),
  'LN': Color(0xFFEFEDD5),
  'AR': Color(0xFFD5EFED),
  'AT': Color(0xFFEDE8D5),
  'CR': Color(0xFFE5D5EF),
  'EW': Color(0xFFD5EFDF),
};

Color _bgForInitials(String initials) {
  return _kAvatarColors[initials.toUpperCase()] ??
      Color(0xFFEDE8D5 + (initials.hashCode & 0x0F0F0F));
}

String _toInitials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts[0][0].toUpperCase();
  return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
}

class LtAvatar extends StatelessWidget {
  const LtAvatar({
    super.key,
    required this.name,
    required this.size,
    this.borderWidth = 0,
  });

  final String name;
  final double size;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final initials = _toInitials(name);
    final bg = _bgForInitials(initials);
    final fontSize = size * 0.33;

    Widget circle = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bg,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: LtTypography.label.copyWith(
          fontSize: fontSize,
          color: LtColors.ink,
          letterSpacing: 0,
        ),
      ),
    );

    if (borderWidth > 0) {
      circle = Container(
        width: size + borderWidth * 2,
        height: size + borderWidth * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: LtColors.divider, width: borderWidth),
          color: bg,
        ),
        alignment: Alignment.center,
        child: Text(
          initials,
          style: LtTypography.label.copyWith(
            fontSize: fontSize,
            color: LtColors.ink,
            letterSpacing: 0,
          ),
        ),
      );
    }

    return circle;
  }
}
