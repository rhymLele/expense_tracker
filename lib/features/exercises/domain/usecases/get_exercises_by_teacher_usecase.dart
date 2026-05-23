import '../../../../core/models/paginated_result.dart';
import '../../../../core/utils/result.dart';
import '../entities/exercise_entity.dart';
import '../repositories/exercises_repository.dart';

class GetExercisesByTeacherUseCase {
  final ExercisesRepository _repository;
  const GetExercisesByTeacherUseCase(this._repository);

  Future<Result<PaginatedResult<ExerciseEntity>>> call(
    String teacherId, {
    int page = 1,
    int limit = 20,
  }) {
    return _repository.getExercisesByTeacher(teacherId, page: page, limit: limit);
  }
}
