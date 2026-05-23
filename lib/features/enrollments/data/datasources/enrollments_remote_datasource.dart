import '../../../../core/network/api_constants.dart';
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
    final data = res['data'] as List;
    return data
        .map((e) => EnrollmentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<TodayTasksModel> getTodayTasks(String enrollmentId) async {
    final res = await baseSendRequest(
      ApiConstants.todayTasks(enrollmentId),
      HttpMethod.get,
    );
    return TodayTasksModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> useFreeze(String enrollmentId) =>
      baseSendRequest(ApiConstants.useFreeze(enrollmentId), HttpMethod.post);
}
