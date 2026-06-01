import '../../../../core/models/paginated_result.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_response_mapper.dart';
import '../../../../core/network/base_remote_datasource.dart';
import '../../../../core/network/http_method.dart';
import '../models/topic_comment_model.dart';
import '../models/topic_model.dart';

abstract class TopicsRemoteDataSource {
  Future<TopicModel> getTopic(String id);
  Future<PaginatedResult<TopicModel>> getTopicsByTeacher(String teacherId,
      {int page, int limit});
  Future<TopicModel> createTopic({
    required String type,
    required String title,
    String? description,
    String? visibility,
  });
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
    return ApiResponseMapper.single(res, TopicModel.fromJson);
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
    return ApiResponseMapper.paginated(res, TopicModel.fromJson);
  }

  @override
  Future<TopicModel> createTopic({
    required String type,
    required String title,
    String? description,
    String? visibility,
  }) async {
    final res = await baseSendRequest(
      ApiConstants.topics,
      HttpMethod.post,
      data: {
        'type': type,
        'title': title,
        if (description != null) 'description': description,
        if (visibility != null) 'visibility': visibility,
      },
    );
    return ApiResponseMapper.single(res, TopicModel.fromJson);
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
    return ApiResponseMapper.paginated(res, TopicCommentModel.fromJson).items;
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
    return ApiResponseMapper.single(res, TopicCommentModel.fromJson);
  }
}
