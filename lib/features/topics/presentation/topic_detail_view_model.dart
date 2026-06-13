import '../../../core/base/base_view_model.dart';
import '../domain/usecases/get_topic_usecase.dart';
import '../domain/usecases/get_topic_comments_usecase.dart';
import '../domain/usecases/toggle_like_usecase.dart';
import '../domain/usecases/add_topic_comment_usecase.dart';
import 'bloc/topic_detail_cubit.dart';

class TopicDetailViewModel extends BaseViewModel<TopicDetailCubit> {
  TopicDetailViewModel({
    required GetTopicUseCase getTopic,
    required GetTopicCommentsUseCase getComments,
    required ToggleLikeUseCase toggleLike,
    required AddTopicCommentUseCase addComment,
  }) : super(TopicDetailCubit(
          getTopic: getTopic,
          getComments: getComments,
          toggleLike: toggleLike,
          addComment: addComment,
        ));

  void load(String topicId) => bloc.load(topicId);

  void toggleLike() => bloc.toggleLike();

  void submitComment(String content) => bloc.submitComment(content);
}
