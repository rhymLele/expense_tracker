import 'package:flutter/material.dart';
import '../../../core/base/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/sizes.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/widgets/skeletons/app_skeletons.dart';
import 'bloc/topic_detail_cubit.dart';
import 'bloc/topic_detail_state.dart';
import 'topic_detail_view_model.dart';
import 'widgets/topic_detail_widgets.dart';

class TopicDetailPage extends StatefulWidget {
  const TopicDetailPage({super.key});

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  final _commentController = TextEditingController();

  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      final topicId = ModalRoute.of(context)?.settings.arguments as String?;
      if (topicId != null) {
        context.read<TopicDetailViewModel>().load(topicId);
      }
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: AppColors.background,
      ),
      body: BlocBuilder<TopicDetailCubit, TopicDetailState>(
        builder: (context, state) {
          if (state.status.isLoading) {
            return const TopicDetailSkeleton();
          }
          if (state.status.isFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingXl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: AppColors.textHint),
                    const SizedBox(height: AppSizes.paddingMd),
                    Text(
                      state.error ?? 'Không tải được bài viết',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final topic = state.topic;
          if (topic == null) return const SizedBox.shrink();

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.paddingLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(topic.title, style: AppTextStyles.headlineSmall),
                      const SizedBox(height: AppSizes.paddingSm),
                      Text(
                        '${topic.createdAt.day}/${topic.createdAt.month}/${topic.createdAt.year}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                      if (topic.content != null) ...[
                        const SizedBox(height: AppSizes.paddingLg),
                        Text(topic.content!, style: AppTextStyles.bodyMedium),
                      ],
                      const SizedBox(height: AppSizes.paddingLg),
                      Row(
                        children: [
                          TopicLikeButton(
                            count: state.displayLikeCount,
                            isLiked: state.isLiked,
                            isLoading: state.isLikeLoading,
                            onTap: () => context
                                .read<TopicDetailViewModel>()
                                .toggleLike(),
                          ),
                          const SizedBox(width: AppSizes.paddingMd),
                          const Icon(Icons.chat_bubble_outline,
                              size: AppSizes.iconSm,
                              color: AppColors.textHint),
                          const SizedBox(width: AppSizes.paddingXs),
                          Text(
                            '${state.comments.length}',
                            style: AppTextStyles.labelSmall,
                          ),
                        ],
                      ),
                      const Divider(
                          color: AppColors.divider,
                          height: AppSizes.paddingXl * 2),
                      if (state.comments.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSizes.paddingXl,
                            ),
                            child: Text(
                              'Chưa có bình luận nào',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textHint,
                              ),
                            ),
                          ),
                        )
                      else
                        ...state.comments.map(
                          (c) => TopicCommentItem(comment: c),
                        ),
                      const SizedBox(height: AppSizes.paddingXl),
                    ],
                  ),
                ),
              ),
              TopicCommentInput(
                controller: _commentController,
                isSubmitting: state.isCommentSubmitting,
                onSubmit: () {
                  final text = _commentController.text.trim();
                  if (text.isEmpty) return;
                  context.read<TopicDetailViewModel>().submitComment(text);
                  _commentController.clear();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
