import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/streak_fire_widget.dart';
import '../../domain/entities/enrollment_entity.dart';

class FocusCard extends StatelessWidget {
  final EnrollmentEntity enrollment;

  const FocusCard({super.key, required this.enrollment});

  @override
  Widget build(BuildContext context) {
    final isCompleted = enrollment.completedAt != null;
    final dayProgress = enrollment.journeyTotalDays > 0
        ? enrollment.currentDay / enrollment.journeyTotalDays
        : 0.0;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSizes.paddingLg,
        AppSizes.paddingLg,
        AppSizes.paddingLg,
        0,
      ),
      decoration: BoxDecoration(
        gradient: isCompleted
            ? null
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2D2C28), Color(0xFF37352F)],
              ),
        color: isCompleted ? AppColors.surface : null,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: isCompleted ? Border.all(color: AppColors.divider) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingSm,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppColors.success.withValues(alpha: 0.12)
                              : AppColors.background.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                        ),
                        child: Text(
                          isCompleted
                              ? 'Hoàn thành'
                              : 'Nhiệm vụ hôm nay',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isCompleted
                                ? AppColors.success
                                : AppColors.background.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingXs),
                      Text(
                        enrollment.journeyTitle,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: isCompleted
                              ? AppColors.textPrimary
                              : AppColors.background,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Ngày ${enrollment.currentDay} / ${enrollment.journeyTotalDays}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isCompleted
                              ? AppColors.textSecondary
                              : AppColors.background.withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSizes.paddingMd),
                StreakFireWidget(
                  streak: enrollment.streak,
                  color: isCompleted
                      ? (enrollment.streak > 0
                          ? const Color(0xFFFF6B2B)
                          : AppColors.textHint)
                      : (enrollment.streak > 0
                          ? const Color(0xFFFFAB76)
                          : AppColors.background.withValues(alpha: 0.4)),
                  size: 22,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingMd),
            // Day progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              child: LinearProgressIndicator(
                value: dayProgress.clamp(0.0, 1.0),
                backgroundColor: isCompleted
                    ? AppColors.divider
                    : AppColors.background.withValues(alpha: 0.18),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isCompleted ? AppColors.success : AppColors.background,
                ),
                minHeight: 3,
              ),
            ),
            if (!isCompleted) ...[
              const SizedBox(height: AppSizes.paddingMd),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.exerciseSession,
                    arguments: enrollment,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.background,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                  ),
                  child: const Text(
                    'Học ngay',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
