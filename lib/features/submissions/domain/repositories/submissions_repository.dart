import '../../../../core/utils/result.dart';
import '../entities/submission_entity.dart';

abstract class SubmissionsRepository {
  Future<Result<SubmissionEntity>> submitAnswer({
    required String enrollmentId,
    required String dayTaskId,
    required Map<String, dynamic> answer,
  });

  Future<Result<List<SubmissionEntity>>> getEnrollmentSubmissions(String enrollmentId);
}
