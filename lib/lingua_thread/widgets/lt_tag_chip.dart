import 'package:flutter/material.dart';

import '../theme/lt_colors.dart';
import '../theme/lt_typography.dart';

class LtTagChip extends StatelessWidget {
  const LtTagChip({super.key, required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: LtColors.surfaceHigh,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        tag.startsWith('#') ? tag : '#$tag',
        style: LtTypography.micro.copyWith(color: LtColors.textMuted, fontWeight: FontWeight.w500),
      ),
    );
  }
}
