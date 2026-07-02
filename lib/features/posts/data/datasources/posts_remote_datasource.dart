import '../../../../core/network/api_constants.dart';
import '../../../../core/network/base_remote_datasource.dart';
import '../../../../core/network/http_method.dart';
import '../models/post_model.dart';

abstract class PostsRemoteDataSource {
  Future<PostModel> createPost({
    required String content,
    List<String>? mediaUrls,
    String? roadmapId,
  });
  Future<void> toggleLike(String postId);
}

class PostsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements PostsRemoteDataSource {
  @override
  Future<PostModel> createPost({
    required String content,
    List<String>? mediaUrls,
    String? roadmapId,
  }) async {
    final res = await baseSendRequest(
      ApiConstants.posts,
      HttpMethod.post,
      data: {
        'content': content,
        if (mediaUrls != null && mediaUrls.isNotEmpty) 'mediaUrls': mediaUrls,
        if (roadmapId != null) 'roadmapId': roadmapId,
      },
    );
    final raw = res['data'];
    return PostModel.fromJson(raw as Map<String, dynamic>);
  }

  @override
  Future<void> toggleLike(String postId) =>
      baseSendRequest(ApiConstants.postLike(postId), HttpMethod.post);
}
