import '../../../../core/utils/result.dart';
import '../entities/today_tasks_entity.dart';
import '../repositories/enrollments_repository.dart';

class GetTodayTasksUseCase {
  final EnrollmentsRepository _repository;
  const GetTodayTasksUseCase(this._repository);
  Future<Result<TodayTasksEntity>> call(String enrollmentId) =>
      _repository.getTodayTasks(enrollmentId);
}
