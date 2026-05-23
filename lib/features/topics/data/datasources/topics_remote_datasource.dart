import '../../../../core/models/paginated_result.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/base_remote_datasource.dart';
import '../../../../core/network/http_method.dart';
import '../models/topic_comment_model.dart';
import '../models/topic_model.dart';

abstract class TopicsRemoteDataSource {
  Future<TopicModel> getTopic(String id);
  Future<PaginatedResult<TopicModel>> getTopicsByTeacher(String teacherId,
      {int page, int limit});
  Future<void> toggleLike(String topicId);
  Future<List<TopicCommentModel>> getComments(String topicId);
  Future<TopicCommentModel> addComment({
    required String topicId,
    required String content,
    String? parentId,
  });
}

class TopicsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements TopicsRemoteDataSource {
  @override
  Future<TopicModel> getTopic(String id) async {
    final res = await baseSendRequest(ApiConstants.topicById(id), HttpMethod.get);
    return TopicModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  @override
  Future<PaginatedResult<TopicModel>> getTopicsByTeacher(
    String teacherId, {
    int page = 1,
    int limit = 20,
  }) async {
    final res = await baseSendRequest(
      ApiConstants.topicsByTeacher(teacherId),
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

  @override
  Future<void> toggleLike(String topicId) =>
      baseSendRequest(ApiConstants.topicLike(topicId), HttpMethod.post);

  @override
  Future<List<TopicCommentModel>> getComments(String topicId) async {
    final res = await baseSendRequest(
      ApiConstants.topicComments(topicId),
      HttpMethod.get,
    );
    final data = res['data'] as List;
    return data
        .map((e) => TopicCommentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<TopicCommentModel> addComment({
    required String topicId,
    required String content,
    String? parentId,
  }) async {
    final res = await baseSendRequest(
      ApiConstants.topicComments(topicId),
      HttpMethod.post,
      data: {
        'content': content,
        if (parentId != null) 'parentId': parentId,
      },
    );
    return TopicCommentModel.fromJson(res['data'] as Map<String, dynamic>);
  }
}
