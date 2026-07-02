import 'package:flutter/material.dart';

import '../theme/lt_colors.dart';
import '../theme/lt_spacing.dart';
import '../theme/lt_typography.dart';

class LtPrimaryButton extends StatelessWidget {
  const LtPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.disabled = false,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool disabled;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final bg = disabled ? LtColors.surfaceHigh : LtColors.ink;
    final fg = disabled ? LtColors.textLight : Colors.white;

    Widget btn = GestureDetector(
      onTap: disabled ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(LtSpacing.radius),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: LtTypography.heading.copyWith(fontSize: 15, color: fg),
        ),
      ),
    );

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: btn);
    }
    return btn;
  }
}

/// Outlined secondary button (e.g. "Continue", enrolled state).
class LtOutlinedButton extends StatelessWidget {
  const LtOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: LtColors.bgMuted,
          border: Border.all(color: LtColors.divider),
          borderRadius: BorderRadius.circular(LtSpacing.radius),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: LtTypography.smallBold.copyWith(color: LtColors.ink),
        ),
      ),
    );
  }
}
