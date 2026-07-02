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

    // Backend feed returns: { data: { topics: { items: [...], total: N }, roadmaps, posts } }
    final rawData = res['data'];
    final List dataList;
    final int count;

    if (rawData is List) {
      // Flat list (unlikely for feed but handle gracefully)
      dataList = rawData;
      count = res['count'] as int? ?? dataList.length;
    } else if (rawData is Map) {
      // Feed envelope: { topics: { items, total }, roadmaps, posts }
      final topicsNode = rawData['topics'];
      if (topicsNode is Map) {
        dataList = (topicsNode['items'] as List?) ?? [];
        count = topicsNode['total'] as int? ??
            topicsNode['count'] as int? ??
            dataList.length;
      } else if (topicsNode is List) {
        dataList = topicsNode;
        count = dataList.length;
      } else {
        // Fallback: flat items/data key
        final nested = rawData['items'] ?? rawData['data'] ?? [];
        dataList = nested is List ? nested : [];
        count = (rawData['total'] ?? rawData['count'] ?? res['count'] ?? dataList.length) as int;
      }
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
