import '../../../../core/utils/result.dart';
import '../entities/submission_entity.dart';
import '../repositories/submissions_repository.dart';

class GetEnrollmentSubmissionsUseCase {
  final SubmissionsRepository _repository;
  const GetEnrollmentSubmissionsUseCase(this._repository);
  Future<Result<List<SubmissionEntity>>> call(String enrollmentId) =>
      _repository.getEnrollmentSubmissions(enrollmentId);
}
