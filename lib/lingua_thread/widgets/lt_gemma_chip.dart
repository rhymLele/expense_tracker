import 'package:flutter/material.dart';

import '../theme/lt_colors.dart';
import '../theme/lt_typography.dart';

enum GemmaChipSize { sm, lg }

class LtGemmaChip extends StatelessWidget {
  const LtGemmaChip({
    super.key,
    required this.value,
    this.chipSize = GemmaChipSize.sm,
  });

  final int value;
  final GemmaChipSize chipSize;

  String get _formatted {
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}k';
    return value.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLg = chipSize == GemmaChipSize.lg;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLg ? 8 : 7,
        vertical: isLg ? 3 : 2,
      ),
      decoration: BoxDecoration(
        color: LtColors.gemmaBg,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        '◆ $_formatted',
        style: (isLg ? LtTypography.smallBold : LtTypography.label).copyWith(
          color: LtColors.gemmaText,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class LtStreakChip extends StatelessWidget {
  const LtStreakChip({super.key, required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: LtColors.streakBg,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        '🔥 ${days}d',
        style: LtTypography.smallBold.copyWith(color: LtColors.streakText),
      ),
    );
  }
}
