import '../../../../core/utils/result.dart';
import '../repositories/enrollments_repository.dart';

class UseFreezeUseCase {
  final EnrollmentsRepository _repository;
  const UseFreezeUseCase(this._repository);
  Future<Result<void>> call(String enrollmentId) => _repository.useFreeze(enrollmentId);
}
