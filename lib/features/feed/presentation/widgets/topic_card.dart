import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../topics/domain/entities/topic_entity.dart';

class TopicCard extends StatelessWidget {
  final TopicEntity topic;
  const TopicCard({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.topicDetail,
        arguments: topic.id,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.surface,
                  child: Text(
                    topic.teacherId.isNotEmpty
                        ? topic.teacherId[0].toUpperCase()
                        : 'T',
                    style: AppTextStyles.labelMedium
                        .copyWith(color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(width: AppSizes.paddingSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Giáo viên', style: AppTextStyles.labelMedium),
                      Text(_timeAgo(topic.createdAt),
                          style: AppTextStyles.labelSmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingSm),
            Text(topic.title, style: AppTextStyles.titleMedium),
            if (topic.content != null) ...[
              const SizedBox(height: AppSizes.paddingXs),
              Text(
                topic.content!,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textHint),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: AppSizes.paddingSm),
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

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }
}
