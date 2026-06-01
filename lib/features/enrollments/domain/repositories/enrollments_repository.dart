import '../../../../core/utils/result.dart';
import '../entities/enrollment_entity.dart';

abstract class EnrollmentsRepository {
  Future<Result<List<EnrollmentEntity>>> getMyEnrollments();
  Future<Result<void>> useFreeze(String enrollmentId);
}
