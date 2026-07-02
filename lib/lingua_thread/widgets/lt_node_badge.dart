import 'package:flutter/material.dart';

import '../theme/lt_colors.dart';
import '../theme/lt_typography.dart';

class LtNodeBadge extends StatelessWidget {
  const LtNodeBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: LtColors.bgMuted,
        border: Border.all(color: LtColors.divider),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label,
        style: LtTypography.micro.copyWith(color: LtColors.textMuted),
      ),
    );
  }
}
