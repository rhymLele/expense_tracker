// Today tasks are now loaded directly via EnrollmentsRemoteDataSource.getActive()
// which returns the active enrollment with roadmap.days[currentDayIndex].tasks.
// This use case is kept as a no-op stub to avoid removing callers.

import '../../../../core/errors/failure.dart';
import '../../../../core/utils/result.dart';
import '../entities/today_tasks_entity.dart';
import '../repositories/enrollments_repository.dart';

class GetTodayTasksUseCase {
  const GetTodayTasksUseCase(EnrollmentsRepository _);
  Future<Result<TodayTasksEntity>> call(String enrollmentId) async =>
      Result.failure(UnknownFailure('Use RoadmapHomeBloc instead'));
}
