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

    // Handle both flat { data: [...], count: N }
    // and nested { data: { data/items: [...], count/total: N } }
    final rawData = res['data'];
    final List dataList;
    final int count;

    if (rawData is List) {
      dataList = rawData;
      count = res['count'] as int? ?? dataList.length;
    } else if (rawData is Map) {
      final nested = rawData['data'] ?? rawData['items'] ?? rawData['topics'] ?? [];
      dataList = nested is List ? nested : [];
      count = (rawData['count'] ?? rawData['total'] ?? res['count'] ?? dataList.length) as int;
    } else {
      dataList = [];
      count = 0;
    }

    return PaginatedResult(
      items: dataList
          .map((e) => TopicModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: count,
    );
  }
}
