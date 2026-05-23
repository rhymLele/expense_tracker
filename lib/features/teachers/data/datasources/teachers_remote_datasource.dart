import '../../../../core/models/paginated_result.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/base_remote_datasource.dart';
import '../../../../core/network/http_method.dart';
import '../models/teacher_profile_model.dart';

abstract class TeachersRemoteDataSource {
  Future<PaginatedResult<TeacherProfileModel>> getTeachers({
    String? subject,
    int page = 1,
    int limit = 20,
  });

  Future<TeacherProfileModel> getTeacherProfile(String userId);

  Future<TeacherProfileModel> updateMyProfile({
    List<String>? subjects,
    String? teachingMode,
  });
}

class TeachersRemoteDataSourceImpl extends BaseRemoteDataSource
    implements TeachersRemoteDataSource {
  @override
  Future<PaginatedResult<TeacherProfileModel>> getTeachers({
    String? subject,
    int page = 1,
    int limit = 20,
  }) async {
    final res = await baseSendRequest(
      ApiConstants.teachers,
      HttpMethod.get,
      queryParameters: {
        if (subject != null) 'subject': subject,
        'page': page,
        'limit': limit,
      },
    );
    final data = res['data'] as List;
    return PaginatedResult(
      items: data
          .map((e) => TeacherProfileModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: res['count'] as int? ?? data.length,
    );
  }

  @override
  Future<TeacherProfileModel> getTeacherProfile(String userId) async {
    final res = await baseSendRequest(
      ApiConstants.teacherProfile(userId),
      HttpMethod.get,
    );
    return TeacherProfileModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  @override
  Future<TeacherProfileModel> updateMyProfile({
    List<String>? subjects,
    String? teachingMode,
  }) async {
    final res = await baseSendRequest(
      ApiConstants.myTeacherProfile,
      HttpMethod.patch,
      data: {
        if (subjects != null) 'subjects': subjects,
        if (teachingMode != null) 'teachingMode': teachingMode,
      },
    );
    return TeacherProfileModel.fromJson(res['data'] as Map<String, dynamic>);
  }
}
