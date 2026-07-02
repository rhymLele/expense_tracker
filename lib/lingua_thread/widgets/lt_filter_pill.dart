import 'package:flutter/material.dart';

import '../theme/lt_colors.dart';
import '../theme/lt_typography.dart';

class LtFilterPill extends StatelessWidget {
  const LtFilterPill({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? LtColors.ink : Colors.transparent,
          border: active ? null : Border.all(color: LtColors.divider),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: LtTypography.smallMed.copyWith(
            color: active ? Colors.white : LtColors.textMuted,
          ),
        ),
      ),
    );
  }
}
