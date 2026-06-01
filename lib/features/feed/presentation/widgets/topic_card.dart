import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../follows/presentation/cubit/follow_cubit.dart';
import '../../../follows/presentation/cubit/follow_state.dart';
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
            _AuthorRow(topic: topic),
            const SizedBox(height: AppSizes.paddingSm),
            Text(topic.title, style: AppTextStyles.titleMedium),
            if (topic.content != null && topic.content!.isNotEmpty) ...[
              const SizedBox(height: AppSizes.paddingXs),
              Text(
                topic.content!,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: AppSizes.paddingSm),
            _TypeAndStats(topic: topic),
          ],
        ),
      ),
    );
  }
}

class _AuthorRow extends StatelessWidget {
  final TopicEntity topic;
  const _AuthorRow({required this.topic});

  @override
  Widget build(BuildContext context) {
    final displayName = topic.authorName ?? 'Giáo viên';
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'G';

    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.teacherProfile,
            arguments: topic.teacherId,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary,
                backgroundImage: topic.authorAvatarUrl != null
                    ? NetworkImage(topic.authorAvatarUrl!)
                    : null,
                child: topic.authorAvatarUrl == null
                    ? Text(
                        initial,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.background,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: AppSizes.paddingSm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(displayName, style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  )),
                  Text(_timeAgo(topic.createdAt), style: AppTextStyles.labelSmall),
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
        _FollowButton(teacherId: topic.teacherId),
      ],
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }
}

class _TypeAndStats extends StatelessWidget {
  final TopicEntity topic;
  const _TypeAndStats({required this.topic});

  static const _typeLabels = {
    'lesson': ('Bài học', Icons.menu_book_outlined),
    'LESSON': ('Bài học', Icons.menu_book_outlined),
    'exercise': ('Bài tập', Icons.edit_note_outlined),
    'EXERCISE': ('Bài tập', Icons.edit_note_outlined),
    'journey': ('Hành trình', Icons.route_outlined),
    'JOURNEY': ('Hành trình', Icons.route_outlined),
  };

  @override
  Widget build(BuildContext context) {
    final typeInfo = _typeLabels[topic.type];
    return Row(
      children: [
        if (typeInfo != null) ...[
          Icon(typeInfo.$2, size: 13, color: AppColors.textHint),
          const SizedBox(width: 3),
          Text(typeInfo.$1, style: AppTextStyles.labelSmall),
          const SizedBox(width: AppSizes.paddingMd),
        ],
        const Icon(Icons.favorite_border, size: AppSizes.iconSm, color: AppColors.textHint),
        const SizedBox(width: AppSizes.paddingXs),
        Text('${topic.likeCount}', style: AppTextStyles.labelSmall),
        const SizedBox(width: AppSizes.paddingMd),
        const Icon(Icons.chat_bubble_outline, size: AppSizes.iconSm, color: AppColors.textHint),
        const SizedBox(width: AppSizes.paddingXs),
        Text('${topic.commentCount}', style: AppTextStyles.labelSmall),
      ],
    );
  }
}

// ─── Follow Button ──────────────────────────────────────────────────────────

class _FollowButton extends StatelessWidget {
  final String teacherId;
  const _FollowButton({required this.teacherId});

  @override
  Widget build(BuildContext context) {
    // FollowCubit is provided at the HomePage level
    final cubit = context.read<FollowCubit?>();
    if (cubit == null) return const SizedBox.shrink();

    return BlocBuilder<FollowCubit, FollowState>(
      builder: (context, state) {
        final isFollowing = state.isFollowing(teacherId);
        final isPending = state.isPending(teacherId);

        if (isFollowing) {
          return TextButton(
            onPressed: isPending ? null : () => cubit.toggle(teacherId),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingSm,
                vertical: 4,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Đang theo dõi',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          );
        }

        return TextButton(
          onPressed: isPending ? null : () => cubit.toggle(teacherId),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingSm,
              vertical: 4,
            ),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            '+ Theo dõi',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      },
    );
  }
}

/// Standalone follow button for use on teacher profile and discover cards
class FollowButton extends StatelessWidget {
  final String teacherId;
  final bool compact;
  const FollowButton({super.key, required this.teacherId, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FollowCubit?>();
    if (cubit == null) return const SizedBox.shrink();

    return BlocBuilder<FollowCubit, FollowState>(
      builder: (context, state) {
        final isFollowing = state.isFollowing(teacherId);
        final isPending = state.isPending(teacherId);

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isFollowing
              ? OutlinedButton(
                  key: const ValueKey('following'),
                  onPressed: isPending ? null : () => cubit.toggle(teacherId),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.divider),
                    padding: EdgeInsets.symmetric(
                      horizontal: compact ? AppSizes.paddingSm : AppSizes.paddingLg,
                      vertical: compact ? 6 : 10,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    ),
                  ),
                  child: Text(
                    'Đang theo dõi',
                    style: TextStyle(
                      fontSize: compact ? 12 : 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : ElevatedButton(
                  key: const ValueKey('follow'),
                  onPressed: isPending ? null : () => cubit.toggle(teacherId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: compact ? AppSizes.paddingSm : AppSizes.paddingLg,
                      vertical: compact ? 6 : 10,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    ),
                  ),
                  child: Text(
                    'Theo dõi',
                    style: TextStyle(
                      fontSize: compact ? 12 : 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        );
      },
    );
  }
}
