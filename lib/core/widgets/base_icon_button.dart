import 'package:flutter/material.dart';
import 'base_loading.dart';
import '../constants/colors.dart';
import '../constants/sizes.dart';

class BaseIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? loadingColor;
  final double? loadingSize;
  final EdgeInsetsGeometry? padding;

  const BaseIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.isLoading = false,
    this.loadingColor,
    this.loadingSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: padding ?? const EdgeInsets.all(AppSizes.paddingSm),
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? BaseLoading(
              color: loadingColor ?? AppColors.textHint,
              size: loadingSize ?? 20,
            )
          : icon,
    );
  }
}
