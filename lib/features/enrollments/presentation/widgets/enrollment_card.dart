import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';
import '../../domain/entities/enrollment_entity.dart';

class EnrollmentCard extends StatelessWidget {
  final EnrollmentEntity enrollment;
  const EnrollmentCard({super.key, required this.enrollment});

  @override
  Widget build(BuildContext context) {
    final progress = enrollment.journeyTotalDays > 0
        ? enrollment.currentDay / enrollment.journeyTotalDays
        : 0.0;
    final isCompleted = enrollment.completedAt != null;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingSm),
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.surface : AppColors.primary,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: isCompleted ? Border.all(color: AppColors.divider) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  enrollment.journeyTitle,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: isCompleted
                        ? AppColors.textPrimary
                        : AppColors.background,
                  ),
                ),
              ),
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingSm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                  child: Text(
                    'Hoàn thành',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingXs),
          Text(
            'Ngày ${enrollment.currentDay} / ${enrollment.journeyTotalDays}',
            style: AppTextStyles.labelSmall.copyWith(
              color: isCompleted
                  ? AppColors.textSecondary
                  : AppColors.background.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: AppSizes.paddingMd),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: isCompleted
                  ? AppColors.divider
                  : AppColors.background.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                isCompleted ? AppColors.success : AppColors.background,
              ),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: AppSizes.paddingXs),
          Row(
            children: [
              Text(
                '${(progress * 100).round()}% hoàn thành',
                style: AppTextStyles.labelSmall.copyWith(
                  color: isCompleted
                      ? AppColors.textSecondary
                      : AppColors.background.withValues(alpha: 0.7),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.local_fire_department,
                size: AppSizes.iconSm,
                color: isCompleted
                    ? AppColors.textHint
                    : AppColors.background.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 2),
              Text(
                '${enrollment.streak} ngày',
                style: AppTextStyles.labelSmall.copyWith(
                  color: isCompleted
                      ? AppColors.textSecondary
                      : AppColors.background.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
