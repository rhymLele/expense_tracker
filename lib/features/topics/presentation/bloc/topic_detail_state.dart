import 'package:equatable/equatable.dart';

import '../../domain/entities/topic_entity.dart';
import '../../domain/entities/topic_comment_entity.dart';

enum TopicDetailStatus { initial, loading, success, failure }

class TopicDetailState extends Equatable {
  final TopicDetailStatus status;
  final TopicEntity? topic;
  final List<TopicCommentEntity> comments;
  final bool isLiked;
  final bool isLikeLoading;
  final bool isCommentSubmitting;
  final String? errorMessage;

  const TopicDetailState({
    this.status = TopicDetailStatus.initial,
    this.topic,
    this.comments = const [],
    this.isLiked = false,
    this.isLikeLoading = false,
    this.isCommentSubmitting = false,
    this.errorMessage,
  });

  TopicDetailState copyWith({
    TopicDetailStatus? status,
    TopicEntity? topic,
    List<TopicCommentEntity>? comments,
    bool? isLiked,
    bool? isLikeLoading,
    bool? isCommentSubmitting,
    String? errorMessage,
  }) =>
      TopicDetailState(
        status: status ?? this.status,
        topic: topic ?? this.topic,
        comments: comments ?? this.comments,
        isLiked: isLiked ?? this.isLiked,
        isLikeLoading: isLikeLoading ?? this.isLikeLoading,
        isCommentSubmitting: isCommentSubmitting ?? this.isCommentSubmitting,
        errorMessage: errorMessage,
      );

  int get displayLikeCount {
    final base = topic?.likeCount ?? 0;
    if (isLiked) return base + 1;
    return base;
  }

  @override
  List<Object?> get props => [
        status,
        topic,
        comments,
        isLiked,
        isLikeLoading,
        isCommentSubmitting,
        errorMessage,
      ];
}
