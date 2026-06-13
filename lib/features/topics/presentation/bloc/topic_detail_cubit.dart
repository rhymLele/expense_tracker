import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_topic_usecase.dart';
import '../../domain/usecases/get_topic_comments_usecase.dart';
import '../../domain/usecases/toggle_like_usecase.dart';
import '../../domain/usecases/add_topic_comment_usecase.dart';
import 'topic_detail_state.dart';

class TopicDetailCubit extends Cubit<TopicDetailState> {
  final GetTopicUseCase _getTopic;
  final GetTopicCommentsUseCase _getComments;
  final ToggleLikeUseCase _toggleLike;
  final AddTopicCommentUseCase _addComment;

  TopicDetailCubit({
    required GetTopicUseCase getTopic,
    required GetTopicCommentsUseCase getComments,
    required ToggleLikeUseCase toggleLike,
    required AddTopicCommentUseCase addComment,
  })  : _getTopic = getTopic,
        _getComments = getComments,
        _toggleLike = toggleLike,
        _addComment = addComment,
        super(const TopicDetailState());

  Future<void> load(String topicId) async {
    emit(state.copyWith(status: TopicDetailStatus.loading));

    final topicResult = await _getTopic(topicId);
    await topicResult.fold(
      (f) async => emit(state.copyWith(
        status: TopicDetailStatus.failure,
        errorMessage: f.message,
      )),
      (topic) async {
        final commentsResult = await _getComments(topicId);
        commentsResult.fold(
          (_) => emit(state.copyWith(
            status: TopicDetailStatus.success,
            topic: topic,
          )),
          (comments) => emit(state.copyWith(
            status: TopicDetailStatus.success,
            topic: topic,
            comments: comments,
          )),
        );
      },
    );
  }

  Future<void> toggleLike() async {
    if (state.topic == null || state.isLikeLoading) return;

    final wasLiked = state.isLiked;
    emit(state.copyWith(isLiked: !wasLiked, isLikeLoading: true));

    final result = await _toggleLike(state.topic!.id);
    result.fold(
      (_) => emit(state.copyWith(isLiked: wasLiked, isLikeLoading: false)),
      (_) => emit(state.copyWith(isLikeLoading: false)),
    );
  }

  Future<void> submitComment(String content) async {
    if (state.topic == null || content.trim().isEmpty) return;
    emit(state.copyWith(isCommentSubmitting: true));

    final result = await _addComment(
      topicId: state.topic!.id,
      content: content.trim(),
    );
    result.fold(
      (_) => emit(state.copyWith(isCommentSubmitting: false)),
      (comment) => emit(state.copyWith(
        isCommentSubmitting: false,
        comments: [...state.comments, comment],
      )),
    );
  }
}
