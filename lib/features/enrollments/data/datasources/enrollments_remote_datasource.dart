import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_response_mapper.dart';
import '../../../../core/network/base_remote_datasource.dart';
import '../../../../core/network/http_method.dart';
import '../models/enrollment_model.dart';

abstract class EnrollmentsRemoteDataSource {
  Future<List<EnrollmentModel>> getMyEnrollments();
  Future<TodayTasksModel> getTodayTasks(String enrollmentId);
  Future<void> useFreeze(String enrollmentId);
}

class EnrollmentsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements EnrollmentsRemoteDataSource {
  @override
  Future<List<EnrollmentModel>> getMyEnrollments() async {
    final res = await baseSendRequest(ApiConstants.myEnrollments, HttpMethod.get);
    return ApiResponseMapper.paginated(res, EnrollmentModel.fromJson).items;
  }

  @override
  Future<TodayTasksModel> getTodayTasks(String enrollmentId) async {
    final res = await baseSendRequest(
      ApiConstants.todayTasks(enrollmentId),
      HttpMethod.get,
    );
    return ApiResponseMapper.single(res, TodayTasksModel.fromJson);
  }

  @override
  Future<void> useFreeze(String enrollmentId) =>
      baseSendRequest(ApiConstants.useFreeze(enrollmentId), HttpMethod.post);
}
