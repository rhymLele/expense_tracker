import '../../../../core/network/api_constants.dart';
import '../../../../core/network/base_remote_datasource.dart';
import '../../../../core/network/http_method.dart';
import '../models/submission_model.dart';

abstract class SubmissionsRemoteDataSource {
  Future<SubmissionModel> submitAnswer({
    required String enrollmentId,
    required String dayTaskId,
    required Map<String, dynamic> answer,
  });

  Future<List<SubmissionModel>> getEnrollmentSubmissions(String enrollmentId);
}

class SubmissionsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements SubmissionsRemoteDataSource {
  @override
  Future<SubmissionModel> submitAnswer({
    required String enrollmentId,
    required String dayTaskId,
    required Map<String, dynamic> answer,
  }) async {
    final res = await baseSendRequest(
      ApiConstants.submissions,
      HttpMethod.post,
      data: {
        'enrollmentId': enrollmentId,
        'dayTaskId': dayTaskId,
        'answer': answer,
      },
    );
    return SubmissionModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  @override
  Future<List<SubmissionModel>> getEnrollmentSubmissions(
      String enrollmentId) async {
    final res = await baseSendRequest(
      ApiConstants.submissionsByEnrollment(enrollmentId),
      HttpMethod.get,
    );
    final data = res['data'] as List;
    return data
        .map((e) => SubmissionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
