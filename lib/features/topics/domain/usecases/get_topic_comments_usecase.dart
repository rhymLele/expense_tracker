import '../../../../core/utils/result.dart';
import '../entities/topic_comment_entity.dart';
import '../repositories/topics_repository.dart';

class GetTopicCommentsUseCase {
  final TopicsRepository _repository;
  const GetTopicCommentsUseCase(this._repository);
  Future<Result<List<TopicCommentEntity>>> call(String topicId) =>
      _repository.getComments(topicId);
}
