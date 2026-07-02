import 'package:flutter/material.dart';

import '../theme/lt_colors.dart';
import '../theme/lt_typography.dart';

class LtLevelBadge extends StatelessWidget {
  const LtLevelBadge({super.key, required this.level});

  final String level; // e.g. "A1", "B2", "C1"

  Color get _bg {
    final upper = level.toUpperCase();
    if (upper.startsWith('A')) return LtColors.levelABg;
    if (upper.startsWith('B')) return LtColors.levelBBg;
    return LtColors.levelCBg;
  }

  Color get _text {
    final upper = level.toUpperCase();
    if (upper.startsWith('A')) return LtColors.levelAText;
    if (upper.startsWith('B')) return LtColors.levelBText;
    return LtColors.levelCText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        level.toUpperCase(),
        style: LtTypography.label.copyWith(color: _text),
      ),
    );
  }
}
