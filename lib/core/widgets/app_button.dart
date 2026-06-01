import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../constants/text_styles.dart';

/// App-wide button with 3 variants. Inherits style from [AppTheme] by default.
/// All defaults come from the theme — never hardcode values here.
///
/// ```dart
/// AppButton(label: 'Đăng nhập', onPressed: () {})
/// AppButton.outline(label: 'Hủy', onPressed: () {})
/// AppButton.text(label: 'Bỏ qua', onPressed: () {})
/// AppButton(label: 'Đang tải...', isLoading: true, onPressed: null)
/// ```
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double? height;
  final _ButtonVariant _variant;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
  }) : _variant = _ButtonVariant.primary;

  const AppButton.outline({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
  }) : _variant = _ButtonVariant.outline;

  const AppButton.text({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
  }) : _variant = _ButtonVariant.text;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: AppSizes.iconSm,
            height: AppSizes.iconSm,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.background),
            ),
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: AppSizes.iconSm),
                  const SizedBox(width: AppSizes.paddingXs),
                  Text(label),
                ],
              )
            : Text(label);

    final size = Size(width ?? double.infinity, height ?? AppSizes.buttonHeight);

    return switch (_variant) {
      _ButtonVariant.primary => ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(minimumSize: size, maximumSize: size),
          child: child,
        ),
      _ButtonVariant.outline => OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(minimumSize: size, maximumSize: size),
          child: child,
        ),
      _ButtonVariant.text => TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(minimumSize: size, maximumSize: size),
          child: child,
        ),
    };
  }
}

/// Small icon-only button, consistent tap target and style.
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final Color? background;
  final double size;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color,
    this.background,
    this.size = AppSizes.iconBtnSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: background ?? AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: AppSizes.iconSm,
          color: color ?? AppColors.textSecondary,
        ),
      ),
    );
  }
}

enum _ButtonVariant { primary, outline, text }
