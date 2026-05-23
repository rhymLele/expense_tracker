import '../../../../core/models/paginated_result.dart';
import '../../../../core/utils/result.dart';
import '../../../topics/domain/entities/topic_entity.dart';
import '../repositories/feed_repository.dart';

class GetFeedUseCase {
  final FeedRepository _repository;
  const GetFeedUseCase(this._repository);

  Future<Result<PaginatedResult<TopicEntity>>> call({int page = 1, int limit = 20}) {
    return _repository.getFeed(page: page, limit: limit);
  }
}
