import '../../../../core/network/api_constants.dart';
import '../../../../core/network/base_remote_datasource.dart';
import '../../../../core/network/http_method.dart';
import '../../../teachers/data/models/teacher_profile_model.dart';

abstract class FollowsRemoteDataSource {
  Future<void> follow(String teacherId);
  Future<void> unfollow(String teacherId);
  Future<List<TeacherProfileModel>> getFollowing();
  Future<List<TeacherProfileModel>> getFollowers(String teacherId);
}

class FollowsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements FollowsRemoteDataSource {
  @override
  Future<void> follow(String teacherId) =>
      baseSendRequest(ApiConstants.followTeacher(teacherId), HttpMethod.post);

  @override
  Future<void> unfollow(String teacherId) =>
      baseSendRequest(ApiConstants.followTeacher(teacherId), HttpMethod.delete);

  @override
  Future<List<TeacherProfileModel>> getFollowing() async {
    final res = await baseSendRequest(ApiConstants.following, HttpMethod.get);
    final data = res['data'] as List;
    return data
        .map((e) => TeacherProfileModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<TeacherProfileModel>> getFollowers(String teacherId) async {
    final res = await baseSendRequest(
      ApiConstants.teacherFollowers(teacherId),
      HttpMethod.get,
    );
    final data = res['data'] as List;
    return data
        .map((e) => TeacherProfileModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
