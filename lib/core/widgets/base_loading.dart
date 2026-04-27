import 'package:flutter/material.dart';
import '../constants/colors.dart';

class BaseLoading extends StatelessWidget {
  final Color? color;
  final double size;

  const BaseLoading({super.key, this.color, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          color: color ?? AppColors.primary,
          strokeWidth: 3,
        ),
      ),
    );
  }
}

class BaseLoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const BaseLoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          const ColoredBox(
            color: Color(0x80000000),
            child: BaseLoading(color: AppColors.background),
          ),
      ],
    );
  }
}
