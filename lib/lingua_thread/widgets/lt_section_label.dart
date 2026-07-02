import 'package:flutter/material.dart';

import '../theme/lt_typography.dart';

class LtSectionLabel extends StatelessWidget {
  const LtSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: LtTypography.label,
    );
  }
}
