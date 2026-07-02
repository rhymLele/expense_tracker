import 'package:equatable/equatable.dart';

import '../../domain/entities/topic_comment_entity.dart';

enum CommentsStatus { initial, loading, success, failure, submitting }

class CommentsState extends Equatable {
  final CommentsStatus status;
  final List<TopicCommentEntity> comments;
  final String? errorMessage;

  const CommentsState({
    this.status = CommentsStatus.initial,
    this.comments = const [],
    this.errorMessage,
  });

  CommentsState copyWith({
    CommentsStatus? status,
    List<TopicCommentEntity>? comments,
    String? errorMessage,
  }) =>
      CommentsState(
        status: status ?? this.status,
        comments: comments ?? this.comments,
        errorMessage: errorMessage,
      );

  bool get isLoading => status == CommentsStatus.loading;
  bool get isSubmitting => status == CommentsStatus.submitting;

  @override
  List<Object?> get props => [status, comments, errorMessage];
}
