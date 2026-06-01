import '../../../../core/models/paginated_result.dart';
import '../../../../core/utils/result.dart';
import '../entities/topic_comment_entity.dart';
import '../entities/topic_entity.dart';

abstract class TopicsRepository {
  Future<Result<TopicEntity>> getTopic(String id);

  Future<Result<PaginatedResult<TopicEntity>>> getTopicsByTeacher(
    String teacherId, {
    int page = 1,
    int limit = 20,
  });

  Future<Result<TopicEntity>> createTopic({
    required String type,
    required String title,
    String? description,
    String? visibility,
  });

  Future<Result<void>> toggleLike(String topicId);

  Future<Result<List<TopicCommentEntity>>> getComments(String topicId);

  Future<Result<TopicCommentEntity>> addComment({
    required String topicId,
    required String content,
    String? parentId,
  });
}
