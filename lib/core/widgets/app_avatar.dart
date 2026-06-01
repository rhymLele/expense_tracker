import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../constants/text_styles.dart';

/// Unified avatar widget. Priority: networkImage > initials > icon.
///
/// ```dart
/// AppAvatar(imageUrl: user.avatarUrl, name: user.name)          // sm (32)
/// AppAvatar.md(imageUrl: user.avatarUrl, name: user.name)       // md (44)
/// AppAvatar.lg(imageUrl: user.avatarUrl, name: user.name)       // lg (64)
/// AppAvatar(radius: 20, name: 'Trần Minh')                      // custom
/// ```
class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double radius;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool showOnline;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.radius = AppSizes.avatarSm,
    this.backgroundColor,
    this.onTap,
    this.showOnline = false,
  });

  const AppAvatar.sm({
    super.key,
    this.imageUrl,
    this.name,
    this.backgroundColor,
    this.onTap,
    this.showOnline = false,
  }) : radius = AppSizes.avatarSm;

  const AppAvatar.md({
    super.key,
    this.imageUrl,
    this.name,
    this.backgroundColor,
    this.onTap,
    this.showOnline = false,
  }) : radius = AppSizes.avatarMd;

  const AppAvatar.lg({
    super.key,
    this.imageUrl,
    this.name,
    this.backgroundColor,
    this.onTap,
    this.showOnline = false,
  }) : radius = AppSizes.avatarLg;

  @override
  Widget build(BuildContext context) {
    Widget avatar = CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? AppColors.primary,
      backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
          ? NetworkImage(imageUrl!)
          : null,
      onBackgroundImageError: imageUrl != null
          ? (_, __) {} // silently ignore broken images
          : null,
      child: imageUrl == null || imageUrl!.isEmpty
          ? _buildFallback()
          : null,
    );

    if (showOnline) {
      avatar = Stack(
        children: [
          avatar,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: radius * 0.5,
              height: radius * 0.5,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 1.5),
              ),
            ),
          ),
        ],
      );
    }

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: avatar);
    }
    return avatar;
  }

  Widget _buildFallback() {
    if (name != null && name!.isNotEmpty) {
      return Text(
        _initials(name!),
        style: _initialsStyle(),
      );
    }
    return Icon(
      Icons.person,
      size: radius * 0.9,
      color: AppColors.background,
    );
  }

  String _initials(String n) {
    final parts = n.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return n.trim().substring(0, n.trim().length.clamp(0, 2)).toUpperCase();
  }

  TextStyle _initialsStyle() {
    if (radius <= 20) return AppTextStyles.labelSmall.copyWith(color: AppColors.background);
    if (radius <= 28) return AppTextStyles.labelMedium.copyWith(color: AppColors.background);
    if (radius <= 36) return AppTextStyles.titleMedium.copyWith(color: AppColors.background);
    return AppTextStyles.headlineMedium.copyWith(color: AppColors.background);
  }
}
