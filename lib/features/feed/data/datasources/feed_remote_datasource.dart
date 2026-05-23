import '../../../../core/models/paginated_result.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/base_remote_datasource.dart';
import '../../../../core/network/http_method.dart';
import '../../../topics/data/models/topic_model.dart';

abstract class FeedRemoteDataSource {
  Future<PaginatedResult<TopicModel>> getFeed({int page, int limit});
}

class FeedRemoteDataSourceImpl extends BaseRemoteDataSource
    implements FeedRemoteDataSource {
  @override
  Future<PaginatedResult<TopicModel>> getFeed({
    int page = 1,
    int limit = 20,
  }) async {
    final res = await baseSendRequest(
      ApiConstants.feed,
      HttpMethod.get,
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = res['data'] as List;
    return PaginatedResult(
      items: data
          .map((e) => TopicModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: res['count'] as int? ?? data.length,
    );
  }
}
