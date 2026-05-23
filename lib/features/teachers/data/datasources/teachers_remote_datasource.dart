import '../../../../core/models/paginated_result.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_response_mapper.dart';
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
    return ApiResponseMapper.paginated(res, TeacherProfileModel.fromJson);
  }

  @override
  Future<TeacherProfileModel> getTeacherProfile(String userId) async {
    final res = await baseSendRequest(
      ApiConstants.teacherProfile(userId),
      HttpMethod.get,
    );
    return ApiResponseMapper.single(res, TeacherProfileModel.fromJson);
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
    return ApiResponseMapper.single(res, TeacherProfileModel.fromJson);
  }
}
