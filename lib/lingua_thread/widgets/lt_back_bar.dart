import 'package:flutter/material.dart';

import '../theme/lt_colors.dart';
import '../theme/lt_typography.dart';

class LtBackBar extends StatelessWidget implements PreferredSizeWidget {
  const LtBackBar({
    super.key,
    this.title,
    this.trailing,
    this.onBack,
  });

  final String? title;
  final Widget? trailing;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(
        color: LtColors.bg,
        border: Border(bottom: BorderSide(color: LtColors.divider)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack ?? () => Navigator.of(context).maybePop(),
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.centerLeft,
              child: const Icon(Icons.arrow_back, size: 20, color: LtColors.ink),
            ),
          ),
          if (title != null) ...[
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title!,
                style: LtTypography.heading,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ] else
            const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
