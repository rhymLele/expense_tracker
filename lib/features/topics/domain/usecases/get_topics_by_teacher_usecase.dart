import '../../../../core/models/paginated_result.dart';
import '../../../../core/utils/result.dart';
import '../entities/topic_entity.dart';
import '../repositories/topics_repository.dart';

class GetTopicsByTeacherUseCase {
  final TopicsRepository _repository;
  const GetTopicsByTeacherUseCase(this._repository);

  Future<Result<PaginatedResult<TopicEntity>>> call(
    String teacherId, {
    int page = 1,
    int limit = 20,
  }) {
    return _repository.getTopicsByTeacher(teacherId, page: page, limit: limit);
  }
}
