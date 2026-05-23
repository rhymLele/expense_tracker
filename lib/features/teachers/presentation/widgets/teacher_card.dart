import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';
import '../../domain/entities/teacher_profile_entity.dart';

class TeacherCard extends StatelessWidget {
  final TeacherProfileEntity teacher;
  final VoidCallback onTap;
  const TeacherCard({super.key, required this.teacher, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.paddingSm),
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary,
              backgroundImage: teacher.userAvatarUrl != null
                  ? NetworkImage(teacher.userAvatarUrl!)
                  : null,
              child: teacher.userAvatarUrl == null
                  ? Text(
                      teacher.userName.isNotEmpty
                          ? teacher.userName[0].toUpperCase()
                          : 'T',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.background,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: AppSizes.paddingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(teacher.userName, style: AppTextStyles.titleMedium),
                  const SizedBox(height: AppSizes.paddingXs),
                  if (teacher.subjects.isNotEmpty)
                    Text(
                      teacher.subjects.join(' · '),
                      style: AppTextStyles.labelSmall,
                    ),
                  const SizedBox(height: AppSizes.paddingXs),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: AppColors.warning),
                      const SizedBox(width: 2),
                      Text(
                        teacher.rating.toStringAsFixed(1),
                        style: AppTextStyles.labelSmall,
                      ),
                      const SizedBox(width: AppSizes.paddingSm),
                      Text(
                        '${teacher.reviewCount} đánh giá',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.textHint, size: AppSizes.iconMd),
          ],
        ),
      ),
    );
  }
}
