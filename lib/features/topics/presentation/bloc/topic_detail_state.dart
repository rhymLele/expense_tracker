import '../../../../core/base/base_state.dart';
import '../../domain/entities/topic_entity.dart';
import '../../domain/entities/topic_comment_entity.dart';

class TopicDetailState extends BaseState<TopicDetailState> {
  final TopicEntity? topic;
  final List<TopicCommentEntity> comments;
  final bool isLiked;
  final bool isLikeLoading;
  final bool isCommentSubmitting;

  const TopicDetailState({
    super.status,
    super.error,
    this.topic,
    this.comments = const [],
    this.isLiked = false,
    this.isLikeLoading = false,
    this.isCommentSubmitting = false,
  });

  TopicDetailState copyWith({
    ViewStatus? status,
    TopicEntity? topic,
    List<TopicCommentEntity>? comments,
    bool? isLiked,
    bool? isLikeLoading,
    bool? isCommentSubmitting,
    String? error,
  }) =>
      TopicDetailState(
        status: status ?? this.status,
        topic: topic ?? this.topic,
        comments: comments ?? this.comments,
        isLiked: isLiked ?? this.isLiked,
        isLikeLoading: isLikeLoading ?? this.isLikeLoading,
        isCommentSubmitting: isCommentSubmitting ?? this.isCommentSubmitting,
        error: error,
      );

  @override
  TopicDetailState copyWithBase({ViewStatus? status, String? error}) =>
      copyWith(status: status, error: error);

  int get displayLikeCount {
    final base = topic?.likeCount ?? 0;
    if (isLiked) return base + 1;
    return base;
  }

  @override
  List<Object?> get props => [
        status,
        error,
        topic,
        comments,
        isLiked,
        isLikeLoading,
        isCommentSubmitting,
      ];
}
