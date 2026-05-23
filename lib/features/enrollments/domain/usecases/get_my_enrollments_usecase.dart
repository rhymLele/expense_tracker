import '../../../../core/utils/result.dart';
import '../entities/enrollment_entity.dart';
import '../repositories/enrollments_repository.dart';

class GetMyEnrollmentsUseCase {
  final EnrollmentsRepository _repository;
  const GetMyEnrollmentsUseCase(this._repository);
  Future<Result<List<EnrollmentEntity>>> call() => _repository.getMyEnrollments();
}
