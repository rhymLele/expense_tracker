import '../../../../core/base/base_cubit.dart';
import '../../domain/usecases/add_topic_comment_usecase.dart';
import '../../domain/usecases/get_topic_comments_usecase.dart';
import 'comments_state.dart';

class CommentsCubit extends BaseCubit<CommentsState> {
  final GetTopicCommentsUseCase _getComments;
  final AddTopicCommentUseCase _addComment;
  final String topicId;

  CommentsCubit({
    required GetTopicCommentsUseCase getComments,
    required AddTopicCommentUseCase addComment,
    required this.topicId,
  })  : _getComments = getComments,
        _addComment = addComment,
        super(const CommentsState());

  @override
  Future<void> fetchData() => load();

  Future<void> load() async {
    emit(state.copyWith(status: CommentsStatus.loading));
    final result = await _getComments(topicId);
    result.fold(
      (f) => emit(state.copyWith(
        status: CommentsStatus.failure,
        errorMessage: f.message,
      )),
      (comments) => emit(state.copyWith(
        status: CommentsStatus.success,
        comments: comments,
      )),
    );
  }

  Future<void> addComment(String content) async {
    if (content.trim().isEmpty) return;
    emit(state.copyWith(status: CommentsStatus.submitting));
    final result = await _addComment(topicId: topicId, content: content.trim());
    result.fold(
      (f) => emit(state.copyWith(
        status: CommentsStatus.success,
        errorMessage: f.message,
      )),
      (comment) => emit(state.copyWith(
        status: CommentsStatus.success,
        comments: [...state.comments, comment],
      )),
    );
  }
}
