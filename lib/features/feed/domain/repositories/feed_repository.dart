import '../../../../core/models/paginated_result.dart';
import '../../../../core/utils/result.dart';
import '../../../topics/domain/entities/topic_entity.dart';

abstract class FeedRepository {
  Future<Result<PaginatedResult<TopicEntity>>> getFeed({int page = 1, int limit = 20});
}
