import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/models/paginated_result.dart';
import '../../../../core/utils/result.dart';
import '../../../topics/domain/entities/topic_entity.dart';
import '../../domain/repositories/feed_repository.dart';
import '../datasources/feed_remote_datasource.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource _dataSource;

  const FeedRepositoryImpl(this._dataSource);

  @override
  Future<Result<PaginatedResult<TopicEntity>>> getFeed({int page = 1, int limit = 20}) async {
    try {
      return Result.success(await _dataSource.getFeed(page: page, limit: limit));
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }
}
