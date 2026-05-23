import '../../../../core/utils/result.dart';
import '../entities/topic_comment_entity.dart';
import '../repositories/topics_repository.dart';

class AddTopicCommentUseCase {
  final TopicsRepository _repository;
  const AddTopicCommentUseCase(this._repository);

  Future<Result<TopicCommentEntity>> call({
    required String topicId,
    required String content,
    String? parentId,
  }) {
    return _repository.addComment(topicId: topicId, content: content, parentId: parentId);
  }
}
