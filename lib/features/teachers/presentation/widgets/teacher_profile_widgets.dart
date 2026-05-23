import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../topics/domain/entities/topic_entity.dart';

class TeacherProfileBody extends StatelessWidget {
  final List<String> subjects;
  final String teachingMode;
  final double rating;
  final int reviewCount;

  const TeacherProfileBody({
    super.key,
    required this.subjects,
    required this.teachingMode,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (subjects.isNotEmpty) ...[
            const Text('Môn học', style: AppTextStyles.labelMedium),
            const SizedBox(height: AppSizes.paddingXs),
            Wrap(
              spacing: AppSizes.paddingXs,
              runSpacing: AppSizes.paddingXs,
              children: subjects.map((s) => TeacherSubjectChip(label: s)).toList(),
            ),
            const SizedBox(height: AppSizes.paddingLg),
          ],
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TeacherStat(
                    icon: Icons.star,
                    value: rating.toStringAsFixed(1),
                    label: 'Đánh giá',
                  ),
                ),
                Container(width: 1, height: 40, color: AppColors.divider),
                Expanded(
                  child: TeacherStat(
                    icon: Icons.rate_review_outlined,
                    value: '$reviewCount',
                    label: 'Nhận xét',
                  ),
                ),
                Container(width: 1, height: 40, color: AppColors.divider),
                Expanded(
                  child: TeacherStat(
                    icon: Icons.laptop_outlined,
                    value: teachingMode == 'online' ? 'Online' : 'Offline',
                    label: 'Hình thức',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TeacherSubjectChip extends StatelessWidget {
  final String label;
  const TeacherSubjectChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSm,
        vertical: AppSizes.paddingXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: Border.all(color: AppColors.divider),
      ),
      child: Text(label, style: AppTextStyles.labelSmall),
    );
  }
}

class TeacherStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const TeacherStat({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: AppSizes.iconSm, color: AppColors.primary),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.titleMedium),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class TeacherTopicRow extends StatelessWidget {
  final TopicEntity topic;
  final VoidCallback onTap;
  const TeacherTopicRow({super.key, required this.topic, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(topic.title, style: AppTextStyles.titleMedium),
            if (topic.content != null) ...[
              const SizedBox(height: AppSizes.paddingXs),
              Text(
                topic.content!,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: AppSizes.paddingXs),
            Row(
              children: [
                const Icon(Icons.favorite_border,
                    size: AppSizes.iconSm, color: AppColors.textHint),
                const SizedBox(width: AppSizes.paddingXs),
                Text('${topic.likeCount}', style: AppTextStyles.labelSmall),
                const SizedBox(width: AppSizes.paddingMd),
                const Icon(Icons.chat_bubble_outline,
                    size: AppSizes.iconSm, color: AppColors.textHint),
                const SizedBox(width: AppSizes.paddingXs),
                Text('${topic.commentCount}', style: AppTextStyles.labelSmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
