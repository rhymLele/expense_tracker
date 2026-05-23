import '../../../../core/utils/result.dart';
import '../entities/enrollment_entity.dart';
import '../entities/today_tasks_entity.dart';

abstract class EnrollmentsRepository {
  Future<Result<List<EnrollmentEntity>>> getMyEnrollments();
  Future<Result<TodayTasksEntity>> getTodayTasks(String enrollmentId);
  Future<Result<void>> useFreeze(String enrollmentId);
}
